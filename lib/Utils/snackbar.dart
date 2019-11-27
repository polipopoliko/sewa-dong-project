import 'package:flutter/material.dart';

class Snackbar {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String message;
  final int durationInSeconds;
  final Color backgroundColor;

  Snackbar(
      {@required this.scaffoldKey,
      this.message,
      this.durationInSeconds = 1,
      this.backgroundColor = Colors.grey});

  void showSnackbar() => scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
        '$message',
        style: TextStyle(fontSize: 14),
      )));
}
