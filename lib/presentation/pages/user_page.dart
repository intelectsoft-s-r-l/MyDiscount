import 'package:flutter/material.dart';

import '../../core/failure.dart';
import '../../domain/entities/company_model.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../injectable.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/company_page_widgets/companies_list_widget.dart';
import '../widgets/company_page_widgets/noCompani_list_widget.dart';
import '../widgets/nointernet_widget.dart';

class CompanyListPage extends StatelessWidget {
  const CompanyListPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  pageName = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: FutureBuilder<List<Company>>(
                    future: getIt<IsService>().getCompanyList(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return CompaniesList(snapshot.data as List<Company>);
                      }
                      if (snapshot.hasError) {
                        return snapshot.error is EmptyList ? const NoCompanieList() : const NoInternetWidget();
                      }
                      return CircularProgresIndicatorWidget();
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
