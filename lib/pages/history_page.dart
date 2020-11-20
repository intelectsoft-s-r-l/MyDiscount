
import 'package:MyDiscount/localization/localizations.dart';
import 'package:MyDiscount/widgets/transactions_list_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
             TopBarImage(size: size),
             AppBarText(size: size, text: AppLocalizations.of(context).translate('text22'))
            ],
          ),
          TransactionList(size: size,),
        ],
      ),
    );
  }
}
