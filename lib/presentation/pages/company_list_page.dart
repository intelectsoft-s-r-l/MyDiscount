import 'package:flutter/material.dart';

import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/company_page_widgets/companies_list_widget.dart';
import '../widgets/company_page_widgets/noCompani_list_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/nointernet_widget.dart';

import '../../core/failure.dart';
import '../../domain/entities/company_model.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../injectable.dart';

class CompanyListPage extends StatelessWidget {
  const CompanyListPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pageName = ModalRoute.of(context).settings.arguments;

    return CustomAppBar(
      title: pageName,
      child: Container(
        color: Colors.white,
        child: FutureBuilder<List<Company>>(
          future: getIt<IsService>().getCompanyList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return CompaniesList(snapshot.data);
            }
            if (snapshot.hasError) {
              return snapshot.error is EmptyList ? NoCompanieList() : NoInternetWidget();
            }
            return CircularProgresIndicatorWidget();
          },
        ),
      ),
    );
  }
}
