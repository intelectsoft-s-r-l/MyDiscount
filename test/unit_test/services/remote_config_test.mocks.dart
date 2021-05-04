// Mocks generated by Mockito 5.0.4 from annotations
// in my_discount/test/unit_test/services/remote_config_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;
import 'dart:ui' as _i8;

import 'package:firebase_core/firebase_core.dart' as _i2;
import 'package:firebase_remote_config/firebase_remote_config.dart' as _i5;
import 'package:firebase_remote_config_platform_interface/src/remote_config_settings.dart'
    as _i3;
import 'package:firebase_remote_config_platform_interface/src/remote_config_status.dart'
    as _i6;
import 'package:firebase_remote_config_platform_interface/src/remote_config_value.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

class _FakeFirebaseApp extends _i1.Fake implements _i2.FirebaseApp {}

class _FakeDateTime extends _i1.Fake implements DateTime {}

class _FakeRemoteConfigSettings extends _i1.Fake
    implements _i3.RemoteConfigSettings {}

class _FakeRemoteConfigValue extends _i1.Fake implements _i4.RemoteConfigValue {
}

/// A class which mocks [RemoteConfig].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoteConfig extends _i1.Mock implements _i5.RemoteConfig {
  MockRemoteConfig() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
      returnValue: _FakeFirebaseApp()) as _i2.FirebaseApp);
  @override
  DateTime get lastFetchTime =>
      (super.noSuchMethod(Invocation.getter(#lastFetchTime),
          returnValue: _FakeDateTime()) as DateTime);
  @override
  _i6.RemoteConfigFetchStatus get lastFetchStatus =>
      (super.noSuchMethod(Invocation.getter(#lastFetchStatus),
              returnValue: _i6.RemoteConfigFetchStatus.noFetchYet)
          as _i6.RemoteConfigFetchStatus);
  @override
  _i3.RemoteConfigSettings get settings => (super.noSuchMethod(
      Invocation.getter(#settings),
      returnValue: _FakeRemoteConfigSettings()) as _i3.RemoteConfigSettings);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i7.Future<bool> activate() =>
      (super.noSuchMethod(Invocation.method(#activate, []),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<void> ensureInitialized() =>
      (super.noSuchMethod(Invocation.method(#ensureInitialized, []),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> fetch() => (super.noSuchMethod(Invocation.method(#fetch, []),
      returnValue: Future<void>.value(null),
      returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  _i7.Future<bool> fetchAndActivate() =>
      (super.noSuchMethod(Invocation.method(#fetchAndActivate, []),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  Map<String, _i4.RemoteConfigValue> getAll() =>
      (super.noSuchMethod(Invocation.method(#getAll, []),
              returnValue: <String, _i4.RemoteConfigValue>{})
          as Map<String, _i4.RemoteConfigValue>);
  @override
  bool getBool(String? key) => (super
          .noSuchMethod(Invocation.method(#getBool, [key]), returnValue: false)
      as bool);
  @override
  int getInt(String? key) =>
      (super.noSuchMethod(Invocation.method(#getInt, [key]), returnValue: 0)
          as int);
  @override
  double getDouble(String? key) => (super
          .noSuchMethod(Invocation.method(#getDouble, [key]), returnValue: 0.0)
      as double);
  @override
  String getString(String? key) =>
      (super.noSuchMethod(Invocation.method(#getString, [key]), returnValue: '')
          as String);
  @override
  _i4.RemoteConfigValue getValue(String? key) =>
      (super.noSuchMethod(Invocation.method(#getValue, [key]),
          returnValue: _FakeRemoteConfigValue()) as _i4.RemoteConfigValue);
  @override
  _i7.Future<void> setConfigSettings(
          _i3.RemoteConfigSettings? remoteConfigSettings) =>
      (super.noSuchMethod(
          Invocation.method(#setConfigSettings, [remoteConfigSettings]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setDefaults(Map<String, dynamic>? defaultParameters) =>
      (super.noSuchMethod(Invocation.method(#setDefaults, [defaultParameters]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  void addListener(_i8.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i8.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}