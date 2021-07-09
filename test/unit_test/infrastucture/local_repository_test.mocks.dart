// Mocks generated by Mockito 5.0.7 from annotations
// in my_discount/test/unit_test/infrastucture/local_repository_test.dart.
// Do not manually edit this file.

import 'package:hive/hive.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

/// A class which mocks [Box].
///
/// See the documentation for Mockito's code generation for more information.
class MockBox<E> extends _i1.Mock implements _i2.Box<E> {
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
      (super.noSuchMethod(Invocation.getter(#keys), returnValue: [])
          as Iterable<dynamic>);
  @override
  Future<void> put(dynamic key, E value) =>
      super.noSuchMethod(Invocation.method(#put, [key, value]),
          returnValueForMissingStub: Future<void>.value(),
          returnValue: Future<void>.value());
  @override
  Future<void> delete(dynamic key) =>
      super.noSuchMethod(Invocation.method(#delete, []),
          returnValue: Future<void>.value());
  @override
  E? get(dynamic key, {E? defaultValue}) => super
      .noSuchMethod(Invocation.method(#get, []), returnValue: defaultValue);
}

class MockList<E> extends _i1.Mock implements List<E> {
  @override
  void add(E value) => super.noSuchMethod(Invocation.method(#add, [value]),
      returnValueForMissingStub: null);
  @override
  // ignore_for_file: use_function_type_syntax_for_parameters
  Iterable<T> map<T>(T f(E e)) =>
      super.noSuchMethod(Invocation.method(#map, []), returnValue: <T>[]);
  @override
  List<E> toList({bool growable = true}) =>
      super.noSuchMethod(Invocation.method(#toList, [this]),
          returnValue: [] as List<E>);
  @override
  void forEach(void f(E element)) =>
      super.noSuchMethod(Invocation.method(#forEach, []),
          returnValueForMissingStub: f);
  @override
  bool get isNotEmpty => super
      .noSuchMethod(Invocation.method(#isNotEmpty, []), returnValue: false);
  @override
  bool contains(Object? element) => super
      .noSuchMethod(Invocation.method(#contains, [element]), returnValue: true);
}
