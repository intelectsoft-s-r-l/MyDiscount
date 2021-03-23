import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../../domain/entities/user_model.dart';

abstract class LocalRepository {
  void saveLocalNews(List newsList);
  List<News> getLocalNews();
  String readEldestNewsId();
  
  Future<List<Company>> getCachedCompany();
  void saveLocalCompanyList(List<Company> list);
  Future<Map<String, dynamic>> returnProfileMapDataAsMap(Profile profile);
  Profile saveLocalClientInfo(Profile profile);
  Future<Map<String, dynamic>> getFacebookProfile(String token);
  Profile getLocalClientInfo();
  
  User saveLocalUser(User user);
  void deleteLocalUser();
  User getLocalUser();
  Map<String, dynamic> returnUserMapToSave(Map<String, dynamic> json);
  
  bool smsCodeVerification(String serverCode, String userCode);
}
