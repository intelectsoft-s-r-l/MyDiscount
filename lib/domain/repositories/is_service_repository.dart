import 'package:is_service/service_client_response.dart';

import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../../domain/entities/tranzaction_model.dart';
import '../auth/user_model.dart';
import '../entities/card.dart';

abstract class IsService {
  Future<List<News>> getAppNews();
  
  Future<Profile> getClientInfo({String id, int registerMode});
  Future<User> updateClientInfo({Map<String, dynamic> json});
  
  Future<IsResponse> requestActivationCard({Map<String, dynamic> json});
  Future<List<DiscountCard>> getRequestActivationCards({String id, int registerMode});
  
  Future<List<Company>> getCompanyList();
  
  Future<String> getTempId();
  
  Future<List<Transaction>> getTransactionList();
  
  Future<String> validatePhone({String phone});
}
