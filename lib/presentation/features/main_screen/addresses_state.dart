import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/data/model/nearestAddressData.dart';

@immutable
abstract class AddressesState extends Equatable {
  final String? error;

  const AddressesState({this.error});
  @override
  List<Object> get props => [];
}

class InitialState extends AddressesState {}

@immutable
class AddressListLoadingState extends AddressesState {
  @override
  String toString() => 'AddressListLoadingState';
}

@immutable
abstract class AddressListViewState extends AddressesState {
  final List<Address> addresses;

  const AddressListViewState({required this.addresses})
      : super();

  @override
  List<Object> get props => [addresses];
}

@immutable
class AllAddressListViewState extends AddressListViewState {
  const AllAddressListViewState({required List<Address> addresses})
      : super(addresses: addresses);

  @override
  String toString() => 'AllAddressListViewState';
}

@immutable
class ErrorState extends AddressesState {

  const ErrorState({String? error})
      : super(error: error);

  @override
  String toString() => 'AddressListErrorState';
}