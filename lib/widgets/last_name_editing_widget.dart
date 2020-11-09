import 'package:flutter/material.dart';

class LastNameWidget extends StatefulWidget {
  @override
  _LastNameWidgetState createState() => _LastNameWidgetState();
}

class _LastNameWidgetState extends State<LastNameWidget> {
  TextEditingController _controller;
  bool _isEditing = false;
  var initialText = 'Cristea';
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
        initialText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
