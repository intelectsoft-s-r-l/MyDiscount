import 'package:flutter/material.dart';
import 'package:my_discount/core/localization/localizations.dart';

class EmptyNewsWidget extends StatelessWidget {
  const EmptyNewsWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size.width,
          height: size.width,
          child: Stack(
            children: [
              Positioned(
                top: size.width * .15,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * .75,
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset('assets/icons/no_news.png')),
                ),
              ),
              Positioned(
                left: 0,
                top: size.width * .75,
                child: Container(
                  alignment: Alignment.center,
                  width: size.width,
                  child: Text(
                    AppLocalizations.of(context)!.translate('nonews')!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
