import 'package:is_service/service_client_response.dart';

import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../../domain/entities/tranzaction_model.dart';
import '../entities/card.dart';
import '../entities/user_model.dart';

/// [IsService] is an interface to vork with `IntelectSoft` API fuctions.
abstract class IsService {
  /// Return a list of [News] created in Portal from Client.
  Future<List<News>> getAppNews();

  /// Check if the [User] with this `id` and `registerMode` was created earlier
  /// and return user profile data if is created and saves it locally or the
  /// [142] error code with message `Card not exist` if not.
  Future<Profile> getClientInfo({String? id, int? registerMode});

  /// Create a [User] in MyDiscount service with authorization data or update
  /// [User] data if is changed in Profile Page.
  Future<User> updateClientInfo({required Map<String, dynamic> json});

  /// Add a real Discount Card in MyDiscount service
  Future<IsResponse> requestActivationCard(
      {required Map<String, dynamic> json});

  /// Return a list of real Discound cards added in MyDiscount service
  Future<List<DiscountCard>> getRequestActivationCards({
    String? id,
    int? registerMode,
  });
  /// Return a list of [Company] and saves it locally 
  Future<List<Company>> getCompanyList();
  /// Generate a temporary Discount Card ID to generate a QR code who is valid 
  /// 10 seconds to obtain a discount
  Future<String> getTempId();
  /// Return a list of [Transaction] where it was used MyDiscount service 
  Future<List<Transaction>> getTransactionList();
  
  /// Returns a 4-character string that was generated and sent to the given 
  /// phone number to validate it.  
  Future<String> validatePhone({required String phone});
}
