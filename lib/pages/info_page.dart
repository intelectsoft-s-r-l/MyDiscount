import 'package:MyDiscount/localization/localizations.dart';
import 'package:MyDiscount/widgets/profile_home_item_widget.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String pageName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            width: size.width,
            //height: size.height * .9,
            child: Container(
              //padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ProfileHomeItemWidget(
                    pageName: AppLocalizations.of(context).translate('text32'),
                    routeName: '/politicaconf',
                  ),
                  ProfileHomeItemWidget(
                    pageName: AppLocalizations.of(context).translate('text33'),
                    routeName: '/technicdetail',
                  ),
                  ProfileHomeItemWidget(
                    pageName: AppLocalizations.of(context).translate('text30'),
                    routeName: '/about',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
