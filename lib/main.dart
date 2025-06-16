import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // <-- add this
// import 'screens/yolo_pay_screen.dart'; <-- keep for use inside splash

void main() {
  runApp(const YoloApp());
}

class YoloApp extends StatelessWidget {
  const YoloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOLO Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
