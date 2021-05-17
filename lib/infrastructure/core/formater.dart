import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../domain/entities/company_model.dart';
import 'failure.dart';

class Formater {
  static const String _placeholder =
      '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';
  List<Map<String, dynamic>> deleteImageFormatAndDecode(
    List list,
    String index,
  ) {
    try {
      final _listOfMaps = list.map((dynamicMap) {
        final Map<String, dynamic> map = dynamicMap;
        if (map.isNotEmpty && map.containsKey(index)) {
          final base64String = _deleteImageFormat(map[index]);
          final _bytes = _convertBase64String(base64String);
          map[index] = _bytes;
          return map;
        }
      }).toList().cast<Map<String,dynamic>>();
      return _listOfMaps;
    } catch (e) {
      throw ImageDecoderError();
    }
  }

  List parseDateTime(List list, String index) {
    try {
      final _formatedDate = list.map((map) {
        if (map is Map<String, dynamic> && map.containsKey(index)) {
          final milliseconds = _parseMillisecondsToInt(map[index]);
          final _dateTime = _formatDateTimeFromMiliseconds(milliseconds);
          map[index] = _dateTime;
        }
        return map;
      }).toList();
      return _formatedDate;
    } catch (e) {
      throw DateParserError();
    }
  }

  Map<String, dynamic> splitDisplayName(Map map) {
    final displayName = map['Name'];
    try {
      List<dynamic>? listStrings = [];
      if (displayName.contains(' ')) {
        listStrings = displayName.split(' ').map((e) => e.toString()).toList();
      } else {
        final _list = displayName.split(' ').map((e) => e.toString()).toList();
        _list.add('');
        listStrings = _list;
      }

      map
        ..putIfAbsent('firstName', () => listStrings![0])
        ..putIfAbsent('lastName', () => listStrings![1])
        ..remove('Name');

      return map as Map<String, dynamic>;
    } catch (e) {
      throw NameParserError();
    }
  }

  Future<Map<String, dynamic>> downloadProfileImageOrDecodeString(
      Map<String, dynamic> map) async {
    try {
      if (map['PhotoUrl'] != null) {
        if (map['PhotoUrl'].toString().startsWith('http')) {
          final image = await _downloadImageFromLink(map['PhotoUrl']);

          map.putIfAbsent('Photo', () => image);
        } else {
          final bytes = Uint8List.fromList(base64Decode(map['PhotoUrl']));
          map.putIfAbsent('Photo', () => bytes);
        }
        map.remove('PhotoUrl');
        return map;
      } else {
        return map;
      }
    } catch (e) {
      throw ImageDownloaderError();
    }
  }

  Map<String, dynamic> addToProfileMapSignMethod(
      Map<String, dynamic> map, int? registerMode) {
    try {
      map.putIfAbsent('mode', () => registerMode);
      return map;
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> _downloadImageFromLink(url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.bodyBytes;
    } catch (e) {
      return Uint8List.fromList([]);
    }
  }

  List checkCompanyLogo(List list) {
    try {
      final dat = list.map((map) => _returnLogo(map as Map)).toList();
      return dat;
    } catch (e) {
      rethrow;
    }
  }

  Uint8List _convertBase64String(String _base64) {
    if (_base64.isNotEmpty) {
      return const Base64Decoder().convert(_base64);
    } else {
      return _returnPlaceholderAsBytes();
    }
  }

  String _formatDateTimeFromMiliseconds(int miliseconds) {
    return DateFormat('d MMM yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(miliseconds),
    );
  }

  String _deleteImageFormat(String? _base64) {
    return _base64
        .toString()
        .replaceRange(0, _base64.toString().indexOf(',') + 1, '');
  }

/* map[index].replaceAll('/Date(', '').replaceAll('+0300)/', '').replaceAll('+0200)/', '') */
  int _parseMillisecondsToInt(String dateTime) {
    final f = dateTime.replaceRange(0, dateTime.indexOf('(') + 1, '');
    var patern = '';
    if (f.contains('-')) patern = '-';
    if (f.contains('+')) patern = '+';
    final d = f.replaceRange(f.indexOf(patern), f.indexOf('/') + 1, '');
    return int.parse(d);
  }

  Map<String, dynamic> _returnLogo(Map map) {
    try {
      // ignore: omit_local_variable_types
      final Box<Company> companyBox = Hive.box('company');
      if (companyBox.isNotEmpty) {
        final keys = companyBox.keys;
        _addLogoToMap(keys, companyBox, map);
        return map as Map<String, dynamic>;
      } else {
        map.putIfAbsent('Logo', () => _returnPlaceholderAsBytes);
        return map as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Uint8List _returnPlaceholderAsBytes() {
    return const Base64Decoder().convert(_placeholder);
  }

  void _addLogoToMap(dynamic keys, Box<Company> companyBox, Map map) {
    for (dynamic key in keys) {
      final company = companyBox.get(key)!;
      if (CompanyName(company.name) == CompanyName(map['Company'])) {
        map.putIfAbsent('Logo', () => company.logo);
      }
    }
  }
}

class CompanyName {
  final String name;
  CompanyName(this.name);
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is CompanyName && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}
