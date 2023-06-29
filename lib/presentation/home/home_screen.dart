import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/config/config.dart';
import 'package:todo/database/hive_helpers.dart';
import 'package:todo/logic/bloc_export.dart';
import 'package:todo/presentation/task/add_task_screen.dart';
import 'package:todo/presentation/task/task_view_screen.dart';

import 'package:todo/presentation/widgets/widgets.dart';
import 'package:todo/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: btmnav(context, fun: () {
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => TaskCubit(),
            child: const AddTaskScreen(),
          ),
        ));
      }, txt: "Add New Task"),
      // appBar: AppBar(),
      backgroundColor: Config.baseBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: sH(context) / 2.5,
            width: sW(context),
            // color: Colors.red,
            child: Stack(
              children: [
                Container(
                  height: sH(context) / 4,
                  width: sW(context),
                  color: Config.baseClr,
                ),
                Positioned(
                  left: -45,
                  top: 70,
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Config.baseClr,
                        border: Border.all(color: Config.baseGrey, width: 16)),
                  ),
                ),
                Positioned(
                  right: -35,
                  top: -20,
                  child: Container(
                    height: 120,
                    width: 90,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Config.baseClr,
                        border: Border.all(color: Config.baseGrey, width: 16)),
                  ),
                ),
                const Positioned(
                  top: kToolbarHeight,
                  left: 0,
                  right: 0,
                  child: Text(
                    "My TodoLIst",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Config.white),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: sH(context) / 4,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Config.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: ValueListenableBuilder(
                      valueListenable: HIveHelpers.taskBox.listenable(),
                      builder: (context, value, child) {
                        var pendingTask = value.values
                            .where((e) => e.status == "pending")
                            .toList();
                        return pendingTask.isEmpty
                            ? const Center(
                                child: Text(
                                "No Pending Tasks Found !",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ))
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const BouncingScrollPhysics(),
                                itemCount: pendingTask.length,
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: Colors.grey[200],
                                  );
                                },
                                itemBuilder: (context, index) {
                                  var data = pendingTask[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    dense: true,
                                    onTap: () {
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            TaskViewScreen(task: data),
                                      ));
                                    },
                                    title: Text(data.title),
                                    subtitle: data.time.isNotEmpty
                                        ? Text(
                                            data.time,
                                            style: const TextStyle(
                                                fontSize: 9,
                                                color: Colors.grey),
                                          )
                                        : const SizedBox(),
                                    trailing: Checkbox(
                                      side: const BorderSide(
                                          width: 1, color: Config.baseClr),
                                      value: false,
                                      onChanged: (value) {
                                        context.read<TaskCubit>().updateTask(
                                            task: data, status: "done");
                                      },
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          spaceHeight(10),
          Row(
            children: [
              spaceWidth(10),
              const Text(
                "Completed Task",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: HIveHelpers.taskBox.listenable(),
            builder: (context, value, child) {
              var completedTask =
                  value.values.where((e) => e.status == "done").toList();
              return completedTask.isEmpty
                  ? const Center(
                      child: Text(
                      "No Completed Tasks Found !",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ))
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemCount: completedTask.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey[200],
                        );
                      },
                      itemBuilder: (context, index) {
                        var data = completedTask[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          leading: data.time.isNotEmpty
                              ? const CircleAvatar(
                                  backgroundColor: Config.grey,
                                  child: Icon(CupertinoIcons.calendar),
                                )
                              : CircleAvatar(
                                  backgroundColor: Config.grey2,
                                  child: Icon(
                                    Icons.book_outlined,
                                    color: Colors.blue.withOpacity(.5),
                                  ),
                                ),
                          title: Text(
                            data.title,
                            style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey,
                                decorationThickness: 2.6),
                          ),
                          subtitle: data.time.isNotEmpty
                              ? Text(
                                  data.time,
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.grey,
                                      fontSize: 9,
                                      color: Colors.grey),
                                )
                              : const SizedBox(),
                          trailing: Checkbox(
                            side: const BorderSide(
                                width: 1, color: Config.baseClr),
                            value: true,
                            onChanged: (value) {
                              context
                                  .read<TaskCubit>()
                                  .updateTask(task: data, status: "pending");
                            },
                          ),
                        );
                      },
                    );
            },
          )),
        ],
      ),
    );
  }
}
