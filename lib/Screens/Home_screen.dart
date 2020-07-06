import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/SharedPref.dart';
import '../models/auth_to_service.dart';
import 'Log_in_Screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State with TickerProviderStateMixin {
  Widget build(BuildContext context) {
    void signOut() async {
      final FacebookLogin _facebookLogin = FacebookLogin();
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final prefs = await SharedPreferences.getInstance();
      _facebookLogin.logOut();
      googleSignIn.signOut();
      prefs.clear();
    }

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 86, 198, 1),
        title: Text(
          'MyDiscount',
          style: TextStyle(fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(MdiIcons.locationExit),
            onPressed: () {
              signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: CircularProgres(),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgres extends StatefulWidget {
  @override
  _CircularProgresState createState() => _CircularProgresState();
}

class _CircularProgresState extends State with TickerProviderStateMixin {
  AnimationController progressController;
  Animation<double> animation;

  AuthServ serv = AuthServ();

  int countGetID = 0;
  bool serviceConection = false;
  bool checkCountGetID = true;
  bool internetStatus = false;
  bool setImage = true;
  @override
  void initState() {
    super.initState();
    progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 7),
    );
    animation = Tween<double>(begin: 7, end: 0).animate(progressController)
      ..addListener(
        () {
          setState(() {
            if (animation.value == 0) {
              checkInternetConection();
            }
          });
        },
      );
    checkInternetConection();
  }

  void progressForward() async {
    serviceConection = await serv.attemptSignIn();
    if (serviceConection != true) {
      setState(() {
        setImage = false;
        checkCountGetID = false;
      });
    } else {
      countGetID += 1;
      progressController.forward();
    }
  }

  void progressReset() {
    progressController.reset();
    progressForward();
  }

  void checkInternetConection() async {
    DataConnectionStatus status = await internetConection();
    if (status == DataConnectionStatus.connected) {
      _tapFunction();
    } else {
      setState(() {
        setImage = false;
        internetStatus = false;
        checkCountGetID = false;
      });
    }
  }

  void _tapFunction() async {
    if (countGetID == 5) {
      setState(() {
        setImage = !setImage;
        internetStatus = false;
        checkCountGetID = true;
      });
    } else {
      progressReset();
    }
  }

  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SharedPref sPref = SharedPref();

    Future<String> _loadSharedPref() async {
      final id = await sPref.readTID();
      return id;
    }

    return setImage || internetStatus
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Your Qr-code',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: FutureBuilder<String>(
                  future: _loadSharedPref(),
                  builder: (context, snapshot) {
                    return QrImage(
                        data: '${snapshot.data}',
                        size: MediaQuery.of(context).size.height * 0.3);
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text(
                'Qr-code available:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              CustomPaint(
                size: MediaQuery.of(context).size,
                foregroundPainter: ShapePainter(animation.value),
                child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  child: Center(
                    child: Text('${animation.value.toInt()}'),
                  ),
                ),
                painter: ShapePainter(animation.value),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              checkCountGetID
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Image.asset('assets/icons/om.png'),
                          ),
                          SizedBox(height: 10.0),
                          const Text(
                            'We have generated QR codes many times',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Generate a new code?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ))
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Image.asset('assets/icons/no internet.png'),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'You do not have Internet connection ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'or service is not aviable',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
              const SizedBox(height: 10.0),
              RaisedButton(
                onPressed: () {
                  if (serviceConection != true) {
                    setState(() {
                      setImage = false;
                      checkCountGetID = false;
                    });
                  } else {
                    setState(() {
                      setImage = !setImage;
                      internetStatus = true;
                    });
                    countGetID = 0;
                    checkInternetConection();
                  }
                },
                child: checkCountGetID
                    ? const Text(
                        'Generate',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                color: Color.fromRGBO(42, 86, 198, 1),
              ),
            ],
          );
  }
}

class ShapePainter extends CustomPainter {
  double currentProgress;

  ShapePainter(this.currentProgress);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    var completeArc = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 30, paint);
    double angle = -2 * pi * (currentProgress / 7);
    double radius = min(size.width / 2, size.height / 2) - 20;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
