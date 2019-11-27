import 'package:flutter/material.dart';
import 'package:sewa_dong_project/Model/user.dart';
import 'package:sewa_dong_project/Utils/SessionUser.dart';
import 'package:sewa_dong_project/home_page.dart';
import 'package:sewa_dong_project/login_page.dart';
import 'package:sewa_dong_project/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MaterialApp(initialRoute: '/', routes: {
      '/': (context) => SplashScreen(),
      '/home': (context) => HomePage(),
      '/login': (context) => LoginPage(),
      '/signup': (context)=> SignUpPage()
    }));

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _navigateToLoginPage(context);
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Text(
            'Sewa Dong',
            style: TextStyle(
                fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ));
  }

  void _navigateToLoginPage(BuildContext context) async {
    String page = '/login';
    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences.getInstance().then((pref) async {
        if (pref.containsKey('user')) {
          SessionUser.user = User.fromJson(json.decode(pref.getString('user')));
          page = '/home';
        }
        await Navigator.pushNamedAndRemoveUntil(
            context, page, (Route<dynamic> route) => false);
      });
    });
  }
}
