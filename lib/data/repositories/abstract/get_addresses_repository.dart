import 'package:sample_nearest_address/data/model/addressData.dart';

abstract class GetAddressesRepository {
  Future<List<Address>>? getGetAddresses();
}
