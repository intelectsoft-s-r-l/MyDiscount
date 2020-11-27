import 'package:MyDiscount/localization/localizations.dart';
import 'package:MyDiscount/models/user_credentials.dart';
import 'package:flutter/material.dart';

import '../services/qr_service.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/companies_list_widget.dart';
import '../widgets/noCompani_list_widget.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/top_bar_image.dart';
import 'profile_page.dart';

class UserPage extends StatelessWidget {
  final QrService data = QrService();
  final UserCredentials credentials = UserCredentials();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              TopBarImage(size: size),
              Positioned(
                top: size.height * .05,
                left: 30,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: credentials.getUserProfileData(), //_loadSharedPref(),
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    return snapshot.hasData
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (contxt) => ProfilePage(),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: snapshot.data['photoUrl'] != ''&&snapshot.data['photoUrl'] != null
                                        ? Image.network(
                                            snapshot.data['photoUrl'],
                                            fit: BoxFit.fill,
                                            scale: 0.7,
                                            filterQuality: FilterQuality.high,
                                          )
                                        : Image.asset(
                                            'assets/icons/profile.png'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      snapshot.data['firstName'] != null
                                          ? Text(
                                              '${snapshot.data['firstName']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                //fontSize: 20,
                                              ),
                                              textScaleFactor: 1.3,
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      snapshot.data['lastName'] != null
                                          ? Text(
                                              '${snapshot.data['lastName']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                //fontSize: 20,
                                              ),
                                              textScaleFactor: 1.3,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  if (snapshot.data['registerMode'] == 1)
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('text15'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        //fontSize: 16,
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                  if (snapshot.data['registerMode'] == 2)
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('text16'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        //fontSize: 16,
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                  if (snapshot.data['registerMode'] == 3)
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('text17'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        // fontSize: 16,
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                ],
                              )
                            ],
                          )
                        : Container();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: FutureBuilder<dynamic>(
                future: data.getCompanyList(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Scaffold(
                    body: snapshot.data != false
                        ? Container(
                            child: snapshot.hasData
                                ? Container(
                                    child: snapshot.data.length != 0
                                        ? CompaniesList(snapshot.data)
                                        : NoCompanieList(),
                                  )
                                : CircularProgresIndicatorWidget(),
                          )
                        : Container(
                            child: NoInternetWidget(),
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
