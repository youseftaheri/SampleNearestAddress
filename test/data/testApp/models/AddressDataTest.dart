import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_nearest_address/data/model/addressData.dart';
import '../../../fixtures/fixture_reader.dart';

void main() {
  final addressData = [ Address(
      latitude: 23.23,
      longitude: 43.43,
      addressText: "iran"
  ),
    Address(
        latitude: 13.13,
        longitude: 78.78,
        addressText: "germany"
    ),
  ];

  group('encode', () {
    test(
      'should return a string with proper data',
          () async {
        // act
        final result = Address.encode(addressData);
        // assert
        final expectedString = fixture('testApp/addressData.json');
        expect(result, expectedString);
      },
    );
  });

  group('decode', () {
    test(
      'should return a list of addresses with proper data',
          () async {
        // act
        final result = Address.decode(fixture('testApp/addressData.json'));
        // assert
        final expectedString = addressData;
        // assert
        expect(result, expectedString);
      },
    );
  });


}