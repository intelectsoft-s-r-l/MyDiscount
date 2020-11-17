import 'package:MyDiscount/widgets/localizations.dart';
import 'package:MyDiscount/widgets/user_credentials.dart';
import 'package:date_time_picker/date_time_picker.dart';
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
  String dataText = '';
  String dataInitialText;

  UserCredentials userCredentials = UserCredentials();
  final _formKey = GlobalKey<FormFieldState>();
  TextEditingController _phoneController = TextEditingController();
  List<String> _genders = ['Male', 'Female'];
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
                AppBarText(
                    size: size,
                    text: AppLocalizations.of(context).translate('text25')),
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
                Positioned(
                  top: size.height * .08,
                  right: 30,
                  child: GestureDetector(
                    onTap: () {
                      _isEditing
                          ? userCredentials.saveFormProfileInfo(
                              birthDay: dataText,
                              gender: dataInitialText,
                              phoneNumber: _phoneController.text,
                              // ignore: unnecessary_statements
                            )
                          : null;
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                      /*  if (_formKey.currentState.validate())
                        // ignore: unnecessary_statements
                        _isEditing ? _formKey.currentState.save() : null; */
                    },
                    child: Text(
                      _isEditing ? 'Save' : 'Edit',
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
                        _isEditing
                            ? Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.always,
                                child: Column(
                                  children: [
                                    DateTimePicker(
                                        type: DateTimePickerType.date,
                                        dateMask: 'd MMM, yyyy',
                                        initialValue: _isEditing
                                            ? snapshot.data['birthDay']
                                            : dataText,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                        //icon: Icon(Icons.event),
                                        dateLabelText: 'Date of birth',
                                        onChanged: (newValue) {
                                          setState(() {
                                            dataText = newValue;
                                          });
                                        }),
                                    DropdownButtonFormField(
                                        value: _isEditing
                                            ? snapshot.data['gender']
                                            : dataInitialText,
                                        items: _genders
                                            .map(
                                              (gender) =>
                                                  DropdownMenuItem<String>(
                                                child: Text(gender),
                                                value: gender,
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (gender) {
                                          setState(() {
                                            dataInitialText = gender;
                                          });
                                        }),
                                    TextFormField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          labelText: 'Phone Number *',
                                          hintText: 'Where can we reach you?',
                                          prefixIcon: Icon(Icons.call),
                                        ),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value.length == 9
                                            ? null
                                            : 'Phone number must be ',
                                        onSaved: (value) {
                                          setState(() {
                                            _phoneController.text = value;
                                          });
                                        }),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Date of birth'),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      snapshot.data['birthDay'] != null
                                          ? snapshot.data['birthDay']
                                          : '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Gender'),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      snapshot.data['gender'] != null
                                          ? snapshot.data['gender']
                                          : '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Phone Number'),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      snapshot.data['phoneNumber'] != null
                                          ? snapshot.data['phoneNumber']
                                          : '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
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
