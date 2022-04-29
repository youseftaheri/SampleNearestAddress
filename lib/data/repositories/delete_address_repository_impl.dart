import '../../config/sharedPreferences.dart';
import '../../utils/strings.dart';
import '../error/exceptions.dart';
import '../model/addressData.dart';
import 'abstract/delete_address_repository.dart';

class DeleteAddressRepositoryImpl extends DeleteAddressRepository {

  @override
  Future<int> getDeleteAddress(int index) async {
    try {
      final String addressesString = await getStringValuesSF(
          key: 'address_list');
      final List<Address> addresses = Address.decode(addressesString);
      addresses.removeAt(index);
      final String encodedData = Address.encode(addresses);
      await addStringToSF(key: 'address_list', value: encodedData);
    }catch(error){
      throw DeleteAddressException(message: Strings.somethingWentWrong);
    }
    return 1;//Done successfully
  }
}
