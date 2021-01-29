import 'dart:async';

import 'package:MyDiscount/providers/phone_number.dart';
import 'package:MyDiscount/services/phone_verification.dart';
import 'package:MyDiscount/widgets/custom_app_bar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../core/localization/localizations.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({this.provider, this.phone});
  final PhoneNumber provider;
  final String phone;
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  TextEditingController _codeController = TextEditingController();
  StreamController<int> _controller = StreamController();
  FocusNode _focusNode = FocusNode();
  String _currentCode;
  Timer _timer;
  bool isActive = true;

  int _duration = 60;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      if (_duration != 0) {
        _duration--;
        _controller.add(_duration);
      } else {
        if (mounted) {
          _timer.cancel();

          setState(() {
            isActive = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      _timer.cancel();
      _focusNode.dispose();
      _controller.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = widget.provider;
    final phone = widget.phone;
    return CustomAppBar(
      title: AppLocalizations.of(context).translate('phoneverification'),
      child: Container(
        color: Colors.white,
        child: ChangeNotifierProvider.value(
          value: PhoneNumber(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(AppLocalizations.of(context).translate('entercode'),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text(
                phone,
                style: TextStyle(color: Colors.green),
              ),
              Container(
                width: size.width * .6,
                child: PinFieldAutoFill(
                  controller: _codeController,
                  focusNode: _focusNode,
                  autofocus: true,
                  codeLength: 4,
                  onCodeChanged: (code) {
                    _currentCode = code;
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<int>(
                      stream: _controller.stream,
                      builder: (context, snapshot) {
                        return OutlineButton(
                          onPressed: snapshot.data == 0
                              ? () {
                                  PhoneVerification()
                                      .getVerificationCodeFromServer(phone);
                                  setState(() {
                                    isActive = true;
                                    _duration = 60;
                                  });
                                  startTimer();
                                }
                              : null,
                          borderSide: BorderSide(color: Colors.green),
                          splashColor: Colors.green,
                          highlightColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * .3,
                            child: Text(
                              snapshot.hasData
                                  ? '${AppLocalizations.of(context).translate('send')}(${snapshot.data})'
                                  : '${AppLocalizations.of(context).translate('send')}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  OutlineButton(
                    borderSide: BorderSide(color: Colors.green),
                    splashColor: Colors.green,
                    highlightColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () async {
                      bool coresponde = false;
                      if (_currentCode != '') {
                        coresponde = await PhoneVerification()
                            .smsCodeVerification(
                                VerificationCode(_currentCode));
                      }
                      if (coresponde) {
                        provider.phone = phone;
                        Navigator.of(context).pop();
                      } else {
                        FlushbarHelper.createError(
                                message: AppLocalizations.of(context)
                                    .translate('incorectcode'))
                            .show(context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * .3,
                      child: Text(
                        AppLocalizations.of(context).translate('verify'),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
