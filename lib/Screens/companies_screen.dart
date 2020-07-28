import 'dart:convert';

import 'package:flutter/material.dart';
import '../widgets/localizations.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:provider/provider.dart';

import '../services/remote_config_service.dart';

class Companies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<RemoteConfigService>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 10,
          bottom: 5, /*  left: 2, right: 2 */
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(240, 242, 241, 1),
        ),
        child: FutureBuilder<dynamic>(
          future: data.setupRemoteConfig().whenComplete(() => null),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print(snapshot.data);
            return /* snapshot.hasData &&  */ snapshot.data != null
                ? WelcomeWidget(remoteConfig: snapshot.data)
                : Container(
                    child: Center(child: const CircularProgressIndicator()),
                  );
          },
        ),
      ),
    );
  }
}

class WelcomeWidget extends AnimatedWidget {
  WelcomeWidget({this.remoteConfig}) : super(listenable: remoteConfig);

  final RemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    var companies = json.decode(remoteConfig.getString('list_companies'))
        as Map<String, dynamic>;
    var list = companies['companies'] as List;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(240, 242, 241, 1),
        ),
        //padding: EdgeInsets.all(10),
        child: list.length != 0
            ? ListView.separated(
                padding: EdgeInsets.all(10),
                separatorBuilder: (context, index) => SizedBox(
                  height: 5,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 2.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(20),
                    leading: Container(
                        width: 80,
                        height: 80,
                        child: Image.memory(
                          Base64Decoder().convert('${list[index]['logo']}'),
                        )),
                    title: Text(
                      '${list[index]['name']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Image.asset('assets/icons/companie.jpg'),
                    Text(
                      AppLocalizations.of(context).translate('text13'),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text14'),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}