import 'package:MyDiscount/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/transactions_list_widget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage();
  @override
  Widget build(BuildContext context) {
    final String pageName = ModalRoute.of(context).settings.arguments;
    return CustomAppBar(
      title: pageName,
      child: TransactionList(),
    );
  }
}
