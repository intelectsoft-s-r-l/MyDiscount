import 'package:MyDiscount/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../core/failure.dart';
import '../models/company_model.dart';
import '../services/company_service.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/companies_list_widget.dart';
import '../widgets/noCompani_list_widget.dart';
import '../widgets/nointernet_widget.dart';

class CompanyListPage extends StatelessWidget {
  final CompanyService data = CompanyService();

  @override
  Widget build(BuildContext context) {
    final String pageName = ModalRoute.of(context).settings.arguments;

    return CustomAppBar(
      title: pageName,
      child: Container(
        color: Colors.white,
        child: FutureBuilder<List<Company>>(
          future: data.getCompanyList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return CompaniesList(snapshot.data);
            }
            if (snapshot.hasError) {
              return snapshot.error is EmptyList
                  ? NoCompanieList()
                  : NoInternetWidget();
            }
            return CircularProgresIndicatorWidget();
          },
        ),
      ),
    );
  }
}
