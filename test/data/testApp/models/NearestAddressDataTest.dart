import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/data/model/nearestAddressData.dart';
import '../../../fixtures/fixture_reader.dart';

void main() {
  final nearestAddressData =  NearestAddress(

    status: 1,
    address: Address(
        latitude: 23.23,
        longitude: 43.43,
        addressText: "iran"
    ),
    distance: 678.21,
  );

  group('fromJson', () {
    test(
      'should return nearest address object from json',
          () async {
        // act
        final result = NearestAddress.fromJson(json.decode(fixture('testApp/nearestAddressData.json')));
        // assert
        final expectedString = nearestAddressData;
        // assert
        expect(result, expectedString);
      },
    );
  });


}