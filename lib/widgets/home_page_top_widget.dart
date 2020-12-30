import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import '../models/user_credentials.dart';

class HomePageTopWidget extends StatelessWidget {
  HomePageTopWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;
  final UserCredentials credentials = UserCredentials();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .253,
      width: size.width,
      child: FutureBuilder(
        future: credentials.getUserProfileData(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Stack(
                  children: [
                    Positioned(
                      top: 30,
                      left: size.width * .2,
                      child: Container(
                        width: size.width * .6,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: snapshot.data.photoUrl != ''
                                    ? Image.network(
                                        snapshot.data.photoUrl,
                                        fit: BoxFit.fill,
                                        scale: 0.7,
                                        filterQuality: FilterQuality.high,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/icons/profile.png');
                                        },
                                      )
                                    : Image.asset('assets/icons/profile.png'),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${snapshot.data.firstName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textScaleFactor: 1.3,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${snapshot.data.lastName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textScaleFactor: 1.3,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (snapshot.data.registerMode == 1)
                              Text(
                                AppLocalizations.of(context)
                                    .translate('text39'),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textScaleFactor: 1,
                              ),
                            if (snapshot.data.registerMode == 2)
                              Text(
                                AppLocalizations.of(context)
                                    .translate('text40'),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textScaleFactor: 1,
                              ),
                            if (snapshot.data.registerMode == 3)
                              Text(
                                AppLocalizations.of(context)
                                    .translate('text41'),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textScaleFactor: 1,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }
}
