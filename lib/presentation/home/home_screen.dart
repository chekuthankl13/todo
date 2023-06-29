import 'package:flutter/material.dart';
import 'package:todo/presentation/task/add_task_screen.dart';

import 'package:todo/presentation/widgets/widgets.dart';
import 'package:todo/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: btmnav(context, fun: () {
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => const AddTaskScreen(),
        ));
      }, txt: "Add New Task"),
    );
  }
}
