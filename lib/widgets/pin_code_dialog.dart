import 'dart:async';

import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../core/localization/localizations.dart';
import '../providers/phone_number.dart';
import '../services/phone_verification.dart';

class PinCodeDialog extends StatefulWidget {
  const PinCodeDialog({this.provider, this.phone});
  final PhoneNumber provider;
  final String phone;
  @override
  _PinCodeDialogState createState() => _PinCodeDialogState();
}

class _PinCodeDialogState extends State<PinCodeDialog> {
  TextEditingController _codeController = TextEditingController();
  StreamController _controller = StreamController();
  FocusNode _focusNode = FocusNode();
  String _currentCode;
  Timer _timer;
  bool isActive = true;

  int _duration = 30;
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
        // print(_duration);
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
    final provider = widget.provider;
    final phone = widget.phone;

    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 1),
      title: Text(AppLocalizations.of(context).translate('text58'),
          style: TextStyle(fontSize: 15)),
      content: Container(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            PinFieldAutoFill(
              controller: _codeController,
              focusNode: _focusNode,
              autofocus: true,
              codeLength: 4,
              onCodeChanged: (code) {
                _currentCode = code;
              },
            ),
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) => snapshot.hasData
                    ? isActive
                        ? Text(
                            '${AppLocalizations.of(context).translate('text55')} ${snapshot.data} ${AppLocalizations.of(context).translate('text59')}',
                            style: TextStyle(fontSize: 15))
                        : InkResponse(
                            onTap: () {
                              PhoneVerification()
                                  .getVerificationCodeFromServer(phone);
                              setState(() {
                                isActive = true;
                                _duration = 30;
                              });
                              startTimer();
                            },
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate('text54'),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)))
                    : Text(
                        '${AppLocalizations.of(context).translate('text55')} 30 ${AppLocalizations.of(context).translate('text59')}',
                        style: TextStyle(fontSize: 15))),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            provider.phone = '';
            Navigator.pop(context);
          },
          splashColor: Colors.green,
          highlightColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            AppLocalizations.of(context).translate('text56'),
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        MaterialButton(
          splashColor: Colors.green,
          highlightColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () async {
            bool coresponde = false;
            if (_currentCode != '') {
              coresponde = await PhoneVerification()
                  .smsCodeVerification(VerificationCode(_currentCode));
            }
            if (coresponde) {
              provider.phone = phone;
              Navigator.pop(context);
              FlushbarHelper.createSuccess(
                      message: AppLocalizations.of(context).translate('text45'))
                  .show(context);
              _focusNode.unfocus();
            } else {
              PhoneVerification().getVerificationCodeFromServer(phone);
              // provider.phone = '';
              // Navigator.pop(context);

              FlushbarHelper.createError(
                      message: AppLocalizations.of(context).translate('text46'))
                  .show(context);
            }
          },
          child: Text(
            AppLocalizations.of(context).translate('text47'),
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}
