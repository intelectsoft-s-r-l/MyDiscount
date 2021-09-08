import 'package:flutter/material.dart';
import 'package:my_discount/presentation/widgets/empty_list_widget.dart';

import '../../domain/entities/card.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../infrastructure/core/failure.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../../injectable.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/nointernet_widget.dart';

class CardListPage extends StatelessWidget {
  const CardListPage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomAppBar(
      title: AppLocalizations.of(context).translate('addedcard'),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .85,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<DiscountCard>>(
                future: getIt<IsService>().getRequestActivationCards(),
                builder: (context, snapshot) {
                  final list = snapshot.data;
                  if (snapshot.hasData) {
                    return NotificationListener<
                        OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                        return true;
                      },
                      child: ListView.separated(
                        padding:
                            const EdgeInsets.only(top: 15, left: 10, right: 10),
                        separatorBuilder: (context, index) => Container(
                          height: 10,
                        ),
                        itemCount: list!.length,
                        itemBuilder: (context, index) {
                          final card = list[index];
                          return CardWidget(card: card);
                        },
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    if (snapshot.error is EmptyList) {
                      return EmptyListWidget(
                        size: size,
                        assetPath: 'assets/icons/no_transaction_img.png',
                        localizationKey: 'nocards',
                      );
                    } else {
                      return const NoInternetWidget();
                    }
                  }
                  return CircularProgresIndicatorWidget();
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/addcardcompanylist',
                  arguments:
                      AppLocalizations.of(context).translate('companies'),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .5,
                child: Text(
                  AppLocalizations.of(context).translate('addcard'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.card,
  }) : super(key: key);

  final DiscountCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          top: BorderSide(width: 2, color: Colors.grey),
          left: BorderSide(width: 2, color: Colors.grey),
          right: BorderSide(width: 2, color: Colors.grey),
          bottom: BorderSide(width: 2, color: Colors.grey),
        ),
      ),
      height: 80,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(3),
                  width: 30,
                  height: 30,
                  child: card.companyLogo != []
                      ? Image.memory(card.companyLogo)
                      : const Placeholder()),
              Text(card.companyName),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .53,
                    child: OverflowBar(children: [
                      Text(
                        AppLocalizations.of(context).translate('card'),
                      ),
                      Text(
                        '${card.code}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  ),
                ],
              ),
              const Spacer(),
              CheckStatusWidget(status: card.status)
            ],
          ),
        ],
      ),
    );
  }
}

class CheckStatusWidget extends StatelessWidget {
  final int status;

  const CheckStatusWidget({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 0:
        return const Status(
          jKey: 'statuswaiting',
          icon: Icons.cached_rounded,
          color: Colors.amber,
        );
      case 1:
        return const Status(
          jKey: 'statusaccepted',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );
      case 2:
        return const Status(
          jKey: 'statusdenied',
          icon: Icons.highlight_remove_sharp,
          color: Colors.red,
        );
    }
    return Container();
  }
}

class Status extends StatelessWidget {
  const Status({this.icon, this.color, required this.jKey});
  final String jKey;
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context).translate(jKey),
          style: TextStyle(color: color),
        ),
        Icon(
          icon,
          color: color,
        )
      ],
    );
  }
}
