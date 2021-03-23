import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

import '../../core/localization/localizations.dart';
import '../../domain/entities/company_model.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../domain/repositories/local_repository.dart';
import '../../injectable.dart';
import 'custom_app_bar.dart';

class AddCardPage extends StatefulWidget {
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  List<Company> companylist;
  Company selectedCompany;
 final  TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: AppLocalizations.of(context).translate('connectcard'),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                Text(
                  AppLocalizations.of(context).translate('company'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<List<Company>>(
                        future: getIt<LocalRepository>().getCachedCompany(),
                        builder: (context, snapshot) {
                          final companylist = snapshot.data;
                          return snapshot.hasData
                              ? DropdownButton<Company>(
                                  hint: selectedCompany == null
                                      ? Text(AppLocalizations.of(context)
                                          .translate('selectcompany'))
                                      : Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              child:
                                                  selectedCompany?.logo != null
                                                      ? Image.memory(
                                                          selectedCompany?.logo,
                                                        )
                                                      : null,
                                            ),
                                           const SizedBox(width: 10),
                                            Text(selectedCompany?.name ?? ''),
                                          ],
                                        ),
                                  items: companylist != null
                                      ? companylist
                                          .map<DropdownMenuItem<Company>>(
                                            (company) => DropdownMenuItem(
                                              value: company,
                                              child: Container(
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        width: 30,
                                                        height: 30,
                                                        child: Image.memory(
                                                            company?.logo)),
                                                   const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(company?.name ?? '')
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList()
                                      : [],
                                  onChanged: (Company company) {
                                    setState(() {
                                      selectedCompany = company;
                                    });
                                  },
                                )
                              : Container();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                Text(
                  AppLocalizations.of(context).translate('inputcardnumber'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
           const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              child: Form(
                key: _key,
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // ignore: missing_return
                  validator: (code) {
                    if (code.isEmpty) {
                      return 'must be not null';
                    }
                    if (selectedCompany == null) {
                      return 'Select a Company';
                    }

                    /* return ''; */
                  },
                  onSaved: (input) {
                    _controller?.text = input;
                  },
                ),
              ),
            ),
           const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  print(_key.currentState.validate());
                  if (_key.currentState.validate()) {
                    final user = getIt<LocalRepository>().getLocalUser();
                    _key.currentState.save();
                    final map = <String, dynamic>{
                      'CardCode': _controller.text,
                      'CompanyID': selectedCompany.id.toString(),
                      'ID': user.id,
                      'RegisterMode': user.registerMode,
                    };
                    print(map);
                    final resp = await getIt<IsService>()
                        .requestActivationCard(json: map);
                    if (resp.statusCode == 0) {
                      Navigator.pop(context);
                    } else {
                    await  FlushbarHelper.createError(message: resp.errorMessage)
                          .show(context);
                    }
                  }
                },
                child: Text(AppLocalizations.of(context).translate('addcard')))
          ],
        ),
      ),
    );
  }
}
