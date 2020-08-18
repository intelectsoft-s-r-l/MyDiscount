import 'dart:convert';

import 'package:MyDiscount/services/internet_connection_service.dart';
import 'package:MyDiscount/services/qr_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import '../widgets/localizations.dart';

import 'package:provider/provider.dart';

class Companies extends StatefulWidget {
  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  @override
  Widget build(BuildContext context) {
    bool isInternet = true;
    final data = Provider.of<QrService>(context);
    final internet = Provider.of<InternetConnection>(context);
    getListOfCompanies() async {
      DataConnectionStatus status = await internet.internetConection();
      switch (status) {
        case DataConnectionStatus.connected:
          var listCompanies = await data.getCompanyList();
          if (listCompanies.contains("1")) {
            setState(() {
              isInternet = false;
            });
            return isInternet;
          } else {
            return listCompanies;
          }

          break;
        case DataConnectionStatus.disconnected:
          setState(() {
            isInternet = false;
          });
          return isInternet;
          
      }
      return [];
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(240, 242, 241, 1),
        ),
        child: FutureBuilder<dynamic>(
          future: getListOfCompanies(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print(snapshot.data);
            return Scaffold(
              body: snapshot.data != false
                  ? Container(
                      child: snapshot.hasData
                          ? Container(
                              decoration: const BoxDecoration(
                                color: const Color.fromRGBO(240, 242, 241, 1),
                              ),
                              child: snapshot.data.length != 0
                                  ? ListView.separated(
                                      padding: const EdgeInsets.all(10),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 3,
                                      ),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) => Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        elevation: 2.0,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(5),
                                          leading: Container(
                                              width: 80,
                                              height: 80,
                                              child: Image.memory(
                                                Base64Decoder().convert(
                                                    '${snapshot.data[index]['Logo']}'),
                                              )),
                                          title: Text(
                                            '${snapshot.data[index]['Name']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          /* subtitle: Text(
                                              'Index:${snapshot.data[index]['Index']}'), */
                                          trailing: Container(
                                            width: 80,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate('text11'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  '${snapshot.data[index]['Amount']} lei',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                          ),
                                          Image.asset(
                                            'assets/icons/companie.jpg',
                                            scale: 1.2,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('text13'),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('text14'),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                            )
                          : Container(
                              child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.green),
                              ),
                            )),
                    )
                  : Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: const Color.fromRGBO(240, 242, 241, 1),
                        ),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child:
                                    Image.asset('assets/icons/no internet.png'),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                AppLocalizations.of(context).translate('text6'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                AppLocalizations.of(context).translate('text7'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
