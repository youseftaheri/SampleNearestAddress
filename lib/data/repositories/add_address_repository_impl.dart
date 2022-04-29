import '../../config/sharedPreferences.dart';
import '../../utils/strings.dart';
import '../error/exceptions.dart';
import '../model/addressData.dart';
import 'abstract/add_address_repository.dart';
import 'package:geocoding/geocoding.dart';

class AddAddressRepositoryImpl extends AddAddressRepository {

  @override
  Future<int> getAddAddress(String addressText) async {
    try {
      final String addressesString = await getStringValuesSF(
          key: 'address_list', defaultValue: Address.encode(List.empty()));
      final List<Address> addresses = Address.decode(addressesString);
      await locationFromAddress(addressText,localeIdentifier: "en")
          .then((locations) async {
        if (locations.isNotEmpty) {
          Address newAddress = Address(
              latitude: locations[0].latitude,
              longitude: locations[0].longitude,
              addressText: addressText);
          addresses.add(newAddress);
          final String encodedData = Address.encode(addresses);
          await addStringToSF(key: 'address_list', value: encodedData);
        }else{
          throw AddAddressException(message: "Invalid address string");
        }
      });
    }catch(error){
      throw AddAddressException(message: Strings.somethingWentWrongInFindingLocation);
    }
    return 1;//Done successfully
  }
}
