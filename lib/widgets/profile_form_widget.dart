import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileFormWidget extends StatelessWidget {
  const ProfileFormWidget({
    Key key,
    @required this.map,
  }) : super(key: key);
  final Map<String, dynamic> map;
  @override
  Widget build(BuildContext context) {
    var data = map['birthDay'].toString().split('-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Container(
          child: Text('Date of birth'),
        ),
        Container(
          child: Text(
            map['birthDay'] != ''
                ? DateFormat('d MMM, yyyy').format(
                    DateTime(
                      int.parse(data[0]),
                      int.parse(data[1]),
                      int.parse(data[2]),
                    ),
                  )
                : '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
        Divider(),
        Container(
          child: Text('Gender'),
        ),
        Container(
          child: Text(
            map['gender'] != null ? map['gender'] : '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
        Divider(),
        Container(
          child: Text('Phone Number'),
        ),
        Container(
          child: Text(
            map['phone'] != null ? map['phone'] : '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }
}
