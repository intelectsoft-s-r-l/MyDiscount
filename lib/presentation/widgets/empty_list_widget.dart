import 'package:flutter/material.dart';

import '../../infrastructure/core/localization/localizations.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    Key? key,
    required this.size,
    required this.assetPath,
    required this.localizationKey,
  }) : super(key: key);

  final Size size;
  final String assetPath;
  final String localizationKey;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size.width,
        height: size.width,
        child: Stack(
          children: [
            Positioned(
              top: size.width * .15,
              left: 0,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset(
                  assetPath,
                  filterQuality: FilterQuality.high,
                  height: MediaQuery.of(context).size.width * .75,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: size.width * .75,
              child: Container(
                width: size.width,
                child: Text(
                    AppLocalizations.of(context).translate(localizationKey),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
