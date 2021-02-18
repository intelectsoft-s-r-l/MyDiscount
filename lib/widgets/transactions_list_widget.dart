import 'package:MyDiscount/domain/entities/tranzaction_model.dart';
import 'package:MyDiscount/domain/repositories/is_service_repository.dart';
import 'package:MyDiscount/injectable.dart';
import 'package:MyDiscount/widgets/transaction_page_widgets/transaction_list_widget.dart';
import 'package:flutter/material.dart';

import '../core/failure.dart';
import '../core/localization/localizations.dart';

import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/nointernet_widget.dart';


class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            color: Colors.white,
            child: FutureBuilder<List<Transaction>>(
              future: getIt<IsService>().getTransactionList(),
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
                      child: SizedBox(
                        width: size.width,
                        height: size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              top: size.width * .15,
                              left: 0,
                              child: SizedBox(
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
                              child: SizedBox(
                                width: size.width,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('text66'),
                                    style: const TextStyle(
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
                    return const NoInternetWidget();
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
