import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shugo/constants/texttheme.dart';
import 'package:shugo/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        navigationBarTheme: const NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        textTheme: STextTheme.sTextTheme,
      ),
      home: const Navigation(),
    );
  }
}
