import 'dart:async';

import 'package:MyDiscount/domain/repositories/is_service_repository.dart';
import 'package:MyDiscount/infrastructure/local_repository_impl.dart';
import 'package:MyDiscount/injectable.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../core/localization/localizations.dart';
import '../providers/phone_number.dart';

class PinCodeDialog extends StatefulWidget {
  const PinCodeDialog({
    this.provider,
    this.phone,
  });
  final PhoneNumber provider;
  final String phone;
  //final PhoneVerification phoneVerification;
  @override
  _PinCodeDialogState createState() => _PinCodeDialogState();
}

class _PinCodeDialogState extends State<PinCodeDialog> {
  final TextEditingController _codeController = TextEditingController();
  final StreamController _controller = StreamController();
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
    final provider = widget.provider;
    final phone = widget.phone;

    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 1),
      title: Text(AppLocalizations.of(context).translate('text58'), style: const TextStyle(fontSize: 15)),
      content: SizedBox(
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
                        ? Text('${AppLocalizations.of(context).translate('text55')} ${snapshot.data} ${AppLocalizations.of(context).translate('text59')}',
                            style: const TextStyle(fontSize: 15))
                        : InkResponse(
                            onTap: () {
                              getIt<IsService>().validatePhone(phone: phone);
                              setState(() {
                                isActive = true;
                                _duration = 30;
                              });
                              startTimer();
                            },
                            child: Text(AppLocalizations.of(context).translate('text54'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))
                    : Text('${AppLocalizations.of(context).translate('text55')} 30 ${AppLocalizations.of(context).translate('text59')}', style: const TextStyle(fontSize: 15))),
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
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(
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
              coresponde = await getIt<LocalRepositoryImpl>().smsCodeVerification(VerificationCode(_currentCode));
            }
            if (coresponde) {
              provider.phone = phone;
              Navigator.pop(context);
              FlushbarHelper.createSuccess(message: AppLocalizations.of(context).translate('text45')).show(context);
              _focusNode.unfocus();
            } else {
              getIt<IsService>().validatePhone(phone: phone);

              FlushbarHelper.createError(message: AppLocalizations.of(context).translate('text46')).show(context);
            }
          },
          child: Text(
            AppLocalizations.of(context).translate('text47'),
            style: const TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}
