import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../widgets/custom_app_bar.dart';

import '../../aplication/phone_validation_bloc/phone_validation_bloc.dart';
import '../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../core/localization/localizations.dart';
import '../../injectable.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({this.phone, this.phoneBloc});
  //final ProfileFormBloc bloc;
  final PhoneValidationBloc phoneBloc;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    //final bloc = widget.bloc;
    /* final phoneBloc = widget.phoneBloc; */
    final phone = widget.phone;
    return CustomAppBar(
      title: AppLocalizations.of(context).translate('phoneverification'),
      child: BlocProvider(
        create: (context) => getIt<PhoneValidationBloc>()..add(GetValidationCode(phone)),
        child: Container(
          color: Colors.white,
          child: BlocConsumer<PhoneValidationBloc, PhoneValidationState>(
            listener: (context, state) {
              if (state is ValidCode) {
                context.read<ProfileFormBloc>().add(PhoneChanged(phone));

                Navigator.pop(context);
              } else if (state is InvalidCode) {
                FlushbarHelper.createError(message: AppLocalizations.of(context).translate('incorectcode')).show(context);
                context.read<PhoneValidationBloc>();
              }
            },
            buildWhen: (p, c) => p.serverCode != c.serverCode,
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(AppLocalizations.of(context).translate('entercode'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                                      if (_currentCode != '') {
                                        context.read<PhoneValidationBloc>().add(GetValidationCode(phone));
                                      }
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
                                  snapshot.hasData ? '${AppLocalizations.of(context).translate('send')}(${snapshot.data})' : '${AppLocalizations.of(context).translate('send')}',
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
                          if (_currentCode != '') {
                            context.read<PhoneValidationBloc>().add(UserInputCode(_currentCode, state.serverCode));
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
              );
            },
          ),
        ),
      ),
    );
  }
}
