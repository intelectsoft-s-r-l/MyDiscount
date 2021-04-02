import 'dart:io';

import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:searchfield/searchfield.dart';

import '../../aplication/card_bloc/add_card_page_bloc.dart';
import '../../core/localization/localizations.dart';
import '../../domain/entities/company_model.dart';

import '../../injectable.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage();
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController _controller = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _node.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final company = ModalRoute.of(context).settings.arguments as Company;
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
              Navigator.maybeOf(context)..pop()..pop();
              // Navigator.popUntil(context, ModalRoute.withName('/cardlist'));
            },
          ),
          centerTitle: true,
          title: Text(
            '${AppLocalizations.of(context).translate('connectcard')}: ${company.name}',
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
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          height: 110,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.memory(company.logo),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        /* Text(
                          company.name,
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize:25),
                        ), */
                        const SizedBox(height: 40),
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
