import 'package:flutter/material.dart';

class Utilities {
  //Snackbar
  static void showSnackBar(BuildContext context, String message,
      {int seconds = 2}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
      ));
    }
  }

  //navigate screen
  static void navigateScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
