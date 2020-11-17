import 'package:flutter/material.dart';

class GenderWidget extends StatefulWidget {
  @override
  _GenderWidgetState createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  // ignore: unused_field
  bool _isEditing = false;
  var initialText;
  @override
  void initState() {
    super.initState();
    initialText = '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*   if (_isEditing) */
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: [
        Text('Male'),
        Radio(
            value: 'Male',
            groupValue: initialText,
            onChanged: (value) {
              setState(() {
                initialText = value;
                _isEditing = false;
              });
            }),
        Text('Female'),
        Radio(
            value: 'Female',
            groupValue: initialText,
            onChanged: (value) {
              setState(
                () {
                  initialText = value;
                  _isEditing = false;
                },
              );
            }),
      ],
    );
  }
}
