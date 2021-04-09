import 'dart:ui';

import 'package:flutter/material.dart';

import '../../domain/entities/company_model.dart';
import '../../domain/repositories/local_repository.dart';
import '../../injectable.dart';
import '../widgets/company_page_widgets/companies_list_widget.dart';

class AddCardCompanyListPage extends StatefulWidget {
  const AddCardCompanyListPage({
    Key key,
  }) : super(key: key);

  @override
  _AddCardCompanyListPageState createState() => _AddCardCompanyListPageState();
}

class _AddCardCompanyListPageState extends State<AddCardCompanyListPage>
/* with TickerProviderStateMixin */ {
  List<Company> filteredSearchHistory;
  bool search = false;

  final _node = FocusNode();

  @override
  void initState() {
    super.initState();
    filteredSearchHistory = getIt<LocalRepository>().searchCompany(null);
    _node.requestFocus();
  }

  @override
  void dispose() {
    _node.unfocus();
    super.dispose();
  }

  bool first = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: !search ? 40 : MediaQuery.of(context).size.width * .72,
              height: 40,
              decoration: BoxDecoration(
                  color: !search ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(32)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, bottom: 4),
                      alignment: Alignment.center,
                      child: search
                          ? TextFormField(
                              focusNode: _node,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(),
                                  hintText: 'Cauta',
                                  border: InputBorder.none),
                              onChanged: (value) {
                                setState(() {
                                  filteredSearchHistory =
                                      getIt<LocalRepository>()
                                          .searchCompany(value);
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  Container(
                    child: Material(
                      animationDuration: const Duration(milliseconds: 400),
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(search ? 32 : 0),
                          topRight: const Radius.circular(32),
                          bottomLeft: Radius.circular(search ? 32 : 0),
                          bottomRight: const Radius.circular(32),
                        ),
                        onTap: () {
                          setState(() {
                            search = !search;
                            setState(() {
                              filteredSearchHistory =
                                  getIt<LocalRepository>().searchCompany(null);
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Icon(
                            !search ? Icons.search : Icons.close,
                            color: search ? Colors.green : Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: CompaniesList(filteredSearchHistory)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
