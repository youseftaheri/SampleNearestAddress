import 'package:sample_nearest_address/data/model/nearestAddressData.dart';

import '../../../data/error/exceptions.dart';
import '../../../data/model/addressData.dart';
import '../../../data/repositories/abstract/find_nearest_address_repository.dart';
import '../../../locator.dart';
import '../../../utils/strings.dart';
import '../base_use_case.dart';

abstract class GetNearestAddressUseCase
    implements BaseUseCase<GetNearestAddressResult, GetNearestAddressParams> {}

class GetNearestAddressUseCaseImpl implements GetNearestAddressUseCase {
  @override
  Future<GetNearestAddressResult> execute(GetNearestAddressParams params) async {
    try {
      GetNearestAddressRepository _getNearestAddressRepository = sl();
      NearestAddress? nearestAddress = await _getNearestAddressRepository.getGetNearestAddress(
        params.latitude,
        params.longitude,
      );
      return GetNearestAddressResult(
          nearestAddress!,
      );
    } catch (e) {
      throw FindNearestAddressException(message: e is AddAddressException?
      e.message.toString(): Strings.somethingWentWrong);
    }
  }
}

class GetNearestAddressResult {
  final NearestAddress nearestAddress;

  GetNearestAddressResult(
      this.nearestAddress,
      );
}

class GetNearestAddressParams {
  final double latitude;
  final double longitude;

  GetNearestAddressParams(
      this.latitude,
      this.longitude,
      );
}