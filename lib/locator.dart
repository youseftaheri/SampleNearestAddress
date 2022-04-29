import 'package:get_it/get_it.dart';
import 'data/repositories/abstract/add_address_repository.dart';
import 'data/repositories/abstract/delete_address_repository.dart';
import 'data/repositories/abstract/edit_address_repository.dart';
import 'data/repositories/abstract/find_nearest_address_repository.dart';
import 'data/repositories/abstract/get_addresses_repository.dart';
import 'data/repositories/add_address_repository_impl.dart';
import 'data/repositories/delete_address_repository_impl.dart';
import 'data/repositories/edit_address_repository_impl.dart';
import 'data/repositories/find_nearest_address_repository_impl.dart';
import 'data/repositories/get_addresses_repository_impl.dart';
import 'domain/usecases/addresses/add_address_usecase.dart';
import 'domain/usecases/addresses/delete_address_usecase.dart';
import 'domain/usecases/addresses/edit_address_usecase.dart';
import 'domain/usecases/addresses/find_nearest_address_usecase.dart';
import 'domain/usecases/addresses/get_addresses_usecase.dart';

final sl = GetIt.instance;

//Service locator description
void init() {
  sl.registerLazySingleton<GetAddressesRepository>(() => GetAddressesRepositoryImpl(),);
  sl.registerFactory<GetAddressesUseCase>(() => GetAddressesUseCaseImpl());

  sl.registerLazySingleton<AddAddressRepository>(() => AddAddressRepositoryImpl(),);
  sl.registerFactory<AddAddressUseCase>(() => AddAddressUseCaseImpl());

  sl.registerLazySingleton<DeleteAddressRepository>(() => DeleteAddressRepositoryImpl(),);
  sl.registerFactory<DeleteAddressUseCase>(() => DeleteAddressUseCaseImpl());

  sl.registerLazySingleton<EditAddressRepository>(() => EditAddressRepositoryImpl(),);
  sl.registerFactory<EditAddressUseCase>(() => EditAddressUseCaseImpl());

  sl.registerLazySingleton<GetNearestAddressRepository>(() => GetNearestAddressRepositoryImpl(),);
  sl.registerFactory<GetNearestAddressUseCase>(() => GetNearestAddressUseCaseImpl());
}
