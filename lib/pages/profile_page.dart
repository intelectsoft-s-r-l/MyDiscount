import 'package:MyDiscount/aplication/auth/auth_bloc.dart';
import 'package:MyDiscount/aplication/auth/sign_in/sign_form_bloc.dart';
import 'package:MyDiscount/aplication/phone_validation_bloc/phone_validation_bloc.dart';
import 'package:MyDiscount/aplication/profile_bloc/profile_form_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/localization/localizations.dart';
import '../domain/entities/profile_model.dart';
import '../injectable.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile_page_widgets/profile_field_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isReadOnly = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final String pageName = ModalRoute.of(context).settings.arguments;

    return CustomAppBar(
      title: pageName,
      child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              BlocConsumer<ProfileFormBloc, ProfileFormState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final Profile profile = state.profile;
                  return Container(
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
                                    NewWidget(profile: profile),
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
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context).translate('firstname'),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                  InkResponse(
                                                    onTap: () {
                                                      setState(() {
                                                        isReadOnly = !isReadOnly;
                                                      });
                                                    },
                                                    child: Container(
                                                      child: TextFormField(
                                                        initialValue: state.profile.firstName,
                                                        decoration: InputDecoration(border: InputBorder.none),
                                                        onFieldSubmitted: (val) {
                                                          context.read<ProfileFormBloc>().add(FirstNameChanged(val, true));
                                                        },
                                                        readOnly: isReadOnly,
                                                        style: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                                                  InkResponse(
                                                    onTap: () {
                                                      setState(() {
                                                        isReadOnly = !isReadOnly;
                                                      });
                                                    },
                                                    child: Container(
                                                      child: TextFormField(
                                                        initialValue: state.profile.lastName,
                                                        decoration: InputDecoration(border: InputBorder.none),
                                                        onFieldSubmitted: (val) {
                                                          context.read<ProfileFormBloc>().add(LastNameChanged(val, true));
                                                        },
                                                        readOnly: isReadOnly,
                                                        style: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            /* ProfileItemWidget(labelText: AppLocalizations.of(context).translate('firsname'), text: profile.firstName),
                                          /* SizedBox(
                                            width: size.width - 180,
                                            child: */ Divider(),
                                          /* ), */
                                          ProfileItemWidget(labelText: AppLocalizations.of(context).translate('lastname'), text: profile.lastName), */
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
                                      InkResponse(
                                        onTap: () {
                                          setState(() {
                                            isReadOnly = !isReadOnly;
                                          });
                                        },
                                        child: Container(
                                          child: TextFormField(
                                            initialValue: state.profile.email,
                                            decoration: InputDecoration(border: InputBorder.none),
                                            onFieldSubmitted: (val) {
                                              context.read<ProfileFormBloc>().add(EmailChanged(val, true));
                                            },
                                            readOnly: isReadOnly,
                                            style: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*
                              Divider(),
                              ProfileItemWidget(labelText: 'E-mail', text: profile.email ?? ''),*/
                                Divider(),
                                ProfileFieldWidget(
                                  labelText: AppLocalizations.of(context).translate('phone'),
                                ),
                                Divider(),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlineButton(
                                      onPressed: () {
                                        Provider.of<SignFormBloc>(context, listen: false).add(SignOutEvent());
                                        Provider.of<AuthBloc>(context, listen: false).add(SignOut());
                                      },
                                      splashColor: Colors.green,
                                      borderSide: BorderSide(color: Colors.green),
                                      highlightColor: Colors.green,
                                      highlightedBorderColor: Colors.red,
                                      child: Text(AppLocalizations.of(context).translate('logout')),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  NewWidget({
    Key key,
    @required this.profile,
  }) : super(key: key);
  final _picker = ImagePicker();
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(80),
        child: InkResponse(
          child: profile.photo.isNotEmpty
              ? Image.memory(
                  profile.photo,
                  fit: BoxFit.fill,
                  scale: 0.7,
                  width: 110,
                  height: 110,
                )
              : Image.asset(
                  'assets/icons/profile.png',
                  width: 110,
                  height: 110,
                ),
          onTap: () async {
            final file = await _picker.getImage(source: ImageSource.gallery);
            final bytes = await file.readAsBytes();
            context.read<ProfileFormBloc>().add(ImageChanged(bytes, true));
          },
        ),
      ),
    );
  }
}
