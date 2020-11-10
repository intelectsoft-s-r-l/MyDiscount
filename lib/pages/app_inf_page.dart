import 'package:MyDiscount/widgets/localizations.dart';
import 'package:flutter/material.dart';

import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class AppInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              TopBarImage(size: size),
              AppBarText(size: size, text: 'App Info'),
              Positioned(
                top: size.height * .06,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            height: size.height * .8,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('pc'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: AppLocalizations.of(context).translate('ig'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)
                              .translate('confdate'),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('utcol'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('par1'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('par2'),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('ua'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('par3'),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('ai'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('par4'),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('ij'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('par5'),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('c'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('par6'),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('ig1'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context).translate('par7'),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
