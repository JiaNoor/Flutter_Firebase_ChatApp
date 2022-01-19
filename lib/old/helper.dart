import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String sharedPreferanceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferanceUserNameKey = "USERNAMEKEY";
  static String sharedPreferanceUserEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInSharedPreferance(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferanceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreferance(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferanceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreferance(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferanceUserEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInSharedPreferance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferanceUserLoggedInKey);
  }

  static Future<String?> getUserNameSharedPreferance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferanceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreferance(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferanceUserEmailKey);
  }
}
