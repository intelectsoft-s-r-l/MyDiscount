import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guid_gen/models/SharedPref.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CircularProgres extends StatefulWidget {
  @override
  _CircularProgresState createState() => _CircularProgresState();
}

class _CircularProgresState extends State with TickerProviderStateMixin  {
  AnimationController progressController;
  Animation<double> animation;

 SharedPref sPref = SharedPref();

 _loadSharedPref() async {
  String id = await sPref.readTID();
  return id;
}
  //String tID = _loadSharedPref();
  
  @override
  void initState() {
    super.initState();
    progressController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    animation = Tween<double>(begin: 0, end: 10).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
  }

  //var _guid = Guid.defaultValue;
  @override
  Widget build(BuildContext context) {
    void progressForward() {
      progressController.forward();
    }

    void progressReset() {
      progressController.reset();
    }

    void tapFunction() {
      if (animation.value == 0) {
        progressForward();
      } else {
        progressReset();
        progressForward();
      }
    }

    return GestureDetector(
      onTap: () {
        tapFunction();
       /*  setState(() {
          _guid = Guid.newGuid;
        }); */
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(
                width: 3,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: QrImage(data: '',size: 150,)
          ),
          SizedBox(height: 80),
          Container(
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
        ],
      ),
    );
  }
}



class ShapePainter extends CustomPainter  {
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
