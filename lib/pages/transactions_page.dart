import 'package:flutter/material.dart';

import '../widgets/transactions_list_widget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage();
  @override
  Widget build(BuildContext context) {
    final String pageName = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Column(
          children: [
            TransactionList(),
          ],
        ),
      ),
    );
  }
}
