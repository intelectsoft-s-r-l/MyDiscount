import 'package:flutter/material.dart';

class PhoneWidget extends StatefulWidget {
  @override
  _PhoneWidgetState createState() => _PhoneWidgetState();
}

class _PhoneWidgetState extends State<PhoneWidget> {
  TextEditingController _controller;
  bool _isEditing = false;
  var initialText = '';
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
        child: Form(
          autovalidateMode:AutovalidateMode.always,
                  child: TextFormField(
            onChanged: (newValue) {
              setState(() {
                initialText = newValue;
               //if(newValue.isNotEmpty) _isEditing = false;
              });
            },
            /* onFieldSubmitted: (newValue) {
              setState(() {
                initialText = newValue;
               if(newValue.isNotEmpty) _isEditing = false;
              });
            }, */
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value.length<12) return 'Value is too short';
            },
           /*  onSaved: (newValue) {
              setState(() {
                initialText = newValue;
                _isEditing = false;
              });
            }, */
            autofocus: false,
            controller: _controller,
          ),
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
