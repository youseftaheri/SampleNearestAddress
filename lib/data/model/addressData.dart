import 'dart:convert';

class Address {
  double latitude, longitude;
  String addressText;

  Address({
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.addressText = "",
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Address &&
              runtimeType == other.runtimeType &&
              latitude == other.latitude &&
              longitude == other.longitude &&
              addressText == other.addressText;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ addressText.hashCode;

  factory Address.fromJson(Map<String, dynamic> jsonData) {
    return Address(
      latitude: jsonData['latitude'],
      longitude: jsonData['longitude'],
      addressText: jsonData['addressText'],
    );
  }

  static Map<String, dynamic> toMap(Address address) => {
    'latitude': address.latitude,
    'longitude': address.longitude,
    'addressText': address.addressText,
  };

  static String encode(List<Address> addresses) => json.encode(
    addresses
        .map<Map<String, dynamic>>((address) => Address.toMap(address))
        .toList(),
  );

  static List<Address> decode(String addresses) =>
      (json.decode(addresses) as List<dynamic>)
          .map<Address>((item) => Address.fromJson(item))
          .toList();
}