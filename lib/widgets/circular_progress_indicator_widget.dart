import 'package:flutter/material.dart';

class CircularProgresIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.green),
        ),
      ),
    );
  }
}
