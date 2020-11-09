import 'package:flutter/material.dart';

class EmailWidget extends StatefulWidget {
  @override
  _EmailWidgetState createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  TextEditingController _controller;
  bool _isEditing = false;
  var initialText = 'koolpix404@gmail.com';
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
