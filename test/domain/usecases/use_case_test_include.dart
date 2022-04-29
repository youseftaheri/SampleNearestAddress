import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_nearest_address/data/repositories/abstract/add_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/delete_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/edit_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/find_nearest_address_repository.dart';
import 'package:sample_nearest_address/data/repositories/abstract/get_addresses_repository.dart';

class MockTestAppWrapper extends Mock implements
    GetAddressesRepository,
    GetNearestAddressRepository,
    DeleteAddressRepository,
    AddAddressRepository,
    EditAddressRepository{ }

final sl = GetIt.instance;

void setupLocator() {
  sl.allowReassignment = true;

  MockTestAppWrapper testApp = MockTestAppWrapper();

  sl.registerLazySingleton<MockTestAppWrapper>(
        () => testApp,
  );
}