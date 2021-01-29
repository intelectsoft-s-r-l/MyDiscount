import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/credentials.dart';
import '../core/failure.dart';
import '../core/formater.dart';
import '../models/user_credentials.dart';
import '../models/tranzaction_model.dart';
import '../services/internet_connection_service.dart';
import '../services/remote_config_service.dart';

class TransactionService {
  Credentials _credentials = Credentials();
  Formater formater = Formater();
  NetworkConnectionImpl status = NetworkConnectionImpl();

  Future<List<Transaction>> getTransactions() async {
    if (await status.isConnected) {
      try {
        final serviceName = await getServiceNameFromRemoteConfig();

        final _bodyData = await UserCredentials().getRequestBodyData(false);

        final url = '$serviceName/json/GetTransactions';

        final response =
            await http.post(url, headers: _credentials.header, body: _bodyData);

        if (response.statusCode == 200) {
          final Map<String, dynamic> _decodedResponse =
              json.decode(response.body);

          final List<dynamic> _listOfTransactionsMaps = [
            {
              "Amount": 1267.543,
              "Company": "SUPRATEN",
              "DateTimeOfSale": "\/Date(928138800000+0300)\/",
              "SalesPoint": "str. Petricani",
            },
            {
              "Amount": 126.54,
              "Company": "SUPRATEN",
              "DateTimeOfSale": "\/Date(928138800000+0300)\/",
              "SalesPoint": "str. Petricani",
            }
          ];
          //  _decodedResponse['Transactions'];

          if (_listOfTransactionsMaps.isNotEmpty) {
            formater.parseDateTime(_listOfTransactionsMaps, 'DateTimeOfSale');

            final transactions =
                formater.checkCompanyLogo(_listOfTransactionsMaps);
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
/* {
		"Amount":12678967.543233,
		"Company":"String content",
		"DateTimeOfSale":"\/Date(928138800000+0300)\/",
		"SalesPoint":"String content"
	} */

/* {
		"Amount":"String content",
		"ID":2147483647,
		"Logo":"String content",
		"Name":"String content"
	} */
