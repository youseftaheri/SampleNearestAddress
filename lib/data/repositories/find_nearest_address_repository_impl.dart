import 'package:sample_nearest_address/data/model/nearestAddressData.dart';
import '../../config/sharedPreferences.dart';
import '../../utils/strings.dart';
import '../error/exceptions.dart';
import '../model/addressData.dart';
import 'abstract/find_nearest_address_repository.dart';
import 'package:geolocator/geolocator.dart';

class GetNearestAddressRepositoryImpl extends GetNearestAddressRepository {

  double minDistanceInMeters = 0.0;
  @override
  Future<NearestAddress> getGetNearestAddress(
      double latitude,
      double longitude,
      ) async {
    try {
      final String addressesString = await getStringValuesSF(
          key: 'address_list');
      final List<Address> addresses = Address.decode(addressesString);
      minDistanceInMeters = Geolocator.distanceBetween(
          addresses[0].latitude, addresses[0].longitude,
          latitude, longitude);
      Address nearestAddress = addresses[0];
      for(int i=1; i<addresses.length; i++){
        if(Geolocator.distanceBetween(
            addresses[i].latitude, addresses[i].longitude,
            latitude, longitude)<minDistanceInMeters) {
          nearestAddress = addresses[i];
        }
      }
      return NearestAddress(
          status: 1,
          address: nearestAddress,
          distance: minDistanceInMeters);
    }catch(error){
      throw FindNearestAddressException(message: Strings.somethingWentWrongInFindingNearest);
    }
  }
}
