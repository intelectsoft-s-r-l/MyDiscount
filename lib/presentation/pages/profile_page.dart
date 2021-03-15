import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/profile_page_widgets/profile_field_widget.dart';
import '../widgets/profile_page_widgets/profile_item_widget.dart';

import '../../aplication/auth/auth_bloc.dart';
import '../../aplication/auth/sign_in/sign_form_bloc.dart';
import '../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../core/localization/localizations.dart';
import '../../domain/entities/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isReadOnly = true;
  FocusNode _node = FocusNode();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String pageName = ModalRoute.of(context).settings.arguments;

    return BlocConsumer<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        final Profile profile = state.profile;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              pageName,
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.green,
            elevation: 0,
            actions: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 3000),
                child: IconButton(
                  icon: Icon(isReadOnly ? Icons.edit : Icons.save),
                  onPressed: () {
                    setState(() {
                      isReadOnly = !isReadOnly;
                    });
                    if (isReadOnly) {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _formKey.currentState.context.read<ProfileFormBloc>().add(SaveProfileData(profile));
                      }
                    } else {
                      _node.requestFocus();
                    }
                  },
                ),
              )
            ],
          ),
          body: Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Container(
                        child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .858,
                              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      NewWidget(profile: profile, isEdit: !isReadOnly),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                child: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(context).translate('firstname'),
                                                        style: const TextStyle(color: Colors.black),
                                                      ),
                                                      Container(
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.name,
                                                          initialValue: profile.firstName,
                                                          focusNode: _node,
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                          ),
                                                          onChanged: (val) {
                                                            context.read<ProfileFormBloc>().add(FirstNameChanged(val));
                                                          },
                                                          readOnly: isReadOnly,
                                                          style: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Divider(),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(context).translate('lastname'),
                                                      style: const TextStyle(color: Colors.black),
                                                    ),
                                                    Container(
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.name,
                                                        initialValue: profile.lastName,
                                                        decoration: InputDecoration(border: InputBorder.none),
                                                        onChanged: (val) {
                                                          context.read<ProfileFormBloc>().add(LastNameChanged(val));
                                                        },
                                                        readOnly: isReadOnly,
                                                        style: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Email',
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                        Container(
                                          child: TextFormField(
                                            keyboardType: TextInputType.emailAddress,
                                            initialValue: profile.email,
                                            decoration: InputDecoration(border: InputBorder.none, focusColor: Colors.red),
                                            onChanged: (val) {
                                              context.read<ProfileFormBloc>().add(EmailChanged(val));
                                            },
                                            readOnly: isReadOnly,
                                            style: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  ProfileFieldWidget(
                                    labelText: AppLocalizations.of(context).translate('phone'),
                                    isEdit: !isReadOnly,
                                  ),
                                  Divider(),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<SignFormBloc>().add(SignOutEvent());
                                          context.read<AuthBloc>().add(SignOut());
                                        },
                                        style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.green),
                                         primary: Colors.green,
                                        /*highlightColor: Colors.green,
                                        highlightedBorderColor: Colors.red, */
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                        child: Text(AppLocalizations.of(context).translate('logout')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
}
