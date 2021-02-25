import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../../domain/entities/user_model.dart';
import '../../domain/entities/tranzaction_model.dart';

abstract class IsService {
  Future<List<News>> getAppNews();
  Future<Profile> getClientInfo();
  Future<List<Company>> getCompanyList();
  Future<String> getTempId();
  Future<List<Transaction>> getTransactionList();
  Future<User> updateClientInfo({Map<String, dynamic> json});
  Future<String> validatePhone({String phone});
}
