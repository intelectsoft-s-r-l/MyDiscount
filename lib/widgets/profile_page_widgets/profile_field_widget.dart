import 'package:MyDiscount/aplication/profile_bloc/profile_form_bloc.dart';
import 'package:MyDiscount/pages/phone_validation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:international_phone_input/international_phone_input.dart';

import '../../aplication/phone_validation_bloc/phone_validation_bloc.dart';
import '../../core/localization/localizations.dart';

class ProfileFieldWidget extends StatefulWidget {
  const ProfileFieldWidget({
    Key key,
    @required this.labelText,
    //this.phoneVerification,
  }) : super(key: key);

  final String labelText;
  //final PhoneVerification phoneVerification;
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

  String phoneIsoCode;
  String phoneNumber;
  String confirmedNumber = '';

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ProfileFormBloc, ProfileFormState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final profile = state.profile;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isEdit
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
                              setState(() {
                                phoneIsoCode = isoCode;
                              });
                            },
                            errorText: AppLocalizations.of(context).translate('inputerror'),
                            /* initialPhoneNumber:
                              provider.phone.characters.skip(4).toString(),*/
                            initialSelection: phoneIsoCode,
                            enabledCountries: [
                              '+373',
                            ],
                          ),
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
                              /* Consumer(builder: (context, PhoneNumber provider1, _) {
                              if (provider1.phone != null) {
                                return  */
                              Container(
                                child: Text(
                                  profile.phone ?? '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                              /*   }
                              return Container();
                            }), */
                            ],
                          ),
                        ),
                ],
              ),
              const Divider(),
              /*  Consumer(
              builder: (context, PhoneNumber provider, _) => */
              OutlineButton(
                splashColor: Colors.green,
                borderSide: const BorderSide(color: Colors.green),
                highlightColor: Colors.green,
                highlightedBorderColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isEdit
                    ? Text(AppLocalizations.of(context).translate('sendcode'))
                    : profile.phone != ''
                        ? Text(AppLocalizations.of(context).translate('changephone'))
                        : Text(AppLocalizations.of(context).translate('addphone')),
                onPressed: () async {
                  /* provider.editing = !provider.editing; */
                  setState(() {
                    isEdit = !isEdit;
                  });
                  if (isEdit) {
                  } else {
                    context.read<PhoneValidationBloc>().add(GetValidationCode(confirmedNumber));
                    if (confirmedNumber != '') {
                      // ignore: close_sinks
                      final bloc = context.read<ProfileFormBloc>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PhoneVerificationPage(
                            bloc: bloc,
                            phone: confirmedNumber,
                            phoneBloc: context.read<PhoneValidationBloc>(),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              /* ) */
            ],
          );
        },
     
    );
  }
}
