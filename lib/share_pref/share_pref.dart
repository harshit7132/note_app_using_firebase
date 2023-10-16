import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {
  static const String USER_ID = 'userId';
  static const String IS_LOGIN = 'isLogin';

//Set Shared Preference
  static setShared(String userId, bool isloginId) async {
    var pref = await SharedPreferences.getInstance();

    pref.setString(USER_ID, userId);
    pref.setBool(IS_LOGIN, isloginId);
  }

// Get Shared Preference

  static Future<String> getSharedUserid() async {
    var pref = await SharedPreferences.getInstance();
    var check = pref.getString(USER_ID);

    return check ?? '';
  }

  static Future<bool> getSharedisLogin() async {
    var pref = await SharedPreferences.getInstance();
    var check = pref.getBool(IS_LOGIN);

    return check ?? false;
  }
}
