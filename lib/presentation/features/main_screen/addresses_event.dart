import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AddressesEvent extends Equatable {
  const AddressesEvent() : super();

  @override
  List<Object> get props => [];
}

@immutable
class ShowAddressListEvent extends AddressesEvent {
  const ShowAddressListEvent() : super();
}

@immutable
class RemoveFromAddressListEvent extends AddressesEvent {
  final int addressIndex;

  const RemoveFromAddressListEvent(this.addressIndex) : super();

  @override
  List<Object> get props => [addressIndex];
}

@immutable
class EditAddressEvent extends AddressesEvent {
  final int addressIndex;
  final String addressText;

  const EditAddressEvent(this.addressIndex, this.addressText) : super();

  @override
  List<Object> get props => [addressIndex, addressText];
}

@immutable
class AddAddressEvent extends AddressesEvent {
  final String addressText;

  const AddAddressEvent(this.addressText) : super();

  @override
  List<Object> get props => [addressText];
}