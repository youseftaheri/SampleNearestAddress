import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/utils/strings.dart';

import '../../../data/error/exceptions.dart';
import '../../../data/repositories/abstract/edit_address_repository.dart';
import '../../../locator.dart';
import '../base_use_case.dart';

abstract class EditAddressUseCase
    implements BaseUseCase<EditAddressResult, EditAddressParams> {}

class EditAddressUseCaseImpl implements EditAddressUseCase {
  @override
  Future<EditAddressResult> execute(EditAddressParams params) async {
    try {
      EditAddressRepository _editAddressRepository = sl();
      int? result = await _editAddressRepository.getEditAddress(
        params.index,
        params.addressText,
      );
      return EditAddressResult(
        result!,
      );
    } catch (e) {
      throw EditAddressException(message: e is EditAddressException?
      e.message.toString(): Strings.somethingWentWrong);
    }
  }
}

class EditAddressResult {
  final int result;

  EditAddressResult(
      this.result,
      );
}

class EditAddressParams {
  final int index;
  final String addressText;

  EditAddressParams(
      this.index,
      this.addressText,
      );
}