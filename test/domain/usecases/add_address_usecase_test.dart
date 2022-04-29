import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_nearest_address/data/error/exceptions.dart';
import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/data/repositories/abstract/add_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/get_addresses_repository.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/add_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/get_addresses_usecase.dart';
import 'package:sample_nearest_address/utils/strings.dart';
import '../../fixtures/fixture_reader.dart';
import 'use_case_test_include.dart';

@GenerateMocks([AddAddressRepository])
void main() {

  setupLocator();
  late MockTestAppWrapper testApp;
  late AddAddressUseCase addAddressUseCase;
  late AddAddressParams addAddressParams;

  setUp(() async {
    testApp = MockTestAppWrapper();
    addAddressUseCase = AddAddressUseCaseImpl();
    addAddressParams = AddAddressParams("qatar");
  });
  group('Get list of addresses ', () {
    test(
      'should return list of addresses when addAddressUseCase.execute is successful',
          () async {
        // arrange
        sl.registerLazySingleton<AddAddressRepository>(() => testApp,);
        when(testApp.getAddAddress(addAddressParams.addressText))
            .thenAnswer((_) async => 1
        );
        // act
        final result = await addAddressUseCase.execute(addAddressParams);
        // assert
        expect(result.result, equals(1));
      },
    );
  });

  group('Get exception ', () {
    test(
      'should return failure when addAddressUseCase.execute is unsuccessful',
          () async {
        // arrange
            sl.registerLazySingleton<AddAddressRepository>(() => testApp,);
            when(testApp.getAddAddress(addAddressParams.addressText))
            .thenThrow(AddAddressException(message: Strings.somethingWentWrong));
        // act and assert
            expect(addAddressUseCase.execute(addAddressParams)
              , throwsA(isA<AddAddressException>()),
            );
      },
    );
  });
}