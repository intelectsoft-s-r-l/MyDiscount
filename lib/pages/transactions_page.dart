import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/transaction_page_widgets/transaction_page__list_widget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage();
  @override
  Widget build(BuildContext context) {
    final obj = ModalRoute.of(context).settings.arguments;
    final list = obj is Set ? obj.toList() : [];
    final String pageName = list[0];
    return CustomAppBar(
      title: pageName,
      child: TransactionPageList(),
    );
  }
}
