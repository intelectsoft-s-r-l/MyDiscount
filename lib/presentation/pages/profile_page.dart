import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_discount/domain/entities/profile_model.dart';

import '../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '/presentation/widgets/profile_page_widgets/profile_form_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isReadOnly = true;
  final FocusNode _node = FocusNode();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageName = ModalRoute.of(context)!.settings.arguments as String;

    return BlocConsumer<ProfileFormBloc, ProfileFormState>(
      listenWhen: (p, c) => p.props.first != c.props.first,
      listener: (context, state) {
        if (state is ProfileFormError) {
          _node.unfocus();
          Flushbar(
            duration: const Duration(seconds: 3),
            message: 'Service Error',
          ).show(context);
          context
              .read<ProfileFormBloc>()
              .add(FirstNameChanged(state.profile.firstName));
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: goBack,
              icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
            ),
            centerTitle: true,
            title: Text(
              pageName,
              style: const TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.green,
            elevation: 0,
            actions: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 3000),
                child: IconButton(
                  icon: Tooltip(
                      message: AppLocalizations.of(context)
                          .translate(isReadOnly ? 'edit' : 'save'),
                      child: Icon(isReadOnly ? Icons.edit : Icons.save)),
                  onPressed: () => editOrSave(profile),
                ),
              )
            ],
          ),
          body: Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Container(
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowGlow();
                            return true;
                          },
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .868,
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: ProfilePageForm(
                                  context: context,
                                  formKey: _formKey,
                                  profile: profile,
                                  isReadOnly: isReadOnly,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void editOrSave(Profile profile) {
    setState(() {
      isReadOnly = !isReadOnly;
    });
    if (isReadOnly) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        _formKey.currentState!.context
            .read<ProfileFormBloc>()
            .add(SaveProfileData(profile));
      }
    } else {
      _node.requestFocus();
    }
  }

  void goBack() {
    if (isReadOnly) {
      Navigator.pop(context);
    } else {
      Flushbar(
        duration: const Duration(seconds: 3),
        message: AppLocalizations.of(context).translate('savebeforegoout'),
      ).show(context);
    }
  }
}
