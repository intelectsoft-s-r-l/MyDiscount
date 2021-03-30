import 'dart:io';

import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:searchfield/searchfield.dart';

import '../../aplication/card_bloc/add_card_page_bloc.dart';
import '../../core/localization/localizations.dart';
import '../../domain/entities/company_model.dart';
//import '../../domain/repositories/local_repository.dart';
import '../../injectable.dart';
//import '../widgets/custom_app_bar.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage();
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  List<Company> companylist;
  Company selectedCompany;
  final TextEditingController _controller = TextEditingController();
  //final TextEditingController _controllerC = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FocusNode _node = FocusNode();
  bool showError = false;
  final err = ErrorWidget('Erorrr');
  @override
  void initState() {
    super.initState();
    _node.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final company = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
      create: (context) => getIt<AddCardPageBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Platform.isAndroid
                ? Icons.arrow_back_sharp
                : Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/cardlist'));
            },
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate('connectcard'),
            style: const TextStyle(fontSize: 18),
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
              child:
                  /*  CustomAppBar(
        title: AppLocalizations.of(context).translate('connectcard'),
        child:  */
                  Container(
                color: Colors.white,
                child: BlocConsumer<AddCardPageBloc, AddCardPageState>(
                  listener: (context, state) {
                    if (state is SavedCardForm) {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/cardlist'));
                    }
                    if (state is CardError) {
                      //_node.unfocus();
                      Flushbar(
                        message: state.error,
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    }
                    context
                        .read<AddCardPageBloc>()
                        .add(CompanyChanged(company));
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /* Container(width: 150,
                          child: SearchField(
                            hint: 'Select a Company',
                            //initialValue: companylist.first.name,
                            suggestions: [
                              'asdf',
                              'asdfa',
                              'aerwrfd'
                            ] /* companylist
                                              .map((e) => e.name)
                                              .toList() */
                            ,
                            controller: _controllerC,
                            itemHeight: 45,
                            onTap: (val) {
                              _controllerC.text = val;
                            },
                          ),
                        ), */
                        /*  Row(
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
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  //height: 100,
                                  width: 150,
                                  child: FutureBuilder<List<Company>>(
                                    future: getIt<LocalRepository>()
                                        .getCachedCompany(),
                                    builder: (context, snapshot) {
                                      final companylist = snapshot.data;
                                      return snapshot.hasData
                                          ? SearchField(
                                              hint: 'Select a Company',
                                              maxSuggestionsInViewPort: 2,
                                             /*  initialValue:
                                                  companylist.first.name, */
                                              suggestions: companylist
                                                  .map((e) => e.name)
                                                  .toList(),
                                              controller: _controllerC,
                                              itemHeight: 45,
                                              onTap: (val) {
                                                _controllerC.text = val;
                                              },
                                            )
                                          /* DropdownButton<Company>(
                                        hint: selectedCompany == null
                                            ? Text(AppLocalizations.of(context)
                                                .translate('selectcompany'))
                                            : Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    child:
                                                        selectedCompany?.logo !=
                                                                null
                                                            ? Image.memory(
                                                                selectedCompany
                                                                    ?.logo,
                                                              )
                                                            : null,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(selectedCompany?.name ??
                                                      ''),
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
                                                              child: Image
                                                                  .memory(company
                                                                      ?.logo)),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(company?.name ??
                                                              '')
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList()
                                            : [],
                                        onChanged: (Company company) {
                                          /* context
                                              .read<AddCardPageBloc>()
                                              .add(CompanyChanged(company)); */
                                          setState(() {
                                            selectedCompany = company;
                                            showError = false;
                                          });
                                        },
                                      ) */
                                          : Container();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ), */
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .05,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('inputcardnumber'),
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
                              focusNode: _node,
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
                                  return AppLocalizations.of(context)
                                      .translate('addcardnum');
                                }
                                /*  if (selectedCompany == null) {
                            return AppLocalizations.of(context)
                                .translate('selectcompany');
                          } */

                                /* return ''; */
                              },
                              onSaved: (input) {
                                /*  context
                              .read<AddCardPageBloc>()
                              .add(CardNumberChanged(input)); */
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
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              _node.unfocus();
                              context
                                  .read<AddCardPageBloc>()
                                  .add(SaveNewCard(company, _controller.text));
                              //print(map);

                            }
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('addcard'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
