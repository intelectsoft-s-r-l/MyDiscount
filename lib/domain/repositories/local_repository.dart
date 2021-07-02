import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../entities/user_model.dart';
/// [LocalRepository] is an interface to work with local database
abstract class LocalRepository {
  /// Take a list of [News] returned from `IsService` getAppNews function
  /// and save it in to `HiveBox` 
  void saveNewsLocal(List newsList);
  /// Return locally saved [News] to a list 
  List<News> getLocalNews();
  /// Return the biggest id from locally saved [News] list
  String readEldestNewsId();
  /// Delete all local news when [News] is disabled from settings and user 
  /// navigate to [News] page
  void deleteNews();
  ///Return all saved [Company] to a list
  Future<List<Company>> getSavedCompany(String pattern);
  /// Take a list of [Company] returned from `IsService` getCompanyList function
  /// and save it in to `HiveBox`
  void saveCompanyListLocal(List<Company> list);
  /// Search a [Company] in database  whose name start with `pattern` introduced
  /// by [User]
  List<Company> searchCompany(String pattern);
  /// Create a `JSON` object from [Profile] data and [User] data to update 
  /// information on `IsService` updateClientInfo function 
  Future<Map<String, dynamic>> returnProfileMapDataAsMap(Profile profile);
  /// Take a [Profile] data returned from `IsService` getClientInfo or 
  /// updateClientInfo and save it in to `HiveBox`
  void saveClientInfoLocal(Profile profile);
  /// Return [Profile] data from database as a `Stream` 
  /// NOT USED for NOW
  Stream<Profile> updateClientInfo();
  /// Return [Profile] data from database
  Profile getLocalClientInfo();
  /// Take a [User] data from authorization provider and save it to a `HiveBox`
  void saveUserLocal(User user);
  /// Delete all [User] data saved in `HiveBox`
  void deleteLocalUser();
  /// Return [User] data saved in database
  User getLocalUser();
  /// Create a `JSON` object from authorization provider data to create a [User]
  /// `Dart` object 
  Map<String, dynamic> returnUserMapToSave(Map<String, dynamic> json);
  /// Compare a 4 character string returned by `IsService` validatePhone 
  /// function with SMS code sended to user phone number
  bool smsCodeVerification(String serverCode, String userCode);
}
