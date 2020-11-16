import 'package:MyDiscount/widgets/localizations.dart';
import 'package:MyDiscount/widgets/user_credentials.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  String initialText = '';

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
                AppBarText(size: size, text: AppLocalizations.of(context).translate('text25')),
                Positioned(
                  top: size.height * .07,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                    /*   if (_isEditing) { */
                        return Navigator.pop(context);
                    /*   } else {
                        FlushbarHelper.createError(
                                message: "You dont't save the form")
                            .show(context);
                      } */
                    },
                  ),
                ),
                /* Positioned(
                  top: size.height * .08,
                  right: 30,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ), */
              ],
            ),
            Expanded(
              child: Container(
                child: FutureBuilder<Map<String, String>>(
                  initialData: {
                    'firstName': '',
                    'lastName': '',
                    'email': '',
                    'birthDay': '',
                    'gender': '',
                    'phoneNumber': ''
                  },
                  future: UserCredentials().getUserProfileData(),
                  builder: (context, snapshot) => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            AppLocalizations.of(context).translate('text26'),
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
                            )),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            AppLocalizations.of(context).translate('text27'),
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
                            )),
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
                            )),
                        Divider(),
                        /* Form(
                          child: Column(
                            children: [
                              TextFormField(

                              ),
                              DropdownButtonFormField(
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('Male'),
                                    ),
                                    DropdownMenuItem(
                                      child: Text('Female'),
                                    ),
                                  ],
                                  onChanged: (gender) {
                                    setState(() {
                                      initialText = gender;
                                      //_isEditing = false;
                                    });
                                    /*  value:
                                        initialText; */
                                  }),
                              /* : Text(
                                      "${snapshot.data['phoneNumber'] != null ? snapshot.data['phoneNumber'] : ''}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ), */
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Phone Number *',
                                  hintText: 'Where can we reach you?',
                                  /*  helperText:
                                            'Phone format: (+XXX)XXX-XXXXX', */
                                  prefixIcon: Icon(Icons.call),
                                ),
                                keyboardType: TextInputType.phone,

                                validator: (value) => value.length < 12
                                    ? null
                                    : 'Phone number must be ',
                                //onSaved: (value) => //newUser.phone = value,
                              ),
                            ],
                          ),
                        ), */
                        /* Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ), */
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
