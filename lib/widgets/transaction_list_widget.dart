import 'package:MyDiscount/domain/entities/tranzaction_model.dart';
import 'package:flutter/material.dart';


import '../widgets/tranzaction_widget.dart';

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
      separatorBuilder: (context, index) => const SizedBox(
        height: 3,
      ),
      shrinkWrap: true,
      itemCount: transactionList.length,
      itemBuilder: (context, index) {
        return TranzactionWidget(
          size: size,
          transaction: transactionList[index],
        );
      },
    );
  }
}