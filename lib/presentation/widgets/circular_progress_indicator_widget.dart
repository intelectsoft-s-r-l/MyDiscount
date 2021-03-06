import 'package:flutter/material.dart';

class CircularProgresIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.green),
      ),
    );
  }
}
