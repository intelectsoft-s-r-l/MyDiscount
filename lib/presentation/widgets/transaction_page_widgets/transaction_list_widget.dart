import 'package:flutter/material.dart';

import '../../../domain/entities/tranzaction_model.dart';
import '../transaction_page_widgets/tranzaction_widget.dart';

class TranzactionListWidget extends StatelessWidget {
  const TranzactionListWidget({
    Key key,
    @required this.size,
    this.transactionList,
  }) : super(key: key);

  final Size size;
  final List<Transaction> transactionList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: ClampingScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(
        height: 3,
      ),
      shrinkWrap: true,
      itemCount: transactionList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: TranzactionWidget(
            size: size,
            transaction: transactionList[index],
          ),
        );
      },
    );
  }
}
