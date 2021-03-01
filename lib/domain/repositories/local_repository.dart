import 'package:MyDiscount/domain/entities/user_model.dart';

import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';

abstract class LocalRepository {
  void saveLocalNews(List newsList);
  void deleteLocalUser();
  void saveLocalCompanyList(List<Company> list);
  Profile saveLocalClientInfo(Profile profile);
  User saveLocalUser(User user);
  User getLocalUser();
  Profile getLocalClientInfo();
  List<News> getLocalNews();
  String readEldestNewsId();
  bool smsCodeVerification(String serverCode, String userCode);
  Future<Map<String, dynamic>> returnProfileMapDataAsMap(Profile profile);
  Map<String, dynamic> returnUserMapToSave(Map<String, dynamic> json);
  Future<Map<String, dynamic>> getFacebookProfile(String token);
}
