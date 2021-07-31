import 'package:flutter/material.dart';
import 'package:my_discount/domain/entities/tranzaction_model.dart';
import 'package:my_discount/domain/repositories/is_service_repository.dart';
import 'package:my_discount/infrastructure/core/failure.dart';
import 'package:my_discount/presentation/widgets/circular_progress_indicator_widget.dart';
import 'package:my_discount/presentation/widgets/empty_list_widget.dart';
import 'package:my_discount/presentation/widgets/nointernet_widget.dart';
import 'package:my_discount/presentation/widgets/transaction_page_widgets/transaction_list_widget.dart';

import '../../injectable.dart';
import '../widgets/custom_app_bar.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage();
  @override
  Widget build(BuildContext context) {
    final pageName = ModalRoute.of(context)!.settings.arguments as String?;
    final size = MediaQuery.of(context).size;
    return CustomAppBar(
      title: pageName,
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
      ),
    );
  }
}
