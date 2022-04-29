import '../../config/sharedPreferences.dart';
import '../model/addressData.dart';
import 'abstract/get_addresses_repository.dart';

class GetAddressesRepositoryImpl extends GetAddressesRepository {

  @override
  Future<List<Address>> getGetAddresses() async {
    final String addressesString = await getStringValuesSF(key: 'address_list',
        defaultValue: Address.encode(List.empty()));
    final List<Address> addresses = Address.decode(addressesString);
    return addresses;
  }
}
