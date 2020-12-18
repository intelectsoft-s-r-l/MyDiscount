import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/localizations.dart';
import '../models/profile_model.dart';
import '../models/user_credentials.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/profile_form_widget.dart';
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
  SharedPref prefs = SharedPref();

  UserCredentials userCredentials = UserCredentials();
  final _formKey = GlobalKey<FormFieldState>();
  TextEditingController _phoneController = TextEditingController();
  List<String> _genders = ['Male', 'Female'];
  @override
  void initState() {
    UserCredentials().getUserProfileData();
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
                  right: 15,
                  child: GestureDetector(
                    onTap: () async {
                      Profile profile =
                          await userCredentials.getUserProfileData();
                      _isEditing
                          ? userCredentials.saveFormProfileInfo(Profile(
                              birthDay: dataText,
                              gender: dataInitialText,
                              phone: _phoneController.text,
                            ))
                          // ignore: unnecessary_statements
                          : null;
                      setState(() {
                        _isEditing = !_isEditing;
                        if (_isEditing) {
                          dataText = profile.birthDay;
                          dataInitialText =
                              profile.gender != '' ? profile.gender : null;
                          _phoneController.text = profile.phone;
                        }
                      });
                    },
                    child: Text(
                      _isEditing
                          ? AppLocalizations.of(context).translate('save')
                          : AppLocalizations.of(context).translate('edit'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: FutureBuilder<Profile>(
                  future: UserCredentials().getUserProfileData(),
                  builder: (context, snapshot) => snapshot.hasData
                      ? SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('text26'),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Container(
                                    child: Text(
                                  snapshot.data.firstName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                                Divider(),
                                Container(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('text27'),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Container(
                                    child: Text(
                                  snapshot.data.lastName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                                Divider(),
                                Container(
                                  child: Text('E-mail'),
                                ),
                                Container(
                                    child: Text(
                                  snapshot.data.email,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                )),
                                _isEditing
                                    ? Container(
                                        // padding: EdgeInsets.only(left: 10, right: 10),
                                        child: Form(
                                          key: _formKey,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          child: Column(
                                            children: [
                                              Divider(),
                                              DateTimePicker(
                                                  type: DateTimePickerType.date,
                                                  dateMask: 'd MMM yyyy',
                                                  initialValue: dataText,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2100),
                                                  initialEntryMode:
                                                      DatePickerEntryMode.input,
                                                  dateLabelText:
                                                      'Date of birth',
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      dataText = newValue;
                                                    });
                                                  }),
                                              DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Gender'),
                                                items: _genders
                                                    .map(
                                                      (gender) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                        child: Text(gender),
                                                        value: gender,
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (String value) {
                                                  setState(() {
                                                    dataInitialText = value;
                                                  });
                                                },
                                                value: dataInitialText,
                                              ),
                                              TextFormField(
                                                  controller: _phoneController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Phone Number *',
                                                    hintText:
                                                        'Where can we reach you?',
                                                    /* prefixIcon:
                                                        Icon(Icons.call), */
                                                  ),
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  validator: (value) => value
                                                              .length ==
                                                          9
                                                      ? null
                                                      : 'Phone number lenght must pe 9 characters ',
                                                  onSaved: (value) {
                                                    setState(() {
                                                      _phoneController.text =
                                                          value;
                                                    });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      )
                                    : ProfileFormWidget(profile: snapshot.data),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
