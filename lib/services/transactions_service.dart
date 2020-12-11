import 'dart:convert';

import 'package:MyDiscount/constants/credentials.dart';
import 'package:MyDiscount/models/tranzaction_model.dart';
import 'package:MyDiscount/services/remote_config_service.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + Credentials.encoded,
  };

  Future<List<Transaction>> getTransactions() async {
    final serviceName = await getServiceNameFromRemoteConfig();

    final url = '$serviceName/json/GetTransactions';
    final response = await http.get(url, headers: _headers);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    //data.remove('id');
    final list = decodedResponse['Transactions'] as List;

    return list.map((e) => Transaction.fromJson(e)).toList();
  }
}
