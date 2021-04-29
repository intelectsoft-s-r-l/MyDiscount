import 'dart:convert';
import 'dart:typed_data';

import 'package:my_discount/core/formater.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixtures_redear.dart';

void main() {
  late Formater _formater;
  setUp(() {
    _formater = Formater();
  });
  group('check image and decode', () {
    test('check if de return type of index "Logo" is Uint8List', () async {
      final index = 'Logo';

      final listOfCompany = await json.decode(fixture('list_of_company.json'));

      final result = _formater.deleteImageFormatAndDecode(listOfCompany, index);
      final bytes = result[0][index];
      expect(bytes, isA<Uint8List>());
    });
    test('check if de return type of index "Photo" is Uint8List', () async {
      final index = 'Photo';
      final listOfNews = await json.decode(fixture('list_of_news.json'));
      final result = _formater.deleteImageFormatAndDecode(listOfNews, index);
      final bytes = result[0][index];
      expect(bytes, isA<Uint8List>());
    });
  });
  group('verify function parseDateTime()', () {
    test('should parse date time in to format dd MM yyyy', () async {
      final index = 'CreateDate';
      final date = '21 Jan 2021';
      final list = await json.decode(fixture('list_of_news.json'));
      final result = _formater.parseDateTime(list, index);
      final formatedDate = result[0][index];
      expect(formatedDate, date);
    });
  });
  group('parse displayName in to list of strings and ad it to map', () {
    test('verify splitDisplayName()', () async {
      final map = {
        'firstName': 'Ion',
        'lastName': 'Cristea',
        'Email': '',
        'ID': '',
        'phone': '',
        'PhotoUrl': '',
        'PushToken': '',
        'RegisterMode': 1,
        'access_token': '',
      };
      final responseMap =
          await json.decode(fixture('auth_providers_credentials.json'));
      final result = _formater.splitDisplayName(responseMap);
      expect(map, equals(result));
    });
  });
}
