import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../aplication/company_list_bloc/companylist_bloc.dart';
import '../../injectable.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/company_page_widgets/companies_list_widget.dart';
import '../widgets/company_page_widgets/no_company_list_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/nointernet_widget.dart';

class CompanyListPage extends StatelessWidget {
  const CompanyListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageName = ModalRoute.of(context)!.settings.arguments as String?;

    return BlocProvider(
      create: (context) => getIt<CompanylistBloc>()..add(FetchCompanyList()),
      child: CustomAppBar(
        title: pageName,
        child: Container(
          color: Colors.white,
          child: BlocConsumer<CompanylistBloc, CompanylistState>(
            listener: (context, state) {},
            builder: (BuildContext context, state) {
              if (state is CompanylistLoaded) {
                return CompaniesList(state.list, true);
              }
              if (state is EmptyCompanyList) {
                return const NoCompanyList();
              }
              if (state is CompanylistError) {
                return const NoInternetWidget();
              }
              return CircularProgresIndicatorWidget();
            },
          ),
        ),
      ),
    );
  }
}
