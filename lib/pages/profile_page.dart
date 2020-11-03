import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'First Name',
                style: TextStyle(color: Colors.black45),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('Igor'),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Last Name',
                style: TextStyle(color: Colors.black45),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('Cristea'),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Date of birth',
                style: TextStyle(color: Colors.black45),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('08.05.1995'),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Gender',
                style: TextStyle(color: Colors.black45),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('Male'),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('E-mail'),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('koolpix404@gmail.com'),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Phone Number',
                style: TextStyle(color: Colors.black45),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('+37369858838'),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
