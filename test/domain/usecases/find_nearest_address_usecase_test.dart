import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_nearest_address/data/error/exceptions.dart';
import 'package:sample_nearest_address/data/model/nearestAddressData.dart';
import 'package:sample_nearest_address/data/repositories/abstract/find_nearest_address_repository.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/find_nearest_address_usecase.dart';
import 'package:sample_nearest_address/utils/strings.dart';
import '../../fixtures/fixture_reader.dart';
import 'use_case_test_include.dart';

@GenerateMocks([GetNearestAddressRepository])
void main() {

  setupLocator();
  late MockTestAppWrapper testApp;
  late GetNearestAddressUseCase getNearestAddressUseCase;
  late GetNearestAddressParams getNearestAddressParams;

  setUp(() async {
    testApp = MockTestAppWrapper();
    getNearestAddressUseCase = GetNearestAddressUseCaseImpl();
    getNearestAddressParams = GetNearestAddressParams(42.12, 35.21);
  });
  group('Get nearest address info ', () {
    test(
      'should return nearest address info when getNearestAddressUseCase.execute is successful',
          () async {
        // arrange
            var a = json.decode(fixture('testApp/nearestAddressData.json'));
            var b = NearestAddress.fromJson(a);
            var c=b;
        sl.registerLazySingleton<GetNearestAddressRepository>(() => testApp,);
        when(testApp.getGetNearestAddress(
            getNearestAddressParams.latitude,
            getNearestAddressParams.longitude))
            .thenAnswer((_) async =>
            NearestAddress.fromJson(json.decode(fixture('testApp/nearestAddressData.json')))
        );
        // act
        final nearestAddress = await getNearestAddressUseCase.execute(getNearestAddressParams);
        // assert
        expect(nearestAddress.nearestAddress.address.addressText, "iran");
      },
    );
  });

  group('Get exception ', () {
    test(
      'should return failure when getNearestAddressUseCase.execute is unsuccessful',
          () async {
        // arrange
            sl.registerLazySingleton<GetNearestAddressRepository>(() => testApp,);
            when(testApp.getGetNearestAddress(
                getNearestAddressParams.latitude,
                getNearestAddressParams.longitude))
            .thenThrow(FindNearestAddressException(message: Strings.somethingWentWrong));
        // act and assert
            expect(getNearestAddressUseCase.execute(getNearestAddressParams)
              , throwsA(isA<FindNearestAddressException>()),
            );
      },
    );
  });
}