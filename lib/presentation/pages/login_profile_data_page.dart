import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../aplication/auth/sign_in/sign_form_bloc.dart';
import '../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../infrastructure/core/constants/credentials.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile_page_widgets/profile_image_picker_widget.dart';
import '../widgets/profile_page_widgets/profile_text_field_widget.dart';

class LoginProfileData extends StatefulWidget {
  LoginProfileData({Key? key, required this.phone}) : super(key: key);
  final String phone;

  @override
  _LoginProfileDataState createState() => _LoginProfileDataState();
}

class _LoginProfileDataState extends State<LoginProfileData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final bool isReadOnly = false;
  @override
  void initState() {
    context.read<ProfileFormBloc>().add(const RestoreProfileData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        final profile = state.profile;
        return CustomAppBar(
          title: AppLocalizations.of(context).translate('completeprofile'),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ProfileImagePicker(
                              profile: profile,
                              isEdit: !isReadOnly,
                              forAuth: true,
                              updateImage: (updated) {
                                if (updated) {
                                  context
                                      .read<ProfileFormBloc>()
                                      .add(const UpdateProfileData());
                                }
                              }),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ProfileFormWidget(
                                    title: AppLocalizations.of(context)
                                        .translate('firstname'),
                                    initialValue: '',
                                    isReadOnly: isReadOnly,
                                    keyboardType: TextInputType.name,
                                    onChanged: (val) => context
                                        .read<ProfileFormBloc>()
                                        .add(FirstNameChanged(val)),
                                    validator: (value) {
                                      if (value != null) {
                                        if (value.isEmpty) {
                                          return AppLocalizations.of(context)
                                              .translate('nameerror');
                                        }
                                      }
                                    }),
                                const Divider(),
                                ProfileFormWidget(
                                  title: AppLocalizations.of(context)
                                      .translate('lastname'),
                                  initialValue: '',
                                  isReadOnly: isReadOnly,
                                  keyboardType: TextInputType.name,
                                  onChanged: (val) => context
                                      .read<ProfileFormBloc>()
                                      .add(LastNameChanged(val)),
                                  validator: (value) {
                                    if (value != null) {
                                      if (value.isEmpty) {
                                        return AppLocalizations.of(context)
                                            .translate('nameerror');
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      ProfileFormWidget(
                        title: 'Email',
                        initialValue: '',
                        keyboardType: TextInputType.emailAddress,
                        isReadOnly: isReadOnly,
                        onChanged: (val) => context
                            .read<ProfileFormBloc>()
                            .add(EmailChanged(val)),
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Email can\'t be empty';
                            }
                            if (!value.contains(Credentials.emailregexp)) {
                              return AppLocalizations.of(context)
                                  .translate('emailerror');
                            }
                          }
                        },
                      ),
                      const Divider(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<ProfileFormBloc>()
                                    .add(SaveProfileData(profile));
                                context
                                    .read<SignFormBloc>()
                                    .add(PhoneChecked(widget.phone, profile));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 60,
                              child: Text(
                                AppLocalizations.of(context).translate('save'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
