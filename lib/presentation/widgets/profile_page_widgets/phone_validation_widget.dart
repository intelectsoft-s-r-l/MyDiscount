import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_phone_input/international_phone_input.dart';

import '../../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../../infrastructure/core/localization/localizations.dart';
import '../../pages/phone_validation_page.dart';

class ValidatePhoneFormWidget extends StatefulWidget {
  const ValidatePhoneFormWidget({
    Key? key,
    required this.labelText,
    required this.editForm,
  }) : super(key: key);

  final String? labelText;
  final bool editForm;
  @override
  _ValidatePhoneFormWidgetState createState() =>
      _ValidatePhoneFormWidgetState();
}

class _ValidatePhoneFormWidgetState extends State<ValidatePhoneFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late bool requestCode;

  FocusNode focusNode = FocusNode();

  late bool sendCode;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ValidatePhoneFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editForm != oldWidget.editForm) requestCode = true;
    if (confirmedNumber.isEmpty) requestCode = true;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    if (mounted) focusNode.unfocus();
  }

  String? phoneIsoCode = '+373';
  String? phoneNumber;
  String confirmedNumber = '';

  @override
  Widget build(BuildContext context) {
    final editForm = widget.editForm;
    return BlocConsumer<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        final profile = state.profile;
        if (profile.phone.isEmpty) {
          sendCode = true;
        } else {
          sendCode = false;
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                editForm
                    ? Expanded(
                        child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: InternationalPhoneInput(
                              hintText: 'xxxxxxxx',
                              onPhoneNumberChange: (String number,
                                  String? internationalizedPhoneNumber,
                                  String? isoCode,
                                  _) {
                                debugPrint(internationalizedPhoneNumber);
                                confirmedNumber =
                                    internationalizedPhoneNumber as String;
                                setState(() {
                                  phoneIsoCode = isoCode;
                                });
                              },
                              errorText: AppLocalizations.of(context)
                                  .translate('inputerror'),
                              initialPhoneNumber:
                                  profile.phone.characters.skip(4).toString(),
                              initialSelection: phoneIsoCode,
                              enabledCountries: {
                                '+40': 'RO',
                                '+7': 'RU',
                                '+374': 'AM',
                                '+373': 'MD',
                              },
                            ),
                          ),
                          const Divider(),
                          ElevatedButton(
                            onPressed: requestCode
                                ? () {
                                    if (confirmedNumber.isNotEmpty) {
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PhoneVerificationPage(
                                            phone: confirmedNumber,
                                          ),
                                        ),
                                      )
                                          .then((value) {
                                        if (value != null) {
                                          setState(() {
                                            requestCode = !value;
                                          });
                                        }
                                      });
                                    }
                                  }
                                : null,
                            child: sendCode
                                ? Text(AppLocalizations.of(context)
                                    .translate('sendcode'))
                                : Text(AppLocalizations.of(context)
                                    .translate('changephone')),
                          ),
                        ],
                      ))
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                widget.labelText!,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 9),
                            Container(
                              child: Text(
                                profile.phone,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}
