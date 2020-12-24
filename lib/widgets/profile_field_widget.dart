import 'dart:io';

import 'package:MyDiscount/models/profile_model.dart';
import 'package:MyDiscount/models/user_credentials.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ProfileFieldWidget extends StatefulWidget {
  const ProfileFieldWidget({
    Key key,
    @required this.info,
    @required this.labelText,
  }) : super(key: key);
  final String labelText;
  final String info;

  @override
  _ProfileFieldWidgetState createState() => _ProfileFieldWidgetState();
}

class _ProfileFieldWidgetState extends State<ProfileFieldWidget> {
  bool isEdit = false;
  bool isVerifing = false;
  String _currentCode = '0000';
  TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserCredentials().getUserPhone(),
      builder: (context, snapshot) => snapshot.hasData
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isEdit
                    ? Expanded(
                        child: !isVerifing
                            ? TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number *',
                                  hintText: 'Where can we reach you?',
                                  /* prefixIcon:
                        Icon(Icons.call), */
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) => value.length == 9
                                    ? null
                                    : 'Phone number lenght must pe 9 characters ',
                                onSaved: (value) {
                                  setState(() {
                                    _phoneController.text = value;
                                  });
                                })
                            : PinFieldAutoFill(
                                //currentCode: _currentCode,
                                codeLength: 4,
                                onCodeChanged: (code) {
                                  _currentCode = code;
                                },
                                 onCodeSubmitted: (code) {
                                  print(code);
                                },
                              ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              widget.labelText,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                              child: Text(
                            snapshot.data,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          )),
                        ],
                      ) /* ProfileItemWidget(labelText: widget.labelText, text: widget.info) */,
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      Profile profile =
                          await UserCredentials().getUserProfileData();
                      if (Platform.isAndroid) {
                        await SmsAutoFill().listenForCode;
                        print(SmsAutoFill().getAppSignature);
                      }
                      setState(() {
                        UserCredentials().saveFormProfileInfo(
                            Profile(phone: _phoneController.text));
                        isEdit = !isEdit;
                        if (isEdit) {
                          _phoneController.text = profile.phone;
                          if (profile.phone != '') isVerifing = !isVerifing;
                        }
                      });
                    })
              ],
            )
          : Container(),
    );
  }
}
/* <#> MyDiscount: Your code is 1234
DJWuSAfFX53 */
