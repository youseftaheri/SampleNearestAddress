import 'package:bloc/bloc.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/add_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/delete_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/edit_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/find_nearest_address_usecase.dart';
import 'package:sample_nearest_address/domain/usecases/addresses/get_addresses_usecase.dart';
import '../../../data/error/exceptions.dart';
import '../../../utils/strings.dart';
import '../../../locator.dart';
import 'addresses.dart';
class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {

  final AddAddressUseCase addAddressUseCase = sl();
  final DeleteAddressUseCase deleteAddressUseCase = sl();
  final EditAddressUseCase editAddressUseCase = sl();
  final GetAddressesUseCase getAddressesUseCase = sl();
  final GetNearestAddressUseCase getNearestAddressUseCase = sl();

  AddressesBloc() : super(InitialState()){

    on<ShowAddressListEvent>((event, emit) async  {
      try {
        emit(AddressListLoadingState());
        GetAddressesResult getAddressesResult = await getAddressesUseCase
            .execute(GetAddressesParams());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        emit(AllAddressListViewState(addresses: getAddressesResult.addresses));
      }catch(error){
        emit(ErrorState(error: error is ShowAddressesException? error.message : Strings.somethingWentWrong));
      }
    });

    on<RemoveFromAddressListEvent>((event, emit) async  {
      try {
        emit(AddressListLoadingState());
      await deleteAddressUseCase.execute(
          DeleteAddressParams(event.addressIndex,)
      );
      GetAddressesResult getAddressesResult = await getAddressesUseCase.execute(GetAddressesParams());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      emit(AllAddressListViewState(addresses: getAddressesResult.addresses));
    }catch(error){
        emit(ErrorState(error: error is DeleteAddressException? error.message : Strings.somethingWentWrong));
    }
    });

    on<AddAddressEvent>((event, emit) async  {
      try {
        emit(AddressListLoadingState());
      await addAddressUseCase.execute(
          AddAddressParams(event.addressText,)
      );
      GetAddressesResult getAddressesResult = await getAddressesUseCase.execute(GetAddressesParams());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      emit(AllAddressListViewState(addresses: getAddressesResult.addresses));
      }catch(error){
        emit(ErrorState(error: error is AddAddressException? error.message : Strings.somethingWentWrong));
      }
    });

    on<EditAddressEvent>((event, emit) async  {
      try{
      emit(AddressListLoadingState());
      await editAddressUseCase.execute(
          EditAddressParams(event.addressIndex, event.addressText)
      );
      GetAddressesResult getAddressesResult = await getAddressesUseCase.execute(GetAddressesParams());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      emit(AllAddressListViewState(addresses: getAddressesResult.addresses));

      }catch(error){
        emit(ErrorState(error: error is EditAddressException? error.message : Strings.somethingWentWrong));
      }
    });
  }

}
