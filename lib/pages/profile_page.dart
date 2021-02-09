import 'package:MyDiscount/domain/entities/profile_model.dart';
import 'package:MyDiscount/providers/auth_provider.dart';
import 'package:MyDiscount/services/user_credentials.dart';
import 'package:MyDiscount/widgets/custom_app_bar.dart';
import 'package:MyDiscount/widgets/profile_page_widgets/profile_field_widget.dart';
import 'package:MyDiscount/widgets/profile_page_widgets/profile_item_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../core/localization/localizations.dart';

import '../providers/phone_number.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //final AuthService service = AuthService();
  @override
  void initState() {
    UserCredentials().getUserProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthorizationProvider>(context, listen: false);
    final String pageName = ModalRoute.of(context).settings.arguments;
    return CustomAppBar(
      title: pageName,
      child: ChangeNotifierProvider.value(
        value: PhoneNumber(),
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              FutureBuilder<Profile>(
                future: UserCredentials().getUserProfileData(),
                builder: (context, snapshot) => snapshot.hasData
                    ? ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileItemWidget(labelText: AppLocalizations.of(context).translate('firsname'), text: snapshot.data.firstName),
                                Divider(),
                                ProfileItemWidget(labelText: AppLocalizations.of(context).translate('lastname'), text: snapshot.data.lastName),
                                Divider(),
                                ProfileItemWidget(labelText: 'E-mail', text: snapshot.data.email ?? ''),
                                Divider(),
                                ProfileFieldWidget(
                                  labelText: AppLocalizations.of(context).translate('phone'),
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .77,
                left: MediaQuery.of(context).size.width / 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * .33,
                  child: OutlineButton(
                    onPressed: () {
                      provider.logOut();
                    },
                    splashColor: Colors.green,
                    borderSide: BorderSide(color: Colors.green),
                    highlightColor: Colors.green,
                    highlightedBorderColor: Colors.red,
                    child: Text(AppLocalizations.of(context).translate('logout')),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
