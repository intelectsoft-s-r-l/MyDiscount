import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import '../../aplication/auth/sign_in/sign_form_bloc.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../widgets/custom_app_bar.dart';

class InputPhonePage extends StatefulWidget {
  const InputPhonePage({Key? key, required this.bloc, required this.size})
      : super(key: key);
  final SignFormBloc bloc;
  final Size size;
  @override
  _InputPhonePageState createState() => _InputPhonePageState();
}

class _InputPhonePageState extends State<InputPhonePage> {
  final _controller = TextEditingController();
  bool isValidPhone = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAppBar(
        title: '',
        child: SingleChildScrollView(
          child: Container(
            height: widget.size.height * .87,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: widget.size.height * .2),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: InternationalPhoneInput(
                    enabledCountries: {
                      '+40': 'RO',
                      '+7': 'RU',
                      '+374': 'AM',
                      '+373': 'MD',
                    },
                    initialSelection: '+373',
                    initialPhoneNumber: '',
                    onPhoneNumberChange: (String number,
                        String? internationalizedPhoneNumber,
                        String? isoCode,
                        String? dialCode) {
                      print('phone: $internationalizedPhoneNumber');
                      _controller.text = internationalizedPhoneNumber as String;
                    },
                    isValidPhoneNumber: (isValid) {
                      isValidPhone = isValid as bool;
                    },
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context).translate('inputerror'),
                      hintStyle: const TextStyle(fontSize: 13),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorMaxLines: 3,
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  indent: 20,
                  endIndent: 20,
                  thickness: 3,
                  color: Colors.grey[200],
                ),
                SizedBox(height: widget.size.height * .08),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    if (_controller.text.isNotEmpty & isValidPhone) {
                      widget.bloc.add(SignInWithPhone(_controller.text));
                    } else {
                      Flushbar(
                        message: AppLocalizations.of(context)
                            .translate('inputerror'),
                        duration: const Duration(seconds: 3),
                      ).show(context);
                      widget.bloc.add(SignOutEvent());
                    }
                  },
                  child: Container(
                    height: 40,
                    width: widget.size.width * .25,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('verify'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
