import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/data/model/nearestAddressData.dart';

abstract class GetNearestAddressRepository {
  Future<NearestAddress>? getGetNearestAddress(
      double latitude,
      double longitude,
      );
}
