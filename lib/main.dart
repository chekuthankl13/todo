import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/database/hive_models/task_hive_model.dart';
import 'package:todo/logic/bloc_export.dart';
import 'package:todo/presentation/splash/splash_screen.dart';
import 'package:todo/utils/utils.dart';

import 'config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// disable landscape
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

// init hive
  await Hive.initFlutter();

// register adapter
  Hive.registerAdapter<TaskHiveModel>(TaskHiveModelAdapter());

//open box
  await Hive.openBox<TaskHiveModel>("task");

// bloc observer

  Bloc.observer = MyBlocObserver();

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
