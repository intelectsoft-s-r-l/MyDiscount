import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_discount/domain/entities/company_model.dart';
import 'package:my_discount/domain/entities/news_model.dart';
import 'package:my_discount/domain/entities/profile_model.dart';
import 'package:my_discount/domain/entities/user_model.dart';
import 'package:my_discount/infrastructure/local_repository_impl.dart';

import '../fixtures/fixtures_redear.dart';
import 'local_repository_test.mocks.dart';

@GenerateMocks([
  Box,
])
void main() {
  final mockProfileBox = MockBox<Profile>();
  final mockUserBox = MockBox<User>();
  final mockNewsBox = MockBox<News>();
  final mockCompanyBox = MockBox<Company>();
  final mockList = MockList<News>();
  final mockCompanyList = MockList<Company>();
  final mockJsonList = MockList<Map<String, dynamic>>();
  final localRepozitory = LocalRepositoryImpl(
      mockUserBox, mockProfileBox, mockNewsBox, mockCompanyBox);

  final tUserProfile = Profile.empty();
  final tJsonNewsList = <Map<String, dynamic>>[
    {
      'AppType': 1,
      'CompanyID': 1,
      'Content': 'test Content',
      'CompanyLogo': Uint8List.fromList([]),
      'CompanyName': 'TestCompany',
      'CreateDate': '21 Jan 2021',
      'Header': '',
      'ID': 1,
      'Photo': Uint8List.fromList([])
    }
  ];
  final tNews1 = News(
      appType: 1,
      header: '',
      id: 1,
      companyId: 1,
      companyName: '',
      content: '',
      logo: Uint8List.fromList([]),
      dateTime: '',
      photo: Uint8List.fromList([]));
  final tNews = News(
      appType: 0,
      header: '',
      id: 0,
      companyId: 0,
      companyName: '',
      content: '',
      logo: Uint8List.fromList([]),
      dateTime: '',
      photo: Uint8List.fromList([]));
  /* final tNewsList = [tNews]; */
  final tUser = User(id: '', accessToken: '', registerMode: 0);
  final tCompanyList = returnListcompany();
  test('getLocalClientInfo() retun local profile data from database', () async {
    when(mockProfileBox.isNotEmpty).thenAnswer((_) => true);
    when(mockProfileBox.get(1)).thenAnswer((_) => tUserProfile);

    final response = localRepozitory.getLocalClientInfo();

    expect(response, tUserProfile);
  });

  test('check if getLocalNews() return saved news from DB', () async {
    when(mockNewsBox.keys).thenAnswer((_) => [0]);
    when(mockNewsBox.get(0)).thenAnswer((_) => tNews);
    when(mockList.add(tNews)).thenAnswer((_) => [tNews]);

    final response = localRepozitory.getLocalNews();

    expect(response, [tNews]);
  });

  test('check if return saved user', () async {
    when(mockUserBox.isNotEmpty).thenAnswer((_) => true);
    when(mockUserBox.get(1)).thenAnswer((_) => tUser);

    final response = localRepozitory.getLocalUser();

    expect(response, tUser);
  });

  test('save local Client Info ', () async {
    when(mockProfileBox.put(1, tUserProfile))
        .thenAnswer((_) => Future<void>.value());

    localRepozitory.saveClientInfoLocal(tUserProfile);
    final profile = mockProfileBox.get(1);

    expect(profile, tUserProfile);
  });
  test('save news locally ', () async {
    when(mockNewsBox.put(tNews1.id, tNews1))
        .thenAnswer((_) => Future<void>.value());
    when(mockJsonList.map((e) => News.fromJson(e)).toList().forEach((news) {}))
        .thenAnswer((_) => Future<void>.value());
    when(mockNewsBox.get(1)).thenAnswer((_) => tNews1);

    localRepozitory.saveNewsLocal(tJsonNewsList);
    final news = mockNewsBox.get(tNews1.id) as News;

    expect(news, equals(tNews1));
  });

  test('save user locally ', () async {
    when(mockUserBox.put(1, tUser)).thenAnswer((_) => Future<void>.value());

    localRepozitory.saveUserLocal(tUser);
    final response = mockUserBox.get(1);

    verify(localRepozitory.saveUserLocal(tUser));
    expect(response, tUser);
  });
  test('return eldest news id', () async {
    when(mockNewsBox.keys).thenAnswer((_) => [1, 2, 3, 4, 5]);
    when(mockList.isNotEmpty).thenAnswer((_) => true);

    final response = localRepozitory.readEldestNewsId();

    expect(response, '5');
  });

  test('save company list locally', () async {
    when(mockCompanyBox.isNotEmpty).thenAnswer((_) => true);
    when(mockCompanyBox.keys).thenAnswer((_) => [1]);
    when(mockCompanyBox.delete(1)).thenAnswer((_) => Future<void>.value());
    // ignore: iterable_contains_unrelated_type
    when(mockCompanyList.map((company) => company.id).toList().contains(1))
        .thenAnswer((_) => true);
    // ignore: avoid_function_literals_in_foreach_calls
    when(mockCompanyList.forEach((company) {}))
        .thenAnswer((_) => Future<void>.value());
    when(mockCompanyBox.get(1)).thenAnswer((_) => tCompanyList[0]);
    when(mockCompanyBox.put(1, tCompanyList[0]))
        .thenAnswer((_) => Future<void>.value());

    localRepozitory.saveCompanyListLocal(tCompanyList);
    final response = mockCompanyBox.get(1);
    expect(response, tCompanyList[0]);
  });
}
