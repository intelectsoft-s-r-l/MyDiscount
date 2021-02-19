import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../../domain/entities/user_model.dart';

abstract class LocalRepository {
  User saveLocalUser(User user);
  Profile saveLocalClientInfo(Profile profile);
  void saveLocalNews(List newsList);
  void saveLocalCompanyList(List<Company> list);
  void deleteLocalUser();
  Profile getLocalClientInfo();
  List<News> getLocalNews();
  User getLocalUser();
  String readEldestNewsId();
}
