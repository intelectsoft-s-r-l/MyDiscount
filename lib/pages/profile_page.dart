import 'package:flutter/material.dart';

import '../widgets/date_of_birth_editing_widget.dart';
import '../widgets/email_editing_widget.dart';
import '../widgets/first_name_editing_widget.dart';
import '../widgets/gender_editing_widget.dart';
import '../widgets/last_name_editing_widget.dart';
import '../widgets/phone_editing_widget.dart';
import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                TopBarImage(size: size),
                AppBarText(size: size, text: 'Profile'),
                Positioned(
                  top: size.height * .07,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: size.height * .08,
                  right: 30,
                  child: GestureDetector(
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ), /* IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ), */
                ),
              ],
            ),
            Expanded(
              child: Container(
                //height: size.height * .64,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*  Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                          ),
                        ), */
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'First Name',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: FirstNameWidget(),
                      ),
                      /* SizedBox(height: 10), */
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
                        child: LastNameWidget(),
                      ),
                      /* SizedBox(
                          height: 10,
                        ), */
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
                        child: BirthDayWidget(),
                      ),
                      /*  SizedBox(
                          height: 10,
                        ), */
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
                        child: GenderWidget(),
                      ),
                      /*  SizedBox(
                          height: 10,
                        ), */
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('E-mail'),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: EmailWidget(),
                      ),
                      /*  SizedBox(
                          height: 10,
                        ), */
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
                        child: PhoneWidget(),
                      ),
                      /* SizedBox(
                          height: 10,
                        ), */
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
              ),
            ),
            //SizedBox(height: size.height*.14,),
            /* Container(
              child: SvgPicture.asset(
                'assets/icons/bottom.svg',
                width: size.width,
                height: size.height * .18,
                fit: BoxFit.fill,
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
