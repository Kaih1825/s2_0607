import 'package:flutter/material.dart';
import 'package:s2_0607/Screens/FirstScreen.dart';
import 'package:s2_0607/Screens/HomeScreen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirstScreen(),
      routes: {
        "/home" : (context)=>const HomeScreen()
      },
    );
  }
}
