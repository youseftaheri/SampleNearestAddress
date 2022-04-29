import '../../../data/error/exceptions.dart';
import '../../../data/repositories/abstract/add_address_repository.dart';
import '../../../locator.dart';
import '../../../utils/strings.dart';
import '../base_use_case.dart';

abstract class AddAddressUseCase
    implements BaseUseCase<AddAddressResult, AddAddressParams> {}

class AddAddressUseCaseImpl implements AddAddressUseCase {
  @override
  Future<AddAddressResult> execute(AddAddressParams params) async {
    try {
      AddAddressRepository _addAddressRepository = sl();
      int? result = await _addAddressRepository.getAddAddress(
        params.addressText,
      );
      return AddAddressResult(
          result!,
      );

    } catch (e) {
          throw AddAddressException(message: e is AddAddressException?
          e.message.toString(): Strings.somethingWentWrong);
    }
  }
}

class AddAddressResult {
  final int result;

  AddAddressResult(
      this.result,
      );

}

class AddAddressParams {
  final String addressText;

  AddAddressParams(
    this.addressText,
  );
}