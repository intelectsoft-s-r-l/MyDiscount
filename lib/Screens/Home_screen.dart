import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guid_gen/models/auth_to_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/SharedPref.dart';
//import '../Wedgets/circularindicator.dart';

class HomeScreen extends StatefulWidget {
  //static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State with TickerProviderStateMixin {
  AnimationController progressController;
  Animation<double> animation;
  String displayName;
  String userId;
  String email;
  String accessToken;
  String photoUrl;
  AuthServ serv = AuthServ();
  
  bool img = true;
  @override
  void initState() {
    super.initState();
    progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    animation = Tween<double>(begin: 10, end: 0).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
  }

  void progressForward() {
    progressController.forward();
  }

  void progressReset() {
    progressController.reset();
    serv.attemptSignIn(displayName, email, userId, photoUrl, accessToken);
  }

  void tapFunction() {
    if (animation.value == 10) {
      progressForward();
    } else {
      progressReset();
      progressForward();
    }
  }

  Widget build(BuildContext context) {
    void signoutFb() {
      FacebookLogin _facebookLogin = FacebookLogin();
      _facebookLogin.logOut();

      print("1");
    }

    void signOut() {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      googleSignIn.signOut();
      print('object');
    }

    SharedPref sPref = SharedPref();

    Future<String> _loadSharedPref() async {
      var id = await sPref.readTID();
      return id;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 86, 198, 1),
        title: Text(
          'Y-Qr',
          style: TextStyle(fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signoutFb();
              signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: img
                  ? Column(
                      children: <Widget>[
                        Text(
                          'Your Qr-code',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: FutureBuilder<String>(
                            future: _loadSharedPref(),
                            builder: (context, snapshot) {
                              return QrImage(
                                data: '${snapshot.data}',
                                size: 200,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Qr-code available:',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 40),
                        GestureDetector(
                          onTap: tapFunction,
                          child: Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            child: CustomPaint(
                              foregroundPainter: ShapePainter(animation.value),
                              painter: ShapePainter(animation.value),
                              child: Container(
                                child: Text('${animation.value.toInt()}'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Image.asset('assets/icons/om.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  double currentProgress;

  ShapePainter(this.currentProgress);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    var completeArc = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 30, paint);
    double angle = 2 * pi * (currentProgress / 10);
    double radius = min(size.width / 2, size.height / 2) - 15;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
