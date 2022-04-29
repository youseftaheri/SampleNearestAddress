import 'dart:convert';
import 'package:sample_nearest_address/data/model/addressData.dart';

class NearestAddress {
  int status;
  Address address;
  double distance;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NearestAddress &&
              runtimeType == other.runtimeType &&
              status == other.status &&
              address == other.address &&
              distance == other.distance;

  @override
  int get hashCode => status.hashCode ^ address.hashCode ^ distance.hashCode;

  NearestAddress({
    required this.status,
    required this.address ,
    this.distance = 0.0,
  });

  factory NearestAddress.fromJson(Map<String, dynamic> jsonData) {
    return NearestAddress(
      status: jsonData['status'],
      address: Address.fromJson(jsonData['address']),
      distance: jsonData['distance'],
    );
  }
}