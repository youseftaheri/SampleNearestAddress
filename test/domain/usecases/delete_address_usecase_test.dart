import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_nearest_address/data/error/exceptions.dart';
import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/data/repositories/abstract/add_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/delete_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/get_addresses_repository.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/add_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/delete_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/get_addresses_usecase.dart';
import 'package:sample_nearest_address/utils/strings.dart';
import '../../fixtures/fixture_reader.dart';
import 'use_case_test_include.dart';

@GenerateMocks([DeleteAddressRepository])
void main() {

  setupLocator();
  late MockTestAppWrapper testApp;
  late DeleteAddressUseCase deleteAddressUseCase;
  late DeleteAddressParams deleteAddressParams;

  setUp(() async {
    testApp = MockTestAppWrapper();
    deleteAddressUseCase = DeleteAddressUseCaseImpl();
    deleteAddressParams = DeleteAddressParams(0);
  });
  group('Get list of addresses ', () {
    test(
      'should return list of addresses when deleteAddressUseCase.execute is successful',
          () async {
        // arrange
        sl.registerLazySingleton<DeleteAddressRepository>(() => testApp,);
        when(testApp.getDeleteAddress(deleteAddressParams.index))
            .thenAnswer((_) async => 1
        );
        // act
        final result = await deleteAddressUseCase.execute(deleteAddressParams);
        // assert
        expect(result.result, equals(1));
      },
    );
  });

  group('Get exception ', () {
    test(
      'should return failure when deleteAddressUseCase.execute is unsuccessful',
          () async {
        // arrange
            sl.registerLazySingleton<DeleteAddressRepository>(() => testApp,);
            when(testApp.getDeleteAddress(deleteAddressParams.index))
            .thenThrow(DeleteAddressException(message: Strings.somethingWentWrong));
        // act and assert
            expect(deleteAddressUseCase.execute(deleteAddressParams)
              , throwsA(isA<DeleteAddressException>()),
            );
      },
    );
  });
}