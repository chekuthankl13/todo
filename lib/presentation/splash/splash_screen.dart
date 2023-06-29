import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/config/config.dart';
import 'package:todo/presentation/home/home_screen.dart';
import 'package:todo/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            Config.logo,
            width: sW(context) / 2,
          ),
        ),
      ),
    );
  }
}
