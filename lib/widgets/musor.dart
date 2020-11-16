/*  import 'package:flutter/material.dart';

Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Date of birth',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: _isEditing
                                    ? Text(snapshot.data['birthDay'])
                                    : BirthDayWidget(),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Gender',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isEditing = true;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: _isEditing
                                      ? Text(snapshot.data['gender'])
                                      : ButtonBar(
                                          alignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Male'),
                                            Radio(
                                                value: 'Male',
                                                groupValue: initialText,
                                                onChanged: (value) {
                                                  setState(() {
                                                    initialText = value;
                                                    _isEditing = false;
                                                  });
                                                }),
                                            Text('Female'),
                                            Radio(
                                                value: 'Female',
                                                groupValue: initialText,
                                                onChanged: (value) {
                                                  setState(() {
                                                    initialText = value;
                                                    _isEditing = false;
                                                  });
                                                }),
                                          ],
                                        ),
                                ),
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
                                child: _isEditing
                                    ? Text(snapshot.data['phoneNumber'])
                                    : PhoneWidget(),
                              ),
                              Divider(),
                              SizedBox(
                                height: 20,
                              ), */