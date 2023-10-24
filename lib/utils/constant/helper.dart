import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
class Helper{

  static var padding = 16.0;
  static var margin = 16.0;
  static Color primaryColor = const Color.fromRGBO(44, 61, 122, 1);
  static Color secondaryColor = const Color.fromRGBO(150, 148, 255, 1);
  static Color inversePrimary = const Color.fromRGBO(44, 61, 122, 0.5);


  static showErrorAlert(BuildContext context, {required String msg}) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red.shade900,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.startToEnd,
            showCloseIcon: true,
            closeIconColor: Theme.of(context).scaffoldBackgroundColor,
            content: Text(msg)));
  }





}