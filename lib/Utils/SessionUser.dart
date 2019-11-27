import 'package:sewa_dong_project/Model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionUser {
  static User user;

  static Future<void> clearSession() async =>
      await SharedPreferences.getInstance().then((pref) {
        user = null;
        pref.clear();
      });
}
