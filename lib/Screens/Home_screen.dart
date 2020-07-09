import 'dart:math';
import 'package:MyDiscount/Screens/app_localizations.dart';
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
  AuthServ serv = AuthServ();

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
  BuildContext dialogContext;
  AuthServ serv = AuthServ();

  int countGetID = 0; //numara de cite ori a fost chemat serviciu
  bool serviceConection = false; //verifica conexiunea la serviciu
  bool checkCountGetID = true; //arata imaginea cu om sau imaginea cu reteaua
  bool internetStatus = false; //verifica conexiunea la internet
  bool setImage = true; //arata imaginea cu om sau Qr
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

  showDialogto() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 60,
            decoration: BoxDecoration(color: Colors.white),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                new Text("Loading"),
              ],
            ),
          ),
        );
      },
    );
  }

  void progressForward() {
    countGetID += 1;
    progressController.forward();
  }

  void progressReset() {
    progressController.reset();
    progressForward();
  }

  void checkInternetConection() async {
    DataConnectionStatus status = await internetConection();

    switch (status) {
      case DataConnectionStatus.connected:
        {
          showDialogto();
          serviceConection = await serv.attemptSignIn();
          if (serviceConection == true) {
            Navigator.pop(dialogContext);
            _tapFunction();
          } else {
            Navigator.pop(dialogContext);
            setState(() {
              setImage = false;
              internetStatus = false;
              checkCountGetID = false;
            });
          }
        }
        break;
      case DataConnectionStatus.disconnected:
        {
          print("false connected");
          setState(() {
            setImage = false;
            internetStatus = false;
            checkCountGetID = false;
          });
          if (dialogContext != null) Navigator.of(dialogContext).pop();
        }
        break;
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
              Text(
                AppLocalizations.of(context).translate('text1'),
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
              Text(
                AppLocalizations.of(context).translate('text2'),
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
              checkCountGetID && serviceConection
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Image.asset('assets/icons/om.png'),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            AppLocalizations.of(context).translate('text3'),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            AppLocalizations.of(context).translate('text4'),
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
                          Text(
                            AppLocalizations.of(context).translate('text6'),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            AppLocalizations.of(context).translate('text7'),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
              const SizedBox(height: 10.0),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    setImage = true;
                    internetStatus = true;
                  });
                  checkInternetConection();
                  countGetID = 0;
                },
                child: checkCountGetID
                    ? Text(
                        AppLocalizations.of(context).translate('text5'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context).translate('text8'),
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
