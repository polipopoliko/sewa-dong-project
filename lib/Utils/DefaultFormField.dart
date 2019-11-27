import 'package:flutter/material.dart';
import 'package:sewa_dong_project/Model/user.dart';
import 'package:sewa_dong_project/Utils/SessionUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DefaultFormField extends StatefulWidget {
  final String type;
  final DefaultFormFieldState state = DefaultFormFieldState();
  final Function callbackFunction;

  DefaultFormField(this.type, {this.callbackFunction});

  @override
  State<StatefulWidget> createState() => state;
}

class DefaultFormFieldState extends State<DefaultFormField> {
  final TextEditingController _nameController = TextEditingController(text: ''),
      _phoneController = TextEditingController(text: ''),
      _emailController = TextEditingController(text: ''),
      _passwordController = TextEditingController(text: '');
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '${widget.type}',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 42,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: widget.type == 'LOGIN' ? 100 : 50),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image.asset(
                      'images/small_logo.png',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  widget.type == 'SIGNUP'
                      ? _getFormWidget('NAMA')
                      : Container(),
                  widget.type == 'SIGNUP'
                      ? _getFormWidget('NO HP')
                      : Container(),
                  _getFormWidget('EMAIL'),
                  _getFormWidget('PASSWORD'),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.blue,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 50,
                        child: Text('${widget.type}'),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState.validate()) if (widget.type ==
                            'LOGIN')
                          await _loginAttempt();
                        else {
                          widget.callbackFunction('Sukses membuat user');
                          await _saveDataToPreference()
                              .whenComplete(() => Navigator.pop(context));
                        }
                        else
                          setState(() => _autoValidate = true);
                      },
                    ),
                  ),
                  widget.type == 'LOGIN'
                      ? Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 30, bottom: 5),
                          child: Text(
                            'Belum punya akun?',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(),
                  widget.type == 'LOGIN'
                      ? Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            onTap: () async =>
                                Navigator.pushNamed(context, '/signup'),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _loginAttempt() async {
    await SharedPreferences.getInstance().then((pref) async {
      if (pref.containsKey('user')) {
        User user = User.fromJson(json.decode(pref.getString('user')));
        if (_emailController.text == user.email &&
            _passwordController.text == user.password) {
          SessionUser.user = user;
          await Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        } else
          widget.callbackFunction('Email atau password salah');
      } else
        widget.callbackFunction('Email belum terdaftar');
    });
  }

  Future<void> _saveDataToPreference() async {
    await SharedPreferences.getInstance().then((pref) {
      pref.setString('user', '''{
        \"nama\": \"${_nameController.text}\",
        \"noHp\": \"${_phoneController.text}\",
        \"email\": \"${_emailController.text}\",
        \"password\": \"${_passwordController.text}\" 
      }''');

      print(pref.getString('user'));
    });
  }

  Widget _getFormWidget(String type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('$type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Flexible(
          fit: FlexFit.loose,
          flex: 1,
          child: Text(':',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Flexible(
          fit: FlexFit.loose,
          flex: 2,
          child: Container(
            padding: EdgeInsets.only(left: 5, top: 10),
            alignment: Alignment.center,
            height: 65,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextFormField(
              keyboardType: type == 'NO HP'
                  ? TextInputType.number
                  : type == 'EMAIL'
                      ? TextInputType.emailAddress
                      : TextInputType.text,
              controller: type == 'NAMA'
                  ? _nameController
                  : type == 'NO HP'
                      ? _phoneController
                      : type == 'PASSWORD'
                          ? _passwordController
                          : _emailController,
              decoration: InputDecoration(border: OutlineInputBorder()),
              obscureText: type == 'PASSWORD' ? true : false,
              validator: (val) => _validateField(val, type),
            ),
          ),
        )
      ],
    );
  }

  String _validateField(String val, String type) {
    if (type == 'EMAIL') {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (val.isEmpty)
        return '$type tidak boleh kosong';
      else if (!regex.hasMatch(val)) return '$type tidak valid';
    } else if (type == 'NO HP') {
      if (val.isEmpty)
        return '$type tidak boleh kosong';
      else if (!val.startsWith('08'))
        return '$type harus dimulai dengan 08';
      else if (val.length < 12 || val.length > 13)
        return '$type tidak boleh kurang dari 12 atau lebih dari 13';
    } else if (val.length <= 0) return '$type tidak boleh kosong';
    return null;
  }
}
