import 'package:MyDiscount/widgets/user_credentials.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

import '../widgets/date_of_birth_editing_widget.dart';
import '../widgets/gender_editing_widget.dart';
import '../widgets/phone_editing_widget.dart';
import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = true;

  @override
  void initState() {
    //UserCredentials().getUserProfileData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                      if (_isEditing) {
                        return Navigator.pop(context);
                      } else {
                        FlushbarHelper.createError(
                                message: "You dont't save the form")
                            .show(context);
                      }
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
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: FutureBuilder<Map<String, String>>(
                  initialData: {'firstName': '', 'lastName': '','email':''},
                  future: UserCredentials().getUserProfileData(),
                  builder: (context, snapshot) => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'First Name',
                            style: TextStyle(color: Colors.black45),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              snapshot.data['firstName'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ) //FirstNameWidget(snapshot.data['firstName']),
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
                            child: Text(
                              snapshot.data['lastName'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ) //LastNameWidget(),
                            ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('E-mail'),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              snapshot.data['email'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ) //EmailWidget(),
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
                          child: BirthDayWidget(),
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
                          child: GenderWidget(),
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
                          child: PhoneWidget(),
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
