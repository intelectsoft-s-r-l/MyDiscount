import 'package:flutter/material.dart';

class ProfileHomeItemWidget extends StatelessWidget {
  const ProfileHomeItemWidget({
    Key key,
    this.icon,
    this.pageName,
    this.routeName,
  }) : super(key: key);
  final IconData icon;
  final String pageName;

  final String routeName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(routeName, arguments: pageName);
          },
          child: ListTile(
            leading:
                icon != null ? Icon(icon, size: 35, color: Colors.green) : null,
            title: Text(
              pageName,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        Divider(),
      ],
    );
  }
}
