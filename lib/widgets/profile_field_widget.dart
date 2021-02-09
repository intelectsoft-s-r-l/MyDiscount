import 'package:MyDiscount/injectable.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:international_phone_input/international_phone_input.dart';

import '../core/localization/localizations.dart';
import '../pages/phone_validation_page.dart';
import '../providers/phone_number.dart';
import '../services/phone_verification.dart';

class ProfileFieldWidget extends StatefulWidget {
  const ProfileFieldWidget({
    Key key,
    @required this.labelText,
    this.phoneVerification,
  }) : super(key: key);

  final String labelText;
  final PhoneVerification phoneVerification;
  @override
  _ProfileFieldWidgetState createState() => _ProfileFieldWidgetState();
}

class _ProfileFieldWidgetState extends State<ProfileFieldWidget> {
  final _formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();

  bool isEdit = false;

  bool isStartTimer = false;

  @override
  void dispose() {
    super.dispose();
    focusNode?.dispose();
    if (mounted) focusNode?.unfocus();
  }

  String phoneNumber;
  String confirmedNumber = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhoneNumber>(
      create: (context) => PhoneNumber(),
      builder: (context, _) {
        final provider = Provider.of<PhoneNumber>(context, listen: true);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                provider.editing
                    ? Expanded(
                        child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: InternationalPhoneInput(
                          hintText: 'xxxxxxxx',
                          onPhoneNumberChange: (
                            String number,
                            String internationalizedPhoneNumber,
                            String isoCode,
                          ) {
                            debugPrint(internationalizedPhoneNumber);
                            confirmedNumber = internationalizedPhoneNumber;
                          },
                          errorText:
                              AppLocalizations.of(context).translate('text43'),
                          /* initialPhoneNumber:
                              provider.phone.characters.skip(4).toString(),
                          initialSelection: provider.phoneIsoCode, */
                          enabledCountries: [
                            '+373',
                          ],
                        ),
                      ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.labelText,
                              style: const TextStyle(
                                color: Colors.black,
                              )),
                          Consumer(
                              builder: (context, PhoneNumber provider1, _) {
                            if (provider1.phone != null) {
                              return Text(
                                provider.phone,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return Container();
                          }),
                        ],
                      ),
              ],
            ),
            const Divider(),
            Consumer(
              builder: (context, PhoneNumber provider, _) => OutlineButton(
                splashColor: Colors.green,
                borderSide: const BorderSide(color: Colors.green),
                highlightColor: Colors.green,
                highlightedBorderColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () async {
                  provider.editing = !provider.editing;

                  if (provider.editing) {
                  } else {
                    getIt<PhoneVerification>()
                        .getVerificationCodeFromServer(confirmedNumber);
                    if (confirmedNumber != '') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhoneVerificationPage(
                              provider: provider, phone: confirmedNumber)));
                    }
                  }
                },
                child: provider.editing
                    ? Text(AppLocalizations.of(context).translate('text60'))
                    : provider.phone != ''
                        ? Text(AppLocalizations.of(context).translate('text52'))
                        : Text(
                            AppLocalizations.of(context).translate('text53')),
              ),
            )
          ],
        );
      },
    );
  }
}
