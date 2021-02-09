import 'package:MyDiscount/injectable.dart';
import 'package:MyDiscount/services/user_credentials.dart';
import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';


class HomePageTopWidget extends StatelessWidget {
  HomePageTopWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * .253,
      width: size.width,
      child: FutureBuilder(
        future: getIt<UserCredentials>().getUserProfileData(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Stack(
                  children: [
                    Positioned(
                      top: (size.height * .253)/4,
                      left: size.width * .2,
                      child: SizedBox(
                        width: size.width * .6,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: snapshot.data.photoUrl != ''
                                    ? Image.network(
                                        '${snapshot.data.photoUrl}',
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
                                  style:const TextStyle(
                                    color: Colors.white,
                                  ),
                                  textScaleFactor: 1.3,
                                ),
                               const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${snapshot.data.lastName}',
                                  style:const TextStyle(
                                    color: Colors.white,
                                  ),
                                  textScaleFactor: 1.3,
                                ),
                              ],
                            ),
                           const SizedBox(
                              height: 5,
                            ),
                            if (snapshot.data.registerMode == 1)
                              Text(
                                AppLocalizations.of(context)
                                    .translate('text39'),
                                style:const TextStyle(
                                  color: Colors.white,
                                ),
                                textScaleFactor: 1,
                              ),
                            if (snapshot.data.registerMode == 2)
                              Text(
                                AppLocalizations.of(context)
                                    .translate('text40'),
                                style:const TextStyle(
                                  color: Colors.white,
                                ),
                                textScaleFactor: 1,
                              ),
                            if (snapshot.data.registerMode == 3)
                              Text(
                                AppLocalizations.of(context)
                                    .translate('text41'),
                                style:const TextStyle(
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
