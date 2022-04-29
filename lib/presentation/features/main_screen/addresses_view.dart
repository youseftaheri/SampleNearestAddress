import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:legacy_buttons/LegacyRaisedButton.dart';
import 'dart:developer';
import 'package:sample_nearest_address/data/model/nearestAddressData.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/find_nearest_address_usecase.dart';
import '../../../../config/theme.dart';
import '../../../../presentation/widgets/extensions/address_view.dart';
import '../../../data/model/addressData.dart';
import '../../../locator.dart';
import '../../../utils/alertStyle.dart';
import '../../../utils/show_custom_alert_popup.dart';
import '../../../utils/strings.dart';
import '../../widgets/independent/CustomBackground.dart';
import '../../widgets/independent/loading_view.dart';
import '../../widgets/independent/specification_row.dart';
import 'addresses_bloc.dart';
import 'addresses_event.dart';
import 'addresses_state.dart';

class AddressListView extends StatefulWidget {
  const AddressListView({Key? key}) : super(key: key);

  @override
  _AddressListViewState createState() => _AddressListViewState();
}

class _AddressListViewState extends State<AddressListView>  with TickerProviderStateMixin {

  final _listItems = <Widget>[];
  String _addressText = '';
  TextEditingController addressText = TextEditingController();
  FocusNode addressTextFocus = FocusNode();
  final GetNearestAddressUseCase getNearestAddressUseCase = sl();
  late NearestAddress nearestAddress;
  bool completeAddresses = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    addressText.clear();
    addressTextFocus.unfocus();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose(){
    _connectivitySubscription.cancel();
    addressText.clear();
    addressTextFocus.unfocus();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<NearestAddress> getNearestAddress(double latitude, double longitude) async{
    final nearestAddressResult = await getNearestAddressUseCase.execute(
        GetNearestAddressParams(latitude, longitude));
    return nearestAddressResult.nearestAddress;
  }

  void _loadItems(List<Widget> addresses) {
    final fetchedList = addresses;
    _listItems.clear();
    for (var i = 0; i < fetchedList.length; i++) {
      _listItems.add(fetchedList[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return
      Scaffold(
          body:
          SafeArea(child:
          // Stack(children: <Widget>[
          BlocConsumer<AddressesBloc, AddressesState>(
              listener: (BuildContext context, AddressesState state) {
                if (state is ErrorState) {
                  showCustomAlertPopup(context: context,
                    type: 'fail',
                    style: alertStyle(),
                    title: '',
                    message: state.error.toString(),
                    button1: Strings.gotItButton,
                    onTap1: () {
                      Navigator.of(context).pop(true);
                      BlocProvider.of<AddressesBloc>(context).add(
                          const ShowAddressListEvent());
                    },
                    button2: '',
                    onTap2: () {},
                  );
                }
              },
              builder: (BuildContext context, AddressesState state) {
                if (state is AddressListLoadingState ) {
                  return const LoadingView();
                }else
                if (state is AllAddressListViewState) {
                  _loadItems(buildAddressList(state.addresses));
                  completeAddresses = state.addresses.length >= 4;
                  return Stack(children: <Widget>[
                    const CustomBackground(),
                    state.addresses.isEmpty
                        ?
                    Align(
                        alignment: Alignment.center,
                        child:
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child:
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text(Strings.emptyAddressList, textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption?.copyWith(
                                  color: AppColors.red, fontSize: 18),
                            ),
                          ),
                        )
                    )
                        :
                    ListView.builder
                      (padding: const EdgeInsets.only(bottom: 40, top: 30),
                        itemCount: _listItems.length,
                        itemBuilder: (context, index) {
                          return _listItems[index];
                        }
                    ),

                    !completeAddresses ?
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: FloatingActionButton(
                          heroTag: 'createAddressFabHeroTag',
                          backgroundColor: AppColors.red,
                          mini: false,
                          onPressed: createAddressBottomSheet,
                          child:
                          Container(
                            padding: EdgeInsets.all(MediaQuery
                                .of(context)
                                .size
                                .width * 0.02),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                        :
                    Container(),

                    completeAddresses ?
                    Align(
                        alignment: Alignment.bottomCenter,
                        child:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child:
                          LegacyRaisedButton(
                            onPressed: (() async =>
                            {
                              await _determinePosition() .then((Position position) async {
                                await getNearestAddress(position.latitude, position.longitude)
                                    .then((NearestAddress nearestAddress){
                                  nearestAddressBottomSheet(nearestAddress);
                                });
                              })
                            }
                            ),
                            color: AppColors.red,
                            padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                            splashColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: AppColors.red)
                            ),
                            child:
                            const Text(Strings.findNearestButton, textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16,
                                  color:  AppColors.white,
                                  fontWeight: FontWeight.normal
                              ),
                            ),
                          ),
                        )
                    )
                        :
                    Container(),

                    _connectionStatus == ConnectivityResult.none ?
                    Align(
                        alignment: Alignment.topCenter,
                        child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top:100),
                                alignment: Alignment.center,
                                width: width,
                                color: AppColors.black,
                                child:
                                const Text(Strings.noInternetConnection, textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14,
                                      color:  AppColors.white,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ),
                            ])
                    )
                        :
                    Container()
                  ],
                  );
                }
                return Container();
              }),
            // inProgress? Container():
            // Center(
            //   child: Lottie.asset('assets/lottieFiles/loading_1.json',
            //       width: 110,
            //       height: 110,
            //       fit: BoxFit.fill
            //   ),
            // )
            //
            //   ])
          )
      );
  }

  List<Widget> buildAddressList(List<Address> addresses) {
    var elements = <Widget>[];
    for (var i = 0; i < addresses.length; i++) {
      elements.add(
          addresses[i].getListView(
              context: context,
              deleteFunction: () {
                BlocProvider.of<AddressesBloc>(context).add(
                    RemoveFromAddressListEvent(i));
              },
              editFunction: () {
                editAddressBottomSheet(i, addresses[i]);
              },
              index: i
          )
      );
    }
    return elements;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCustomAlertPopup(context: context,
        type: 'fail',
        style: alertStyle(),
        title: '',
        message: Strings.locationServicesAreDisabled,
        button1: 'OK',
        onTap1: () {
          Navigator.of(context).pop(true);
        },
        button2: '',
        onTap2: () {},);
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showCustomAlertPopup(context: context,
          type: 'fail',
          style: alertStyle(),
          title: '',
          message: Strings.locationPermissionsAreDenied,
          button1: 'OK',
          onTap1: () {
            Navigator.of(context).pop(true);
          },
          button2: '',
          onTap2: () {},);
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showCustomAlertPopup(context: context,
        type: 'fail',
        style: alertStyle(),
        title: '',
        message: Strings.locationPermissionsArePermanentlyDenied,
        button1: 'OK',
        onTap1: () {
          Navigator.of(context).pop(true);
        },
        button2: '',
        onTap2: () {},);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<dynamic> editAddressBottomSheet(int index, Address address) {
    _addressText = address.addressText;
    addressText.text = address.addressText;
    var width = MediaQuery.of(context).size.width;
    return
      showModalBottomSheet(
          backgroundColor: AppColors.lightGreen,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34)),
          ),
          context: context,
          builder: (context) {
            return
              SingleChildScrollView(
                  child: Container(
                      padding:
                      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 22,
                                  left: 22,
                                  bottom: 30,
                                  top: 10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Card(
                                      margin: EdgeInsets.only(right: width * 0.35, left: width*0.35) ,
                                      color: AppColors.red,
                                      elevation: 1,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(AppSizes.imageRadius *2)),
                                      ),
                                      child: Container(height: 3),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),

                                    Container(
                                        padding: const EdgeInsets.only(top: 10, left: 20,right: 20, bottom: 20),
                                        child:
                                        TextField(
                                          onChanged:  (value) {
                                            Future.delayed(Duration.zero, () => setState(() {_addressText = value;}));
                                          },
                                          obscureText: false,
                                          controller: addressText,
                                          cursorColor: AppColors.colorPrimary,
                                          focusNode:  addressTextFocus,
                                          minLines: 3,
                                          maxLines: 6,
                                          style: const TextStyle(
                                            height: 1,
                                            color: AppColors.colorPrimary ,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.5,
                                          ),
                                          decoration: InputDecoration(
                                            labelStyle: const TextStyle(color:AppColors.colorPrimary ),
                                            focusColor:AppColors.white,
                                            filled: true,
                                            counterText: '',
                                            enabledBorder: UnderlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: const BorderSide(color:AppColors.colorPrimary),
                                            ),
                                            labelText: 'Address',
                                            hintStyle: const TextStyle(color: AppColors.colorPrimary, fontSize: 13),
                                            prefixIcon: const Icon(
                                              Icons.location_on_outlined,
                                              size: 20,
                                              color:AppColors.whiteColor,
                                            ),
                                          ),
                                        )
                                    ),


                                    Align(
                                      alignment: Alignment.center,
                                      child:
                                      LegacyRaisedButton(
                                        onPressed: (() => {
                                          Navigator.pop(context),
                                          BlocProvider.of<AddressesBloc>(context).add(
                                              EditAddressEvent(index, _addressText)),
                                        }
                                        ),
                                        color: AppColors.red,
                                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        splashColor: AppColors.colorPrimaryBack2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            side: const BorderSide(color: AppColors.red)
                                        ),
                                        child:
                                        const Text(Strings.edit, textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16,
                                              color:  AppColors.white,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                          })
                  ));
          });
  }

  Future<dynamic> createAddressBottomSheet() {
    _addressText = "";
    addressText.text = "";
    var width = MediaQuery.of(context).size.width;
    return
      showModalBottomSheet(
          backgroundColor: AppColors.lightGreen,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34)),
          ),
          context: context,
          builder: (context) {
            return
              SingleChildScrollView(
                  child: Container(
                      padding:
                      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child:
                      StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 22,
                                  left: 22,
                                  bottom: 30,
                                  top: 10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Card(
                                      margin: EdgeInsets.only(right: width * 0.35, left: width*0.35) ,
                                      color: AppColors.red,
                                      elevation: 1,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(AppSizes.imageRadius *2)),
                                      ),
                                      child: Container(height: 3),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.only(top: 10, left: 20,right: 20, bottom: 20),
                                        child:
                                        TextField(
                                          onChanged:  (value) {
                                            Future.delayed(Duration.zero, () => setState(() {_addressText = value;}));
                                          },
                                          obscureText: false,
                                          controller: addressText,
                                          cursorColor: AppColors.colorPrimary,
                                          focusNode:  addressTextFocus,
                                          minLines: 3,
                                          maxLines: 6,
                                          style: const TextStyle(
                                            height: 1,
                                            color: AppColors.colorPrimary ,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.5,
                                          ),
                                          decoration: InputDecoration(
                                            labelStyle: const TextStyle(color:AppColors.colorPrimary ),
                                            focusColor:AppColors.white,
                                            filled: true,
                                            counterText: '',
                                            enabledBorder: UnderlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: const BorderSide(color:AppColors.colorPrimary),
                                            ),
                                            labelText: 'Address',
                                            hintStyle: const TextStyle(color: AppColors.colorPrimary, fontSize: 13),
                                            prefixIcon: const Icon(
                                              Icons.location_on_outlined,
                                              size: 20,
                                              color:AppColors.whiteColor,
                                            ),
                                          ),
                                        )
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child:
                                      LegacyRaisedButton(
                                        onPressed: (() => {
                                          Navigator.pop(context),
                                          BlocProvider.of<AddressesBloc>(context).add(
                                              AddAddressEvent(_addressText)),
                                        }
                                        ),
                                        color: AppColors.red,
                                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        splashColor: AppColors.colorPrimaryBack2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            side: const BorderSide(color: AppColors.red)
                                        ),
                                        child:
                                        const Text(Strings.add, textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16,
                                              color:  AppColors.white,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                          })
                  ));
          });
  }

  Future<dynamic> nearestAddressBottomSheet(NearestAddress nearestAddress) {
    var width = MediaQuery.of(context).size.width;
    return
      showModalBottomSheet(
          backgroundColor: AppColors.lightGreen,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34)),
          ),
          context: context,
          builder: (context) {
            return
              SingleChildScrollView(
                  child: Container(
                      padding:
                      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30,
                                  left: 30,
                                  bottom: 30,
                                  top: 20,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Card(
                                      margin: EdgeInsets.only(right: width * 0.35, left: width*0.35) ,
                                      color: AppColors.red,
                                      elevation: 1,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(AppSizes.imageRadius *2)),
                                      ),
                                      child: Container(height: 3),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SpecificationRow(title: Strings.nearestAddressTitle, value: nearestAddress.address.addressText),
                                    const SizedBox(height: 10,),
                                    SpecificationRow(title: Strings.latitudeTitle, value: nearestAddress.address.latitude.toString()),
                                    const SizedBox(height: 10,),
                                    SpecificationRow(title: Strings.longitudeTitle, value: nearestAddress.address.longitude.toString()),
                                    const SizedBox(height: 10,),
                                    SpecificationRow(title: Strings.distanceTitle, value:
                                    ((nearestAddress.distance/1000).round()>1.0 ?
                                    (nearestAddress.distance/1000).round().toString() + " Km & " : "") +
                                        (nearestAddress.distance % 1000).round().toString() + " m"),
                                  ],
                                ),
                              );
                          })
                  ));
          });
  }
}