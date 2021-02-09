import 'dart:async';

import 'package:MyDiscount/injectable.dart';
import 'package:MyDiscount/providers/phone_number.dart';
import 'package:MyDiscount/services/phone_verification.dart';
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
  final TextEditingController _codeController = TextEditingController();
  final StreamController<int> _controller = StreamController();
  final FocusNode _focusNode = FocusNode();
  String _currentCode;
  Timer _timer;
  bool isActive = true;

  int _duration = 60;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

 void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_timer) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: ChangeNotifierProvider.value(
        value: PhoneNumber(),
        child: Container(
          color: Colors.green,
          child: Padding(
            padding:const EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius:const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                padding:const EdgeInsets.only(left: 5, right: 5),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   const SizedBox(
                      height: 30,
                    ),
                    Text(AppLocalizations.of(context).translate('text44'),
                        style:const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                   const SizedBox(
                      height: 5,
                    ),
                    Text(
                      phone,
                      style:const TextStyle(color: Colors.green),
                    ),
                    SizedBox(
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
                   const SizedBox(
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
                                        getIt<PhoneVerification>()
                                            .getVerificationCodeFromServer(
                                                phone);
                                        setState(() {
                                          isActive = true;
                                          _duration = 60;
                                        });
                                        startTimer();
                                      }
                                    : null,
                                borderSide:const BorderSide(color: Colors.green),
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
                                        ? '${AppLocalizations.of(context).translate('text54')}(${snapshot.data})'
                                        : AppLocalizations.of(context).translate('text54'),
                                    style:
                                       const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }),
                      const  SizedBox(
                          width: 10,
                        ),
                        OutlineButton(
                          borderSide:const BorderSide(color: Colors.green),
                          splashColor: Colors.green,
                          highlightColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () async {
                            bool coresponde = false;
                            if (_currentCode != '') {
                              coresponde = await getIt<PhoneVerification>()
                                  .smsCodeVerification(
                                      VerificationCode(_currentCode));
                            }
                            if (coresponde) {
                              provider.phone = phone;
                              Navigator.of(context).pop();
                            } else {
                              FlushbarHelper.createError(
                                      message: AppLocalizations.of(context)
                                          .translate('text46'))
                                  .show(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * .3,
                            child: Text(
                              AppLocalizations.of(context).translate('text47'),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      /*     ), */
    );
  }
}
