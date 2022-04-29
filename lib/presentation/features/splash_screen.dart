import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_nearest_address/presentation/features/main_screen/addresses.dart';
import 'package:sample_nearest_address/presentation/widgets/independent/CustomBackground.dart';
import 'package:sample_nearest_address/utils/alertStyle.dart';
import 'package:sample_nearest_address/utils/show_custom_alert_popup.dart';
import '../../config/theme.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool showUpdatePopup = false;

  Future<Null> startTime() async {
    var _duration = const Duration(seconds: 3);
    Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    _navigateToLoginRegister(context);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  Future<bool> _onWillPop() async {
    return (
        showCustomAlertPopup(context: context,
          type: 'fail',
          style: alertStyle(),
          title: '',
          message: 'Are you sure you want to EXIT?',
          button1: 'Yes',
          onTap1:() {
            SystemNavigator.pop();
          },
          button2: 'No',
          onTap2: () {
            Navigator.of(context).pop(false);
          },)
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: _onWillPop,
          child:
        Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                const Positioned.fill(child: CustomBackground()),
                Align(
                    alignment: Alignment.center,
                    child:
                    Image.asset('assets/img/address_logo.webp',
                      fit: BoxFit.cover,
                      width: 200,)
                ),
              ],
            )
        )
      );

  }

  void _navigateToLoginRegister(BuildContext context) =>
      Navigator.pushReplacement(context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1500),
              child: const AddressListView() // LoginRegisterScreen()
          )
      );
}