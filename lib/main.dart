import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredient_recognizer_in_flutter/controller/base_controller.dart';
import 'package:ingredient_recognizer_in_flutter/controller/permission_controller.dart';
import 'package:ingredient_recognizer_in_flutter/view/screens/bottom_bar.dart';
import 'package:ingredient_recognizer_in_flutter/view/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BaseController());
    Get.put(PermissionController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ingredient Detector',
      theme: ThemeData(
        textTheme: const TextTheme(
          titleSmall: TextStyle(color: Color.fromRGBO(44, 61, 122, 1),
              fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal),
          titleMedium: TextStyle(color: Color.fromRGBO(44, 61, 122, 1),
              fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: Color.fromRGBO(44, 61, 122, 1),
              fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Color.fromRGBO(255, 121, 118, 1),
                fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal),
          bodyLarge: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
              fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal),
        ),
        secondaryHeaderColor: const Color.fromRGBO(150, 148, 255, 1),
        primaryColor: const Color.fromRGBO(44, 61, 122, 1),
        cardColor: const Color.fromRGBO(255, 121, 118, 1),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const BottomBar(),
    );
  }
}


