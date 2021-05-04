// Mocks generated by Mockito 5.0.4 from annotations
// in my_discount/test/unit_test/infrastucture/local_repository_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:hive/hive.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:my_discount/domain/entities/company_model.dart' as _i7;
import 'package:my_discount/domain/entities/news_model.dart' as _i5;
import 'package:my_discount/domain/entities/profile_model.dart' as _i2;
import 'package:my_discount/domain/entities/user_model.dart' as _i3;
import 'package:my_discount/domain/repositories/local_repository.dart' as _i4;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

class _FakeProfile extends _i1.Fake implements _i2.Profile {}

class _FakeUser extends _i1.Fake implements _i3.User {}

/// A class which mocks [LocalRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalRepository extends _i1.Mock implements _i4.LocalRepository {
  MockLocalRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void saveNewsLocal(List<dynamic>? newsList) =>
      super.noSuchMethod(Invocation.method(#saveNewsLocal, [newsList]),
          returnValueForMissingStub: null);
  @override
  List<_i5.News> getLocalNews() =>
      (super.noSuchMethod(Invocation.method(#getLocalNews, []),
          returnValue: <_i5.News>[]) as List<_i5.News>);
  @override
  String readEldestNewsId() =>
      (super.noSuchMethod(Invocation.method(#readEldestNewsId, []),
          returnValue: '') as String);
  @override
  List<_i5.News> deleteNews() =>
      (super.noSuchMethod(Invocation.method(#deleteNews, []),
          returnValue: <_i5.News>[]) as List<_i5.News>);
  @override
  _i6.Future<List<_i7.Company>> getSavedCompany(String? pattern) =>
      (super.noSuchMethod(Invocation.method(#getSavedCompany, [pattern]),
              returnValue: Future<List<_i7.Company>>.value(<_i7.Company>[]))
          as _i6.Future<List<_i7.Company>>);
  @override
  void saveCompanyListLocal(List<_i7.Company>? list) =>
      super.noSuchMethod(Invocation.method(#saveCompanyListLocal, [list]),
          returnValueForMissingStub: null);
  @override
  List<_i7.Company> searchCompany(String? pattern) =>
      (super.noSuchMethod(Invocation.method(#searchCompany, [pattern]),
          returnValue: <_i7.Company>[]) as List<_i7.Company>);
  @override
  _i6.Future<Map<String, dynamic>> returnProfileMapDataAsMap(
          _i2.Profile? profile) =>
      (super.noSuchMethod(
              Invocation.method(#returnProfileMapDataAsMap, [profile]),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i6.Future<Map<String, dynamic>>);
  @override
  _i2.Profile saveClientInfoLocal(_i2.Profile? profile) =>
      (super.noSuchMethod(Invocation.method(#saveClientInfoLocal, [profile]),
          returnValue: _FakeProfile()) as _i2.Profile);
  @override
  _i2.Profile getLocalClientInfo() =>
      (super.noSuchMethod(Invocation.method(#getLocalClientInfo, []),
          returnValue: _FakeProfile()) as _i2.Profile);
  @override
  _i3.User saveUserLocal(_i3.User? user) =>
      (super.noSuchMethod(Invocation.method(#saveUserLocal, [user]),
          returnValue: _FakeUser()) as _i3.User);
  @override
  void deleteLocalUser() =>
      super.noSuchMethod(Invocation.method(#deleteLocalUser, []),
          returnValueForMissingStub: null);
  @override
  _i3.User getLocalUser() =>
      (super.noSuchMethod(Invocation.method(#getLocalUser, []),
          returnValue: _FakeUser()) as _i3.User);
  @override
  Map<String, dynamic> returnUserMapToSave(Map<String, dynamic>? json) =>
      (super.noSuchMethod(Invocation.method(#returnUserMapToSave, [json]),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  bool smsCodeVerification(String? serverCode, String? userCode) =>
      (super.noSuchMethod(
          Invocation.method(#smsCodeVerification, [serverCode, userCode]),
          returnValue: false) as bool);
}

/// A class which mocks [Box].
///
/// See the documentation for Mockito's code generation for more information.
class MockBox<E> extends _i1.Mock implements _i8.Box<E> {
  MockBox() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Iterable<E> get values =>
      (super.noSuchMethod(Invocation.getter(#values), returnValue: [])
          as Iterable<E>);
  @override
  Iterable<E> valuesBetween({dynamic startKey, dynamic endKey}) =>
      (super.noSuchMethod(
          Invocation.method(
              #valuesBetween, [], {#startKey: startKey, #endKey: endKey}),
          returnValue: []) as Iterable<E>);
  @override
  E? getAt(int? index) =>
      (super.noSuchMethod(Invocation.method(#getAt, [index])) as E?);
  @override
  Map<dynamic, E> toMap() => (super.noSuchMethod(Invocation.method(#toMap, []),
      returnValue: <dynamic, E>{}) as Map<dynamic, E>);
  @override
  bool get isNotEmpty =>
      (super.noSuchMethod(Invocation.getter(#isNotEmpty), returnValue: false));
  @override
  Iterable<dynamic> get keys =>
      (super.noSuchMethod(Invocation.getter(#keys), returnValue: [])as Iterable<dynamic> );
}
class MockList<E> extends _i1.Mock implements List<E>{
   @override
  void add(E value) =>
      super.noSuchMethod(Invocation.method(#add, [value]),
          returnValueForMissingStub: null);
}