import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:my_discount/aplication/auth/auth_bloc.dart';
import 'package:my_discount/aplication/auth/sign_in/sign_form_bloc.dart';
import 'package:my_discount/aplication/profile_bloc/profile_form_bloc.dart';
import 'package:my_discount/domain/entities/profile_model.dart';
import 'package:my_discount/infrastructure/core/localization/localizations.dart';
import 'package:provider/provider.dart';

import 'phone_validation_widget.dart';
import 'profile_image_picker_widget.dart';
import 'profile_text_field_widget.dart';

class ProfilePageForm extends StatelessWidget {
  const ProfilePageForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.context,
    required this.profile,
    required this.isReadOnly,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final Profile profile;
  final bool isReadOnly;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileImagePicker(profile: profile, isEdit: !isReadOnly),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileFormWidget(
                      title:
                          AppLocalizations.of(context).translate('firstname'),
                      initialValue: profile.firstName,
                      isReadOnly: isReadOnly,
                      keyboardType: TextInputType.name,
                      onChanged: (val) => context
                          .read<ProfileFormBloc>()
                          .add(FirstNameChanged(val)),
                    ),
                    const Divider(),
                    ProfileFormWidget(
                      title: AppLocalizations.of(context).translate('lastname'),
                      initialValue: profile.lastName,
                      isReadOnly: isReadOnly,
                      keyboardType: TextInputType.name,
                      onChanged: (val) => context
                          .read<ProfileFormBloc>()
                          .add(LastNameChanged(val)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          ProfileFormWidget(
            title: 'Email',
            initialValue: profile.email,
            keyboardType: TextInputType.emailAddress,
            isReadOnly: isReadOnly,
            onChanged: (val) =>
                context.read<ProfileFormBloc>().add(EmailChanged(val)),
          ),
          const Divider(),
          ValidatePhoneFormWidget(
            labelText: AppLocalizations.of(context).translate('phone'),
            isEdit: !isReadOnly,
          ),
          const Divider(),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _logout,
                child: Text(AppLocalizations.of(context).translate('logout')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _logout() {
    if (isReadOnly) {
      Navigator.pop(context);
      context.read<SignFormBloc>().add(SignOutEvent());
      context.read<AuthBloc>().add(SignOut());
    } else {
      Flushbar(
        duration: const Duration(seconds: 3),
        message: AppLocalizations.of(context).translate('savebeforelogout'),
      ).show(context);
    }
  }
}
