import 'package:MyDiscount/localization/localizations.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../models/phone_number.dart';
import '../services/phone_verification.dart';

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
  TextEditingController _codeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();
  FocusNode _focusNode = FocusNode();

  bool isEdit = false;
  //bool isVerifing = false;
  String _currentCode;

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    showPinCodDialog(PhoneNumber provider) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(10),
              height: 120,
              child: Column(
                children: [
                  PinFieldAutoFill(
                    controller: _codeController,
                    focusNode: _focusNode,
                    // autofocus: true,
                    codeLength: 4,
                    onCodeChanged: (code) {
                      _currentCode = code;

                      print(code);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          provider.phone = _phoneController.text;
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          bool coresponde = false;
                          if (_currentCode != '') {
                            coresponde = await PhoneVerification()
                                .smsCodeVerification(
                                    VerificationCode(_currentCode));
                          }
                          if (coresponde) {
                            provider.phone = _phoneController.text;
                            Navigator.pop(context);
                            FlushbarHelper.createSuccess(
                                    message: AppLocalizations.of(context)
                                        .translate('text45'))
                                .show(context);
                            _focusNode.unfocus();
                          } else {
                            provider.phone = '';
                            Navigator.pop(context);
                            FlushbarHelper.createError(
                                    message: AppLocalizations.of(context)
                                        .translate('text46'))
                                .show(context);
                          }
                        },
                        child: Text(
                            AppLocalizations.of(context).translate('text47')),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Consumer(
      builder: (context, PhoneNumber provider, _) => Row(
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
                        //labelText: 'Phone Number *',
                        hintText:
                            AppLocalizations.of(context).translate('text42'),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('text43');
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
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                focusNode.requestFocus();
                provider.editing = !provider.editing;
                if (provider.editing) {
                  _phoneController.text = provider.phone;
                } else {
                  PhoneVerification()
                      .getVerificationCodeFromServer(_phoneController.text);

                  focusNode.requestFocus();
                  focusNode.unfocus();
                  if (_formKey.currentState.validate()) {
                    showPinCodDialog(provider);
                  }
                  _focusNode.unfocus();
                  if (_focusNode.canRequestFocus) _focusNode.requestFocus();
                }
              })
        ],
      ),
    );
  }
}
/* <#> MyDiscount: Your code is 1234
DJWuSAfFX53 */
