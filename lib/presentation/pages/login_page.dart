import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../aplication/auth/auth_bloc.dart';
import '../../aplication/auth/sign_in/sign_form_bloc.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../widgets/login_button_widget.dart';
import 'input_phone_page.dart';
import 'phone_validation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //String phone = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<SignFormBloc, SignFormState>(
          listenWhen: (p, c) => p.props != c.props,
          listener: (context, state) {
            if (state is SignFormDone) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/first', (_) => false);
              context.read<AuthBloc>().add(AuthCheckRequested());
            }
            if (state is SignInFormPhone) {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => PhoneVerificationPage(
                    phone: state.phone,
                    forAuth: true,
                  ),
                ),
              )
                  .then((value) {
                if (value == null) {
                  context.read<SignFormBloc>().add(ResetState());
                }
              });
            }
            if (state is SignInNetError) {
              Flushbar(
                message: AppLocalizations.of(context).translate('nothaveinet'),
                duration: const Duration(seconds: 3),
                //backgroundColor: Colors.red,
              ).show(context);
              context.read<SignFormBloc>().add(SignOutEvent());
            }
            if (state is SignInError) {
              Flushbar(
                message: 'Error',
                duration: const Duration(seconds: 3),
                // backgroundColor: Colors.red,
              ).show(context);
              context.read<SignFormBloc>().add(SignOutEvent());
            }
          },
          builder: (context, state) => Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                      height: size.height * .45,
                      width: size.width,
                      child: Image.asset(
                        'assets/icons/background.png',
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                    left: 0.0,
                    top: size.height * .052,
                    child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: Text(
                          AppLocalizations.of(context).translate('welcome'),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textScaleFactor: 1.5,
                          maxLines: 2,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .5,
                child: Column(
                  children: [
                    SizedBox(height: size.height * .038),
                    Container(
                      height: 35,
                      width: size.width * .82,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('loginwith'),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        // textScaleFactor: 1.2,
                      ),
                    ),
                    SizedBox(height: size.height * .08),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InputPhonePage(
                                bloc: context.read(), size: size),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: size.width * .8,
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('phonenumber'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textScaleFactor: 1.1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * .01),
                    LoginButton(
                      size: size,
                      event: SignInWithGoogle(),
                      picture: 'assets/icons/google_icon.svg',
                      text: AppLocalizations.of(context).translate('google'),
                      color: const Color(0xFF406BFB),
                    ),
                    SizedBox(height: size.height * .01),
                    LoginButton(
                      size: size,
                      event: SignInWithFacebook(),
                      picture: 'assets/icons/facebook_icon.svg',
                      text: AppLocalizations.of(context).translate('facebook'),
                      color: const Color(0xFF2D4CB3),
                    ),
                    SizedBox(height: size.height * .01),
                    Platform.isIOS
                        ? LoginButton(
                            size: size,
                            event: SignInWithApple(),
                            picture: 'assets/icons/apple_icon.svg',
                            text:
                                AppLocalizations.of(context).translate('apple'),
                            color: Colors.black,
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
