import 'package:flutter/material.dart';

class BirthDayWidget extends StatefulWidget {
  @override
  _BirthDayWidgetState createState() => _BirthDayWidgetState();
}

class _BirthDayWidgetState extends State<BirthDayWidget> {
  TextEditingController _controller;
  bool _isEditing = false;
  var initialText = DateTime.now().toString();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              initialText = newValue;
              _isEditing = false;
            });
          },
          onChanged: (value) {
            setState(() {
              initialText = value;
            });
          },
          autofocus: true,
          controller: _controller,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: Text(
        initialText.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
