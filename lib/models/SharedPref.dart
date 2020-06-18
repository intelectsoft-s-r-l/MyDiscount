//import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  saveTID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Tid', id);
  }

  readTID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Tid');
  }

  saveID(String userId) async {
    final authData = await SharedPreferences.getInstance();
    authData.setString('userID', userId);
   
  }

  getID() async {
    final authData = await SharedPreferences.getInstance();
    return authData.getString('userID');
  }


  setDisplayName(dispalyName)async{
    final userData = await SharedPreferences.getInstance();
    userData.setString('displayName',dispalyName);
    //print(authData);
  } 
    
  getDisplayName()async{
    final userData = await SharedPreferences.getInstance();
   return  userData.getString('displayName');
  }
   setEmail(email)async{
    final userData = await SharedPreferences.getInstance();
    userData.setString('email',email);
    //print(authData);
  } 
    
  getEmail()async{
    final userData = await SharedPreferences.getInstance();
    return userData.getString('email');
  }
   setPhotoUrl(photoUrl)async{
    final userData = await SharedPreferences.getInstance();
    userData.setString('photoUrl',photoUrl);
    //print(authData);
  } 
    
  getPhotoUrl()async{
    final userData = await SharedPreferences.getInstance();
    return userData.getString('photoUrl');
  }
   setAccessToken(accessToken)async{
    final userData = await SharedPreferences.getInstance();
    userData.setString('accessToken',accessToken);
    //print(authData);
  } 
    
  getAccessToken()async{
    final userData = await SharedPreferences.getInstance();
     return userData.getString('accessToken');
  }
}
