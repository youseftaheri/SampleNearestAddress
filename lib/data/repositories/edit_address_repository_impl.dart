import 'package:sample_nearest_address/utils/strings.dart';
import '../../config/sharedPreferences.dart';
import '../error/exceptions.dart';
import '../model/addressData.dart';
import 'package:geocoding/geocoding.dart';
import 'abstract/edit_address_repository.dart';

class EditAddressRepositoryImpl extends EditAddressRepository {

  @override
  Future<int> getEditAddress(
      int index,
      String addressText
      ) async {
    try {
      final String addressesString = await getStringValuesSF(
          key: 'address_list');
      final List<Address> addresses = Address.decode(addressesString);
      await locationFromAddress(addressText)
          .then((locations) async {
        if (locations.isNotEmpty) {
          Address newAddress = Address(
              latitude: locations[0].latitude,
              longitude: locations[0].longitude,
              addressText: addressText);
          addresses[index] = newAddress;
          final String encodedData = Address.encode(addresses);
          await addStringToSF(key: 'address_list', value: encodedData);
        }else{
          throw EditAddressException(message: "Invalid address string");
        }
      });
    }catch(error){
      throw EditAddressException(message: Strings.somethingWentWrongInFindingLocation);
    }
    return 1;//Done successfully
  }
}
