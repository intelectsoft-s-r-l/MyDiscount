/* import 'package:flutter/material.dart';

import '../services/qr_service.dart';
import '../widgets/companies_list_widget.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/noCompani_list_widget.dart';
import '../widgets/nointernet_widget.dart';

class Companies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QrService data = QrService(); 

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
          future: data.getCompanyList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Scaffold(
              body: snapshot.data != false
                  ? Container(
                      child: snapshot.hasData
                          ? Container(
                              decoration: const BoxDecoration(
                                color: const Color.fromRGBO(240, 242, 241, 1),
                              ),
                              child: snapshot.data.length != 0
                                  ? CompaniesList(snapshot.data)
                                  : NoCompanieList(),
                            )
                          : CircularProgresIndicatorWidget(),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 242, 241, 1),
                      ),
                      child: NoInternetWidget(),
                    ),
            );
          },
        ),
      ),
    );
  }
}
 */