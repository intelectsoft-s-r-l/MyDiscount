import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_phone_input/international_phone_input.dart';

import '../../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../../core/localization/localizations.dart';
import '../../pages/phone_validation_page.dart';

class ProfileFieldWidget extends StatefulWidget {
  const ProfileFieldWidget({
    Key key,
    @required this.labelText,
    @required this.isEdit,
  }) : super(key: key);

  final String labelText;
  final bool isEdit;
  @override
  _ProfileFieldWidgetState createState() => _ProfileFieldWidgetState();
}

class _ProfileFieldWidgetState extends State<ProfileFieldWidget> {
  final _formKey = GlobalKey<FormState>();
  bool requestCode;

  FocusNode focusNode = FocusNode();

  bool isState;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ProfileFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEdit != oldWidget.isEdit) requestCode = true;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode?.dispose();
    if (mounted) focusNode?.unfocus();
  }

  String phoneIsoCode;
  String phoneNumber;
  String confirmedNumber = '';

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.isEdit;
    return BlocConsumer<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        final profile = state.profile;
        if (profile.phone == null) {
          isState = true;
        } else {
          isState = false;
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isEdit
                    ? Expanded(
                        //height: 40,
                        child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: InternationalPhoneInput(
                              hintText: 'xxxxxxxx',
                              decoration: InputDecoration(
                                enabled: true,
                              ),
                              onPhoneNumberChange: (
                                String number,
                                String internationalizedPhoneNumber,
                                String isoCode,
                              ) {
                                debugPrint(internationalizedPhoneNumber);
                                confirmedNumber = internationalizedPhoneNumber;
                                setState(() {
                                  phoneIsoCode = isoCode;
                                });
                              },
                              errorText: AppLocalizations.of(context)
                                  .translate('inputerror'),
                              //initialPhoneNumber: profile?.phone?.characters?.skip(4).toString() ?? "",
                              initialSelection: phoneIsoCode,
                              enabledCountries: [
                                '+373',
                              ],
                            ),
                          ),
                          const Divider(),
                          ElevatedButton(
                            child: isState
                                ? Text(AppLocalizations.of(context)
                                    .translate('sendcode'))
                                : Text(AppLocalizations.of(context)
                                    .translate('changephone')),
                            onPressed: requestCode
                                ? () async {
                                    if (confirmedNumber != '') {
                                      setState(() {
                                        requestCode = false;
                                      });
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PhoneVerificationPage(
                                            //bloc: bloc,
                                            phone: confirmedNumber,
                                          ),
                                        ),
                                      );
                                      /*  } */
                                    }
                                  }
                                : null,
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
                              child: Text(widget.labelText,
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            Container(
                              child: Text(
                                profile.phone ?? '',
                                style: TextStyle(
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
