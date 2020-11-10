import 'package:flutter/material.dart';

class GenderWidget extends StatefulWidget {
  @override
  _GenderWidgetState createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  bool _isEditing = false;
  var initialText;
  @override
  void initState() {
    super.initState();
    initialText = 'Male';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing)
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
                setState(() {
                  initialText = value;
                  _isEditing = false;
                });
              }),
        ],
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditing = true;
          });
        },
        child: Text(
          initialText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
