import 'package:flutter/material.dart';

abstract class Settings {
  bool getPushStatus();
  bool getNewsStatus();
  Locale getLocale();
}
