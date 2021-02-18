import 'package:MyDiscount/domain/entities/company_model.dart';
import 'package:MyDiscount/infrastructure/is_service_impl.dart';
import 'package:MyDiscount/injectable.dart';
import 'package:flutter/material.dart';

import '../core/failure.dart';

import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/company_page_widgets/companies_list_widget.dart';
import '../widgets/company_page_widgets/noCompani_list_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/nointernet_widget.dart';

class CompanyListPage extends StatelessWidget {
  const CompanyListPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final obj = ModalRoute.of(context).settings.arguments;
    final list = obj is Set ? obj.toList() : [];
    final String pageName = list[0];

    return CustomAppBar(
      title: pageName,
      child: Container(
        color: Colors.white,
        child: FutureBuilder<List<Company>>(
          future: getIt<IsServiceImpl>().getCompanyList(),
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
