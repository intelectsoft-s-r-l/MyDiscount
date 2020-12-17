import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/credentials.dart';
import '../models/tranzaction_model.dart';
import '../services/remote_config_service.dart';

class TransactionService {
  Credentials _credentials = Credentials();

  Future<List<Transaction>> getTransactions() async {
    final serviceName = await getServiceNameFromRemoteConfig();

    final url = '$serviceName/json/GetTransactions';
    final response = await http.get(url, headers: _credentials.header);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    //data.remove('id');
    final list = decodedResponse['Transactions'] as List;

    return list.map((e) => Transaction.fromJson(e)).toList();
  }
}
