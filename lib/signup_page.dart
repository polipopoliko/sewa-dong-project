import 'package:flutter/material.dart';
import 'package:sewa_dong_project/Utils/DefaultFormField.dart';
import 'package:sewa_dong_project/Utils/snackbar.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<StatefulWidget> {
  DefaultFormField _form;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _form = DefaultFormField('SIGNUP', callbackFunction: callbackFunction,);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: _form,
        ),
      ),
    );
  }

  void callbackFunction(String message) =>
      Snackbar(scaffoldKey: _scaffoldKey, message: message).showSnackbar();
}
