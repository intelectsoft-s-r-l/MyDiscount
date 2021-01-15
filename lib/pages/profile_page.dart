import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../core/localization/localizations.dart';
import '../models/profile_model.dart';
import '../models/user_credentials.dart';
import '../providers/phone_number.dart';
import '../services/auth_service.dart';
import '../widgets/profile_field_widget.dart';
import '../widgets/profile_item_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService service = AuthService();
  @override
  void initState() {
    UserCredentials().getUserProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String pageName = ModalRoute.of(context).settings.arguments;
    final appBar = AppBar(
      title: Text(pageName),
      backgroundColor: Colors.green,
      elevation: 0,
    );
    return Scaffold(
      appBar: appBar,
      body: ChangeNotifierProvider.value(
        value: PhoneNumber(),
        child: Container(
          color: Colors.green,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height) -
                        30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: FutureBuilder<Profile>(
                      future: UserCredentials().getUserProfileData(),
                      builder: (context, snapshot) => snapshot.hasData
                          ? ListView(
                              // physics: BouncingScrollPhysics(),
                              children: [
                                SafeArea(
                                  bottom: true,
                                  child: Container(
                                    height:
                                        (MediaQuery.of(context).size.height -
                                                appBar.preferredSize.height) *
                                            .77,
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ProfileItemWidget(
                                            labelText:
                                                AppLocalizations.of(context)
                                                    .translate('text26'),
                                            text: snapshot.data.firstName),
                                        Divider(),
                                        ProfileItemWidget(
                                            labelText:
                                                AppLocalizations.of(context)
                                                    .translate('text27'),
                                            text: snapshot.data.lastName),
                                        Divider(),
                                        ProfileItemWidget(
                                            labelText: 'E-mail',
                                            text: snapshot.data.email ?? ''),
                                        Divider(),
                                        ProfileFieldWidget(
                                          labelText:
                                              AppLocalizations.of(context)
                                                  .translate('text37'),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: (MediaQuery.of(context).size.height -
                                          appBar.preferredSize.height) *
                                      .15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlineButton(
                                            onPressed: () {
                                              service.signOut(context);
                                            },
                                            splashColor: Colors.green,
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                            highlightColor: Colors.green,
                                            highlightedBorderColor: Colors.red,
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('text31')),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Container(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
