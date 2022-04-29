import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_nearest_address/data/error/exceptions.dart';
import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/data/repositories/abstract/get_addresses_repository.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/get_addresses_usecase.dart';
import 'package:sample_nearest_address/utils/strings.dart';
import '../../fixtures/fixture_reader.dart';
import 'use_case_test_include.dart';

@GenerateMocks([GetAddressesRepository])
void main() {

  setupLocator();
  late MockTestAppWrapper testApp;
  late GetAddressesUseCase getAddressesUseCase;
  late GetAddressesParams getAddressesParams;

  setUp(() async {
    testApp = MockTestAppWrapper();
    getAddressesUseCase = GetAddressesUseCaseImpl();
    getAddressesParams = GetAddressesParams();
  });
  group('Get list of addresses ', () {
    test(
      'should return list of addresses when getAddressesUseCase.execute is successful',
          () async {
        // arrange
        sl.registerLazySingleton<GetAddressesRepository>(() => testApp,);
        when(testApp.getGetAddresses())
            .thenAnswer((_) async =>
            Future.value(Address.decode(fixture('testApp/addressData.json')))
        );
        // act
        final addresses = await getAddressesUseCase.execute(getAddressesParams);
        // assert
        expect(addresses.addresses.length, equals(2));
      },
    );
  });

  group('Get exception ', () {
    test(
      'should return failure when getAddressesUseCase.execute is unsuccessful',
          () async {
        // arrange
            sl.registerLazySingleton<GetAddressesRepository>(() => testApp,);
            when(testApp.getGetAddresses())
            .thenThrow(ShowAddressesException(message: Strings.somethingWentWrong));
        // act and assert
            expect(getAddressesUseCase.execute(getAddressesParams)
              , throwsA(isA<ShowAddressesException>()),
            );
      },
    );
  });
}