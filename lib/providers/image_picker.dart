import 'dart:convert';

import 'package:MyDiscount/services/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class LocalImagePicker with ChangeNotifier {
  final _picker = ImagePicker();
  final _prefs = SharedPref();
  final _source = ImageSource.gallery;
  String _photo = '';
  get photo => _photo;
  void changeUserAvatar() async {
    final file = await _picker.getImage(source: _source);
    final bytes = await file.readAsBytes();
    final base64String = base64Encode(bytes.toList());
    _photo = base64String;
    final profileMap = json.decode(await _prefs.readProfileData()) as Map<String, dynamic>;
    profileMap['photoUrl'] = base64String;
    _prefs.saveProfileData(json.encode(profileMap));
    notifyListeners();
  }

  LocalImagePicker() {
    _updateImage();
  }
  void _updateImage() async {
    final _profile = json.decode(await _prefs.readProfileData()) as Map<String, dynamic>;
    _photo = _profile['photoUrl'];
    notifyListeners();
  }
}
