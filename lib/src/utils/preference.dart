import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/src/service/constants.dart';
import 'package:test_project/src/views/login/model/login_data.dart';

class MyPreference {
  static add(String key, dynamic value, SharePrefType prefType) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    switch (prefType) {
      case SharePrefType.Bool:
        return myPref.setBool(key, value);
      case SharePrefType.Double:
        return myPref.setDouble(key, value);
      case SharePrefType.Int:
        return myPref.setInt(key, value);
      case SharePrefType.String:
        return myPref.setString(key, value);
    }
  }

  static get(String key, SharePrefType prefType) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    switch (prefType) {
      case SharePrefType.Bool:
        return myPref.getBool(key);
      case SharePrefType.Double:
        return myPref.getDouble(key);
      case SharePrefType.Int:
        return myPref.getInt(key);
      case SharePrefType.String:
        return myPref.getString(key);
    }
  }

  static Future<bool> removeKeyData(String key) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return await myPref.remove(key);
  }

  static containsKey(key) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return myPref.containsKey(key);
  }

  static Future<dynamic> clear() async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return await myPref.clear();
  }

  static Future<LoginData> getLoginData() async {
    var loginDetails = await get(Constants.LOGIN_DATA, SharePrefType.String);
    var jsonData = json.decode(loginDetails);
    LoginData loginData = LoginData.fromJson(jsonData);
    return loginData;
  }

  static Future<String> getUserId() async {
    LoginData loginData = await getLoginData();
    return loginData.id;
  }
}

enum SharePrefType {
  Int,
  String,
  Bool,
  Double,
}
