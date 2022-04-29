import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_nearest_address/data/error/exceptions.dart';
import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/data/repositories/abstract/add_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/edit_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/get_addresses_repository.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/add_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/edit_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/get_addresses_usecase.dart';
import 'package:sample_nearest_address/utils/strings.dart';
import '../../fixtures/fixture_reader.dart';
import 'use_case_test_include.dart';

@GenerateMocks([EditAddressRepository])
void main() {

  setupLocator();
  late MockTestAppWrapper testApp;
  late EditAddressUseCase editAddressUseCase;
  late EditAddressParams editAddressParams;

  setUp(() async {
    testApp = MockTestAppWrapper();
    editAddressUseCase = EditAddressUseCaseImpl();
    editAddressParams = EditAddressParams(1,"spain");
  });
  group('Get list of addresses ', () {
    test(
      'should return list of addresses when editAddressUseCase.execute is successful',
          () async {
        // arrange
        sl.registerLazySingleton<EditAddressRepository>(() => testApp,);
        when(testApp.getEditAddress(
            editAddressParams.index,
            editAddressParams.addressText))
            .thenAnswer((_) async => 1
        );
        // act
        final result = await editAddressUseCase.execute(editAddressParams);
        // assert
        expect(result.result, equals(1));
      },
    );
  });

  group('Get exception ', () {
    test(
      'should return failure when editAddressUseCase.execute is unsuccessful',
          () async {
        // arrange
            sl.registerLazySingleton<EditAddressRepository>(() => testApp,);
            when(testApp.getEditAddress(
                editAddressParams.index,
                editAddressParams.addressText))
            .thenThrow(EditAddressException(message: Strings.somethingWentWrong));
        // act and assert
            expect(editAddressUseCase.execute(editAddressParams)
              , throwsA(isA<EditAddressException>()),
            );
      },
    );
  });
}