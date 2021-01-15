import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../core/localization/localizations.dart';
import '../providers/phone_number.dart';
import '../services/phone_verification.dart';
import '../widgets/pin_code_dialog.dart';

class ProfileFieldWidget extends StatefulWidget {
  const ProfileFieldWidget({
    Key key,
    @required this.labelText,
  }) : super(key: key);

  final String labelText;

  @override
  _ProfileFieldWidgetState createState() => _ProfileFieldWidgetState();
}

class _ProfileFieldWidgetState extends State<ProfileFieldWidget> {
  TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();

  bool isEdit = false;

  bool isStartTimer = false;

  @override
  void dispose() {
    super.dispose();
    focusNode?.dispose();
    if (mounted) focusNode?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhoneNumber>(
      create: (context) => PhoneNumber(),
      builder: (context, _) {
        final provider = Provider.of<PhoneNumber>(context, listen: true);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                provider.editing
                    ? Expanded(
                        child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: TextFormField(
                            focusNode: focusNode,
                            controller: _phoneController,
                            maxLength: 9,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('text42'),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .translate('text43');
                              } else if (value.characters.first != '0') {
                                return AppLocalizations.of(context)
                                    .translate('text57');
                              } else if (value.length < 9) {
                                return AppLocalizations.of(context)
                                    .translate('text44');
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phoneController.text = value;
                            }),
                      ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(widget.labelText,
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                          FutureProvider.value(
                              value: PhoneNumber().getUserPhone(),
                              builder: (context, _) {
                                if (provider.phone != null) {
                                  return Container(
                                      child: Text(
                                    provider.phone,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ));
                                }
                                return Container();
                              }),
                        ],
                      ),
              ],
            ),
            /*   ), */
            Divider(),
            Consumer(
              builder: (context, PhoneNumber provider, _) => OutlineButton(
                splashColor: Colors.green,
                borderSide: BorderSide(color: Colors.green),
                highlightColor: Colors.green,
                highlightedBorderColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: provider.editing
                    ? Text(AppLocalizations.of(context).translate('text60'))
                    : provider.phone != ''
                        ? Text(AppLocalizations.of(context).translate('text52'))
                        : Text(
                            AppLocalizations.of(context).translate('text53')),
                onPressed: () async {
                  focusNode.requestFocus();
                  provider.editing = !provider.editing;
                  if (provider.editing) {
                    _phoneController.text = provider.phone;
                  } else {
                    PhoneVerification()
                        .getVerificationCodeFromServer(_phoneController.text);

                    if (_formKey.currentState.validate()) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => PinCodeDialog(
                                provider: provider,
                                phone: _phoneController.text,
                              ));
                    }
                  }
                },
              ),
            )
          ],
        );
      },
    );
  }
}
