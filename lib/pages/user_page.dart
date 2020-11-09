import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/qr_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/companies_list_widget.dart';
import '../widgets/noCompani_list_widget.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/top_bar_image.dart';
import 'profile_page.dart';

class UserPage extends StatelessWidget {
  final QrService data = QrService();
  final SharedPref sPref = SharedPref();

    Future<Map<String, dynamic>> _loadSharedPref() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    final sharedMap = await sPref.readCredentials();
    final credential = json.decode(sharedMap);
    return Future<Map<String, dynamic>>.value(credential);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              TopBarImage(size: size),
              Positioned(
                top: size.height * .05,
                left: 30,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _loadSharedPref(),
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
                                  radius: 34,
                                  child: ClipRRect(
                                   
                                    borderRadius: BorderRadius.circular(40),
                                    child: snapshot.data['PhotoUrl'] != null
                                        ? Image.network(
                                            snapshot.data['PhotoUrl'],
                                            fit: BoxFit.fill,
                                            scale: 0.7,
                                            filterQuality: FilterQuality.high,
                                          )
                                        : Container(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${snapshot.data['DisplayName']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  if (snapshot.data['RegisterMode'] == 1)
                                    Text(
                                      'SignIn With Google',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  if (snapshot.data['RegisterMode'] == 2)
                                    Text(
                                      'SignIn With Facebook',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  if (snapshot.data['RegisterMode'] == 3)
                                    Text(
                                      'SignIn With Apple',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
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
              // height: size.height * .73,
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
