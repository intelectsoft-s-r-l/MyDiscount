import 'package:flutter/material.dart';

import '../../../domain/entities/tranzaction_model.dart';
import '../../../domain/repositories/is_service_repository.dart';
import '../../../infrastructure/core/failure.dart';
import '../../../injectable.dart';
import '../../widgets/circular_progress_indicator_widget.dart';
import '../../widgets/nointernet_widget.dart';
import '../empty_list_widget.dart';
import '../transaction_page_widgets/transaction_list_widget.dart';

class TransactionPageList extends StatelessWidget {
  const TransactionPageList({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
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
              return EmptyListWidget(
                size: size,
                assetPath: 'assets/icons/no_transaction_img.png',
                localizationKey: 'notransactions',
              );
            } else {
              return const NoInternetWidget();
            }
          }
          return CircularProgresIndicatorWidget();
        },
      ),
    );
  }
}

