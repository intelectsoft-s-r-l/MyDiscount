import 'package:flutter/material.dart';

import '../core/failure.dart';
import '../core/localization/localizations.dart';
import '../models/tranzaction_model.dart';
import '../services/transactions_service.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/nointernet_widget.dart';

class TransactionList extends StatelessWidget {
  final TransactionService service = TransactionService();

  TransactionList({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            color: Colors.white,
            child: FutureBuilder<List<Transaction>>(
              future: service.getTransactions(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TranzactionListWidget(
                    size: size,
                    transactionList: snapshot.data,
                  );
                }
                if (snapshot.hasError) {
                  if (snapshot.error is EmptyList) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                            AppLocalizations.of(context).translate('text66'),
                            textAlign: TextAlign.center),
                      ),
                    );
                  } else {
                    return NoInternetWidget();
                  }
                }
                return CircularProgresIndicatorWidget();
              },
            ),
          ),
        ),
      ),
    );
  }
}

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
      separatorBuilder: (context, index) => SizedBox(
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

class TranzactionWidget extends StatelessWidget {
  const TranzactionWidget({
    Key key,
    @required this.size,
    this.transaction,
  }) : super(key: key);

  final Size size;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        width: size.width * .95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OverflowBar(
              children: [
                Text(
                  AppLocalizations.of(context).translate('text62'),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Text(
                  "${transaction.company}",
                  //style: TextStyle(fontSize: 20),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OverflowBar(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('text63'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          /* fontSize: 15, */ color: Colors.red),
                    ),
                    Text(
                      " ${transaction.dateOfSale}",
                      //style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                OverflowBar(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('text65'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(
                      "${transaction.amount} lei",
                      //style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            OverflowBar(
              children: [
                Text(
                  AppLocalizations.of(context).translate('text64'),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Text(
                  " ${transaction.salesPoint}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
