import '../../../data/error/exceptions.dart';
import '../../../data/repositories/abstract/delete_address_repository.dart';
import '../../../locator.dart';
import '../../../utils/strings.dart';
import '../base_use_case.dart';

abstract class DeleteAddressUseCase
    implements BaseUseCase<DeleteAddressResult, DeleteAddressParams> {}

class DeleteAddressUseCaseImpl implements DeleteAddressUseCase {
  @override
  Future<DeleteAddressResult> execute(DeleteAddressParams params) async {
    try {
      DeleteAddressRepository _deleteAddressRepository = sl();
      int? result = await _deleteAddressRepository.getDeleteAddress(
        params.index,
      );
      return DeleteAddressResult(
          result!,
      );

    } catch (e) {
      throw DeleteAddressException(message: e is DeleteAddressException?
      e.message.toString(): Strings.somethingWentWrong);
    }
  }
}

class DeleteAddressResult {
  final int result;

  DeleteAddressResult(
      this.result,
      );
}

class DeleteAddressParams {
  final int index;

  DeleteAddressParams(
    this.index,
  );
}