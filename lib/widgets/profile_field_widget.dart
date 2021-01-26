
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
    @required this.labelText, this.phoneVerification,
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
                            print(internationalizedPhoneNumber);
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
                          Container(
                            child: Text(widget.labelText,
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                          Consumer(
                              builder: (context, PhoneNumber provider1, _) {
                            if (provider1.phone != null) {
                              return Container(
                                child: Text(
                                  provider.phone,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return Container();
                          }),
                        ],
                      ),
              ],
            ),
            Divider(),
            Consumer(
              builder: (context, PhoneNumber provider, _) => OutlineButton(
                splashColor: Colors.green,
                borderSide: BorderSide(color: Colors.green),
                highlightColor: Colors.green,
                highlightedBorderColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: provider.editing
                    ? Text(AppLocalizations.of(context).translate('text60'))
                    : provider.phone != ''
                        ? Text(AppLocalizations.of(context).translate('text52'))
                        : Text(
                            AppLocalizations.of(context).translate('text53')),
                onPressed: () async {
                  provider.editing = !provider.editing;

                  if (provider.editing) {
                    
                  } else {
                    PhoneVerification()
                        .getVerificationCodeFromServer(confirmedNumber);
                    if (confirmedNumber != '')
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhoneVerificationPage(
                              provider: provider, phone: confirmedNumber)));
                  }
                },
              ),
            )
          ],
        );
      },
    );
  }
}
