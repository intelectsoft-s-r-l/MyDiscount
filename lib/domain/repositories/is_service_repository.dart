import 'package:MyDiscount/core/constants/credentials.dart';
import 'package:MyDiscount/domain/entities/company_model.dart';
import 'package:MyDiscount/domain/entities/news_model.dart';
import 'package:MyDiscount/domain/entities/tranzaction_model.dart';
import 'package:MyDiscount/domain/entities/user_model.dart';

abstract class IsService {
  Future<String> getTid(User user,Credentials credentials);
  Future<List<Company>> getCompanyList(Credentials credentials);
  Future<List<Transaction>> getTransactions(User user,Credentials credentials);
  Future<List<News>> getNews(Credentials credentials);
  Future<String> getCodeFromServer(Credentials credentials);
}
