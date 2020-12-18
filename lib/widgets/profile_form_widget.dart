import 'package:MyDiscount/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileFormWidget extends StatelessWidget {
  const ProfileFormWidget({
    Key key,
    @required this.profile,
  }) : super(key: key);
  final Profile profile;
  @override
  Widget build(BuildContext context) {
    var data = profile.birthDay.split('-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Container(
          child: Text('Date of birth'),
        ),
        Container(
          child: Text(profile.birthDay!=''?
            DateFormat('d MMM, yyyy').format(
              DateTime(
                int.parse(data[0]),
                int.parse(data[1]),
                int.parse(data[2]),
              ),
            ):'',
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
            profile.gender,
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
            profile.phone,
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
