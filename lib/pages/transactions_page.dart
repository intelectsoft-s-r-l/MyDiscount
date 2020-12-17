import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';
import '../widgets/transactions_list_widget.dart';

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
