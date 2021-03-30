import 'package:flutter/material.dart';

import '../../core/failure.dart';
import '../../domain/entities/company_model.dart';
import '../../domain/repositories/local_repository.dart';
import '../../injectable.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/company_page_widgets/companies_list_widget.dart';
import '../widgets/company_page_widgets/noCompani_list_widget.dart';

import '../widgets/nointernet_widget.dart';

class AddCardCompanyListPage extends StatelessWidget {
  const AddCardCompanyListPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pageName = ModalRoute.of(context).settings.arguments;
    final _controller = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(pageName),
        /* TextFormField(
          controller: _controller,
          onChanged: (text) {},
        ), */
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              color: Colors.white,
              child: FutureBuilder<List<Company>>(
                future:
                    getIt<LocalRepository>().getCachedCompany(_controller.text),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return CompaniesList(snapshot.data);
                  }
                  if (snapshot.hasError) {
                    return snapshot.error is EmptyList
                        ? const NoCompanieList()
                        : const NoInternetWidget();
                  }
                  return CircularProgresIndicatorWidget();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
