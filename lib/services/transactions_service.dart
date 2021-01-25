import 'dart:convert';

import 'package:MyDiscount/domain/entities/tranzaction_model.dart';
import 'package:MyDiscount/services/user_credentials.dart';
import 'package:http/http.dart' as http;

import '../core/constants/credentials.dart';
import '../core/failure.dart';
import '../core/formater.dart';

import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';

class TransactionService {
  Credentials _credentials = Credentials();
  Formater formater = Formater();
  final NetworkConnectionImpl status;

  TransactionService(this.status);

  Future<List<Transaction>> getTransactions() async {
    final serviceName = await getServiceNameFromRemoteConfig();

    final _bodyData = await UserCredentials().getRequestBodyData(false);

    if (await status.isConnected) {
      try {
        final url = '$serviceName/json/GetTransactions';
        final response =
            await http.post(url, headers: _credentials.header, body: _bodyData);
        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print(decodedResponse);
          final list = decodedResponse['Transactions'] as List;
          if (list.isNotEmpty) {
            formater.parseDateTimeAndSetExpireDate(list, 'DateTimeOfSale');
            final transactions = formater.checkCompanyLogo(list);
            return transactions.map((e) => Transaction.fromJson(e)).toList();
          } else {
            throw EmptyList();
          }
        } else {
          throw NoInternetConection();
        }
      } catch (e) {
        throw EmptyList();
      }
    } else {
      throw NoInternetConection();
    }
  }
}
