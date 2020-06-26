import 'dart:math';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool img = true;

  removeSharedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 86, 198, 1),
        title: Text(
          'MyDiscount',
          style: TextStyle(fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              removeSharedData();
              signoutFb();
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Your Qr-code',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,),
            Container(
              //height: MediaQuery.of(context).size.height,
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
  bool text = true;
  bool internetStatus = false;
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
        setState(() {
          if (animation.value == 0) {
            print(animation.value);

            checkInternetConection();
          }
        });
      });
    checkInternetConection();
  }

  void progressForward() {
    progressController.forward();
  }

  void progressReset() async {
    progressController.reset();

    //serv.getuserData();
    await serv.attemptSignIn();
    countGetID += 1;
    progressForward();
  }

  void checkInternetConection() async {
    DataConnectionStatus status = await internetConection();
    if (status == DataConnectionStatus.connected) {
      _tapFunction();
    } else {
      setState(() {
        img = false;
        internetStatus = false;
        text = false;
      });
    }
  }

  void _tapFunction() async {
    if (countGetID == 2) {
      setState(() {
        img = !img;
        internetStatus = false;
        text = true;
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
    SharedPref sPref = SharedPref();

    Future<String> _loadSharedPref() async {
      var id = await sPref.readTID();

      return id;
    }

    return img || internetStatus
        ? Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /* Text(
                'Your Qr-code',
                style: TextStyle(fontSize: 20),
              ), */
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Container(
                alignment: Alignment.center,
                //height: MediaQuery.of(context).size.height * 0.3,
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
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(
                'Qr-code available:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
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
              text
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Image.asset('assets/icons/om.jpg')),
                          SizedBox(height: 10.0),
                          Text(
                            'We have generated QR codes many times',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Generate a new code?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ))
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                              child:
                                  Image.asset('assets/icons/no internet.png')),
                          SizedBox(height: 20.0),
                          Text(
                            'You do not have Internet connection',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 10.0),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    img = !img;
                    internetStatus = true;
                  });
                  countGetID = 0;
                  checkInternetConection();
                  /* tapFunction(); */
                },
                child: Text(
                  'Generate',
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
    double radius = min(size.width / 2, size.height / 2) - 20;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
