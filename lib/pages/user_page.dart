import 'package:MyDiscount/core/failure.dart';

import 'package:MyDiscount/services/company_service.dart';
import 'package:flutter/material.dart';

import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/companies_list_widget.dart';
import '../widgets/noCompani_list_widget.dart';
import '../widgets/nointernet_widget.dart';


class CompanyListPage extends StatelessWidget {
  final CompanyService data = CompanyService();

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final String pageName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      //backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: FutureBuilder<dynamic>(
                    future: data.getCompanyList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return CompaniesList(snapshot.data);
                      }
                      if (snapshot.hasError) {
                        return snapshot.error is EmptyList
                            ? NoCompanieList()
                            : NoInternetWidget();
                      }
                      return CircularProgresIndicatorWidget();
                      /*  return Scaffold(
                        body: snapshot.data != false
                            ? Container(
                                child: snapshot.hasData
                                    ? Container(
                                        child: snapshot.data.length != 0
                                            ? CompaniesList(snapshot.data)
                                            : NoCompanieList(),
                                      )
                                    : CircularProgresIndicatorWidget(),
                              )
                            : Container(
                                child: NoInternetWidget(),
                              ),
                      ); */
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
