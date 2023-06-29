import 'package:flutter/material.dart';
import 'package:todo/presentation/splash/splash_screen.dart';
import 'package:todo/utils/utils.dart';

import 'config/config.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          primaryColor: Config.baseClr,

          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
