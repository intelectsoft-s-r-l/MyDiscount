import 'package:MyDiscount/aplication/auth/auth_bloc.dart';
import 'package:MyDiscount/aplication/auth/sign_in/sign_form_bloc.dart';
import 'package:MyDiscount/infrastructure/local_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/localization/localizations.dart';
import '../domain/entities/profile_model.dart';
import '../injectable.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile_page_widgets/profile_field_widget.dart';
import '../widgets/profile_page_widgets/profile_item_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final obj = ModalRoute.of(context).settings.arguments;
    final list = obj is Set ? obj.toList() : [];
    final String pageName = list[0];

    return CustomAppBar(
      title: pageName,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            FutureBuilder<Profile>(
                future: getIt<LocalRepositoryImpl>().getLocalClientInfo(),
                builder: (context, snapshot) => snapshot.hasData
                    ? Container(
                        child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height * .8,
                                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        snapshot.data.photo != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(80),
                                                child: InkResponse(
                                                  child: snapshot.data.photo.isNotEmpty
                                                      ? Image.memory(
                                                          snapshot.data.photo,
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
                                                  onTap: () {
                                                    /*  provider.changeUserAvatar();
                                                    provider?.addListener(() {
                                                      if (mounted) setState(() {});
                                                    }); */
                                                  },
                                                ),
                                              )
                                            : Container(
                                                width: 110,
                                                height: 110,
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ProfileItemWidget(labelText: AppLocalizations.of(context).translate('firsname'), text: snapshot.data.firstName),
                                            SizedBox(
                                              width: size.width - 180,
                                              child: Divider(),
                                            ),
                                            ProfileItemWidget(labelText: AppLocalizations.of(context).translate('lastname'), text: snapshot.data.lastName),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    ProfileItemWidget(labelText: 'E-mail', text: snapshot.data.email ?? ''),
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
                      )
                    : Container()),
            /*  Positioned(
              top: MediaQuery.of(context).size.height * .6,
              left: MediaQuery.of(context).size.width / 3,
              child: Container(
                width: MediaQuery.of(context).size.width * .33,
                child: OutlineButton(
                  onPressed: () {
                    service.signOut(context);
                  },
                  splashColor: Colors.green,
                  borderSide: BorderSide(color: Colors.green),
                  highlightColor: Colors.green,
                  highlightedBorderColor: Colors.red,
                  child: Text(AppLocalizations.of(context).translate('logout')),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ) */
          ],
        ),
      ),
    );
  }
}
