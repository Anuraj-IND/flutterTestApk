import 'package:covermint_lg/core/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators mirror the backend regexes', () {
    test('phone accepts 10-digit numbers starting 6-9', () {
      expect(Validators.phone('9876543210'), isNull);
      expect(Validators.phone('6123456789'), isNull);
      expect(Validators.phone('1234567890'), isNotNull);
      expect(Validators.phone('987654321'), isNotNull);
    });

    test('pan accepts ABCDE1234F shape', () {
      expect(Validators.pan('ABCDE1234F'), isNull);
      expect(Validators.pan('abcde1234f'), isNull);
      expect(Validators.pan('ABCD1234F'), isNotNull);
    });

    test('pincode and ifsc shapes', () {
      expect(Validators.pincode('560001'), isNull);
      expect(Validators.pincode('060001'), isNotNull);
      expect(Validators.ifsc('HDFC0001233'), isNull);
      expect(Validators.ifsc('hdfc0001233'), isNull);
      expect(Validators.ifsc('HDFC001233'), isNotNull);
    });
  });
}
