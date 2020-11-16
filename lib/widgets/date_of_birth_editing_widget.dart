import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class BirthDayWidget extends StatefulWidget {
  @override
  _BirthDayWidgetState createState() => _BirthDayWidgetState();
}

class _BirthDayWidgetState extends State<BirthDayWidget> {
  bool _isEditing = false;
  String initialText;
  @override
  void initState() {
    super.initState();
    initialText = '';
    //_controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing)
      return DateTimePicker(
        type: DateTimePickerType.date,
        dateMask: 'd MMM, yyyy',
        initialValue: initialText,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        icon: Icon(Icons.event),
        dateLabelText: 'Date',
        //timeLabelText: "Hour",
        /* selectableDayPredicate: (date) {
    // Disable weekend days to select from the calendar
    if (date.weekday == 6 || date.weekday == 7) {
      return false;
    }

    return true;
  }, */
        onChanged: (val) {
          setState(() {
            initialText = val;
            _isEditing = false;
          });
          
        },
        /*  validator: (val) {
          setState(() {
            initialText = val;
            _isEditing = false;
          });
        }, */
        onEditingComplete: () {
          setState(() {
            _isEditing = false;
          });
        },
        onSaved: (val) {
          setState(() {
            initialText = val;
            _isEditing = false;
          });
        },
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
