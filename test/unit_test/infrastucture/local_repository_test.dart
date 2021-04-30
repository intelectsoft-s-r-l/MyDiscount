import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:my_discount/domain/entities/company_model.dart';
import 'package:my_discount/domain/entities/news_model.dart';
import 'package:my_discount/domain/entities/profile_model.dart';
import 'package:my_discount/domain/entities/user_model.dart';
import 'package:my_discount/domain/repositories/local_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_discount/infrastructure/local_repository_impl.dart';

import 'local_repository_test.mocks.dart';

@GenerateMocks([
  LocalRepository,
  Box,
])
void main() {
  final mockProfileBox = MockBox<Profile>();
  final mockUserBox = MockBox<User>();
  final mockNewsBox = MockBox<News>();
  final mockCompanyBox = MockBox<Company>();
  final mockList = MockList<News>();
  final localRepozitory = LocalRepositoryImpl(
      mockUserBox, mockProfileBox, mockNewsBox, mockCompanyBox);
  setUp(() {});

  final tUserProfile = Profile.empty();
  final tNewsList = News(
      appType: 0,
      header: '',
      id: 0,
      companyId: 0,
      companyName: '',
      content: '',
      logo: Uint8List.fromList([]),
      dateTime: '',
      photo: Uint8List.fromList([]));
  final tUser = User(id: '', accessToken: '', registerMode: 0);
  test('getLocalClientInfo() retun local profile data from database', () async {
    when(mockProfileBox.isNotEmpty).thenAnswer((_) => true);
    when(mockProfileBox.get(1)).thenAnswer((_) => tUserProfile);
    final response = localRepozitory.getLocalClientInfo();

    expect(response, tUserProfile);
  });

  test('check if getLocalNews() return saved news from DB', () async {
    when(mockNewsBox.keys).thenAnswer((_) => [0]);
    when(mockNewsBox.get(0)).thenAnswer((_) => tNewsList);
    when(mockList.add(tNewsList)).thenAnswer((realInvocation) => [tNewsList]);
    final response = localRepozitory.getLocalNews();

    expect(response, [tNewsList]);
  });

  test('check if retun saved user', () async {
    when(localRepozitory.getLocalUser()).thenAnswer((_) => tUser);

    final response = localRepozitory.getLocalUser();

    expect(response, tUser);
  });

  test('save local Client Info ', () async {
    when(localRepozitory.saveClientInfoLocal(tUserProfile))
        .thenAnswer((realInvocation) => tUserProfile);

    final response = localRepozitory.saveClientInfoLocal(tUserProfile);

    expect(response, tUserProfile);
  });
  test('save news locally ', () async {
    /*   when(localRepozitory.saveNewsLocal(tNewsList));

    localRepozitory.saveNewsLocal(tNewsList);

    verify(localRepozitory.saveNewsLocal(tNewsList)); */
  });

  /* test('save user locally ', () async {
    when(localRepozitory.saveUserLocal(User()))
        .thenAnswer((realInvocation) => tUser);

    final response = localRepozitory.saveUserLocal(tUser);

    //”verify(localRepozitory.saveUserLocal(tUser));
    expect(response, tUser);
  }); */
}
