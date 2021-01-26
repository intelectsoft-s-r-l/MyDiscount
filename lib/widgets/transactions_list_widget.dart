import 'package:MyDiscount/domain/entities/tranzaction_model.dart';
import 'package:flutter/material.dart';

import '../core/failure.dart';
import '../core/localization/localizations.dart';

import '../services/transactions_service.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/transaction_list_widget.dart';

class TransactionList extends StatelessWidget {
  final TransactionService service ;

  TransactionList({
    Key key,this.service
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
                    return Center(
                      child: Container(
                        width: size.width,
                        height: size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              top: size.width * .15,
                              left: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width * .6,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset(
                                    'assets/icons/no_transaction.png',
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: size.width * .65,
                              child: Container(
                                width: size.width,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('text66'),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
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
