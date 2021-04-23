import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_phone_input/international_phone_input.dart';

import '../../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../../core/localization/localizations.dart';
import '../../pages/phone_validation_page.dart';

class ProfileFieldWidget extends StatefulWidget {
  const ProfileFieldWidget({
    Key? key,
    required this.labelText,
    required this.isEdit,
  }) : super(key: key);

  final String? labelText;
  final bool isEdit;
  @override
  _ProfileFieldWidgetState createState() => _ProfileFieldWidgetState();
}

class _ProfileFieldWidgetState extends State<ProfileFieldWidget> {
  final _formKey = GlobalKey<FormState>();
  late bool requestCode;

  FocusNode focusNode = FocusNode();

  late bool sendCode;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ProfileFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEdit != oldWidget.isEdit) requestCode = true;
    if (confirmedNumber.isEmpty) requestCode = true;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    if (mounted) focusNode.unfocus();
  }

  String? phoneIsoCode;
  String? phoneNumber;
  String confirmedNumber = '';

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit;
    return BlocConsumer<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        final profile = state.profile!;
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
                isEdit
                    ? Expanded(
                        child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: InternationalPhoneInput(
                              hintText: 'xxxxxxxx',
                              decoration: const InputDecoration(
                                enabled: true,
                              ),
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
                              errorText: AppLocalizations.of(context)!
                                  .translate('inputerror'),
                              initialPhoneNumber:
                                  profile.phone.characters.skip(4).toString(),
                              initialSelection: phoneIsoCode,
                              enabledCountries: ['+373'],
                            ),
                          ),
                          const Divider(),
                          ElevatedButton(
                            onPressed: requestCode
                                ? () async {
                                    if (confirmedNumber.isNotEmpty) {
                                      setState(() {
                                        requestCode = false;
                                      });
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PhoneVerificationPage(
                                            phone: confirmedNumber,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            child: sendCode
                                ? Text(AppLocalizations.of(context)!
                                    .translate('sendcode')!)
                                : Text(AppLocalizations.of(context)!
                                    .translate('changephone')!),
                          ),
                        ],
                      ))
                    : Container(
                        height: 56,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(widget.labelText!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
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

            /* ) */
          ],
        );
      },
    );
  }
}
