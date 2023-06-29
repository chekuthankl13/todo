import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/config/config.dart';
import 'package:todo/database/hive_helpers.dart';
import 'package:todo/database/hive_models/task_hive_model.dart';
import 'package:todo/logic/bloc_export.dart';
import 'package:todo/presentation/task/edit_task_screen.dart';
import 'package:todo/presentation/widgets/widgets.dart';
import 'package:todo/utils/utils.dart';

class TaskViewScreen extends StatefulWidget {
  final TaskHiveModel task;
  const TaskViewScreen({required this.task, super.key});

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController tCntr =
        TextEditingController(text: widget.task.title);
    final TextEditingController iCntr = TextEditingController();

    final TextEditingController timeCntr =
        TextEditingController(text: widget.task.time);
    final TextEditingController dateCntr =
        TextEditingController(text: widget.task.date);
    final TextEditingController noteCntr =
        TextEditingController(text: widget.task.note);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
//////// header
            Stack(
              children: [
                Container(
                  height: kToolbarHeight + 10,
                  width: sW(context),
                  color: Config.baseClr,
                  alignment: Alignment.center,
                  child: const Text(
                    "Task",
                    style: TextStyle(color: Config.white),
                  ),
                ),
                Positioned(
                  left: -35,
                  top: -20,
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
                Positioned(
                  right: 10,
                  // top: 20,
                  child: Row(
                    children: [
                      widget.task.status == "pending"
                          ? IconButton(
                              onPressed: () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => TaskCubit(),
                                    child: EditTaskScreen(task: widget.task),
                                  ),
                                ));
                              },
                              icon: const Icon(
                                CupertinoIcons.pencil,
                                color: Config.white,
                                size: 25,
                              ),
                            )
                          : const SizedBox(),
                      IconButton(
                        onPressed: () async {
                          await delete(context, widget.task.id);
                        },
                        icon: const Icon(
                          CupertinoIcons.delete,
                          color: Config.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      navigatorKey.currentState!.pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Config.white),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
/************************** */
            Expanded(
                child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.all(8),
              children: [
                fields(txt: "Task Title", controller: tCntr, isread: true),
                widget.task.img.isEmpty
                    ? fields(
                        txt: "Add Image",
                        controller: iCntr,
                        isread: true,
                        ic: CupertinoIcons.photo)
                    : Column(
                        children: [
                          spaceHeight(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Add Image",
                                style: TextStyle(
                                    color: Config.txtClr,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.clear))
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 200,
                            width: sW(context),
                            color: Config.white,
                            child: Image.file(
                              File(widget.task.img),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                Row(
                  children: [
                    Expanded(
                        child: fields(
                            txt: "Date",
                            controller: dateCntr,
                            isread: true,
                            ic: Icons.calendar_month)),
                    spaceWidth(10),
                    Expanded(
                      child: fields(
                          txt: "Time",
                          controller: timeCntr,
                          isread: true,
                          ic: CupertinoIcons.time),
                    ),
                  ],
                ),
                fields(
                    txt: "Note",
                    controller: noteCntr,
                    isNote: true,
                    isread: true),
              ],
            ))
          ],
        ),
      ),
    );
  }

////// delete

  Future<dynamic> delete(BuildContext context, id) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: const Text(
          "Delete",
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: const Text(
          "Are you sure ,you want to delete  this Task ?",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () {
              navigatorKey.currentState!.pop();
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text(
              "No",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () async {
              await HIveHelpers().deleteTask(id: id).then((value) {
                navigatorKey.currentState!.pop();
                navigatorKey.currentState!.pop();

                errorToast(context, error: "Task deleted successfully !!");
              });
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 13, color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
