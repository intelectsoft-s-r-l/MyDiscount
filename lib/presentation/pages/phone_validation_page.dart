import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_discount/aplication/auth/sign_in/sign_form_bloc.dart';
import 'package:my_discount/domain/repositories/is_service_repository.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../aplication/phone_validation_bloc/phone_validation_bloc.dart';
import '../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../../injectable.dart';
import '../widgets/custom_app_bar.dart';
import 'login_profile_data_page.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({
    required this.phone,
    required this.forAuth,
  });
  final bool forAuth;
  final String phone;
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  final StreamController<int> _controller = StreamController();
  final FocusNode _focusNode = FocusNode();
  late String _currentCode;
  late Timer _timer;
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

    final phone = widget.phone;
    return CustomAppBar(
      title: AppLocalizations.of(context).translate('phoneverification'),
      child: BlocProvider(
        create: (context) =>
            getIt<PhoneValidationBloc>()..add(GetValidationCode(phone)),
        child: Container(
          color: Colors.white,
          child: BlocConsumer<PhoneValidationBloc, PhoneValidationState>(
            listener: (context, state) async {
              if (state is ValidCode) {
                if (!widget.forAuth) {
                  context.read<ProfileFormBloc>().add(PhoneChanged(phone));
                  Navigator.of(context).pop(true);
                } else {
                  final id = phone.replaceFirst('+', '');
                  final profile = await getIt<IsService>()
                      .getClientInfo(id: id, registerMode: 4);
                  if (profile.isEmpty) {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginProfileData(phone: phone)),
                    );
                  } else {
                    context
                        .read<SignFormBloc>()
                        .add(PhoneChecked(phone, profile));
                  }
                }
              } else if (state is InvalidCode) {
                _focusNode.unfocus();
                await Flushbar(
                  message:
                      AppLocalizations.of(context).translate('incorectcode'),
                  duration: const Duration(seconds: 3),
                ).show(context);
                context.read<PhoneValidationBloc>();
              }
            },
            buildWhen: (p, c) => p.serverCode != c.serverCode,
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(AppLocalizations.of(context).translate('entercode'),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    phone,
                    style: const TextStyle(color: Colors.green),
                  ),
                  Container(
                    width: size.width * .6,
                    child: PinFieldAutoFill(
                      controller: _codeController,
                      keyboardType: Platform.isAndroid
                          ? TextInputType.text
                          : const TextInputType.numberWithOptions(),
                      autoFocus: true,
                      codeLength: 4,
                      onCodeChanged: (code) {
                        _currentCode = code as String;
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
                            return OutlinedButton(
                              onPressed: snapshot.data == 0
                                  ? () {
                                      /* if (_currentCode != '') { */
                                      context
                                          .read<PhoneValidationBloc>()
                                          .add(GetValidationCode(phone));
                                      /* } */
                                      setState(() {
                                        isActive = true;
                                        _duration = 60;
                                      });
                                      startTimer();
                                    }
                                  : null,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green),
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: size.width * .3,
                                child: Text(
                                  snapshot.hasData
                                      ? '${AppLocalizations.of(context).translate('send')}(${snapshot.data})'
                                      : '${AppLocalizations.of(context).translate('send')}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          if (_currentCode != '') {
                            context.read<PhoneValidationBloc>().add(
                                UserInputCode(_currentCode, state.serverCode));
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
