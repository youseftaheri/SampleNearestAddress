import '../../../data/error/exceptions.dart';
import '../../../data/model/addressData.dart';
import '../../../data/repositories/abstract/get_addresses_repository.dart';
import '../../../locator.dart';
import '../../../utils/strings.dart';
import '../base_use_case.dart';

abstract class GetAddressesUseCase
    implements BaseUseCase<GetAddressesResult, GetAddressesParams> {}


class GetAddressesUseCaseImpl implements GetAddressesUseCase {
  @override
  Future<GetAddressesResult> execute(GetAddressesParams params) async {
    try {
      GetAddressesRepository _getAddressesRepository = sl();
      List<Address>? addresses = await _getAddressesRepository.getGetAddresses();
      return GetAddressesResult(
          addresses!,
      );

    } catch (e) {
      throw ShowAddressesException(message: e is AddAddressException?
      e.message.toString(): Strings.somethingWentWrong);
    }
  }
}

class GetAddressesResult {
  final List<Address> addresses;

  GetAddressesResult(
      this.addresses,
      );
}

class GetAddressesParams {
  GetAddressesParams();
}