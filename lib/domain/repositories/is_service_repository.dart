//import 'package:MyDiscount/core/constants/credentials.dart';
import 'package:MyDiscount/domain/entities/company_model.dart';
import 'package:MyDiscount/domain/entities/news_model.dart';
import 'package:MyDiscount/domain/entities/profile_model.dart';
import 'package:MyDiscount/domain/entities/tranzaction_model.dart';
//import 'package:MyDiscount/domain/entities/user_model.dart';

abstract class IsService {
  Future<List<News>> getAppNews();
  Future<Profile> getClientInfo();
  Future<List<Company>> getCompanyList();
  Future<String> getTempId();
  Future<List<Transaction>> getTransactionList();
  Future<void> updateClientInfo({Map<String,dynamic>json});
  Future<String> validatePhone({String phone});
}
