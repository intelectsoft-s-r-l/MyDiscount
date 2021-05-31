import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../entities/user_model.dart';

abstract class LocalRepository {
  void saveNewsLocal(List newsList);
  List<News> getLocalNews();
  String readEldestNewsId();
  void deleteNews();

  Future<List<Company>> getSavedCompany(String pattern);
  void saveCompanyListLocal(List<Company> list);
  List<Company> searchCompany(String pattern);

  Future<Map<String, dynamic>> returnProfileMapDataAsMap(Profile profile);
  void saveClientInfoLocal(Profile profile);
  //Future<Map<String, dynamic>> getFacebookProfile(String token);
  Profile getLocalClientInfo();

  void saveUserLocal(User user);
  void deleteLocalUser();
  User getLocalUser();
  Map<String, dynamic> returnUserMapToSave(Map<String, dynamic> json);

  bool smsCodeVerification(String serverCode, String userCode);
}
