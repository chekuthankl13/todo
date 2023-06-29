import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/config/config.dart';
import 'package:todo/database/hive_models/task_hive_model.dart';
import 'package:todo/logic/bloc_export.dart';
import 'package:todo/presentation/widgets/widgets.dart';
import 'package:todo/utils/utils.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskHiveModel task;
  const EditTaskScreen({required this.task, super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  ValueNotifier<String?> imgVal = ValueNotifier(null);
  late TextEditingController tCntr;

  late TextEditingController iCntr;

  late TextEditingController timeCntr;
  late TextEditingController dateCntr;
  late TextEditingController noteCntr;

  @override
  void initState() {
    tCntr = TextEditingController(text: widget.task.title);
    iCntr = TextEditingController();

    timeCntr = TextEditingController(text: widget.task.time);
    dateCntr = TextEditingController(text: widget.task.date);
    noteCntr = TextEditingController(text: widget.task.note);
    if (widget.task.img.isNotEmpty) {
      imgVal.value = widget.task.img;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            errorToast(context, error: state.error);
          }

          if (state is TaskEdited) {
            errorToast(context, error: "Task edited successfully !!..");
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return btmnavLoading(context);
          }

          return btmnav(context, txt: "Update Task", fun: () {
            context.read<TaskCubit>().editTask(
                title: tCntr.text.trim(),
                date: dateCntr.text.trim(),
                time: timeCntr.text.trim(),
                note: noteCntr.text.trim(),
                img: imgVal.value,
                id: widget.task.id);
          });
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: kToolbarHeight + 10,
                  width: sW(context),
                  color: Config.baseClr,
                  alignment: Alignment.center,
                  child: const Text(
                    "Edit Task",
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
////////////////////////////////

            Expanded(
                child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.all(8),
              children: [
                fields(txt: "Task Title", controller: tCntr),
                ValueListenableBuilder(
                  valueListenable: imgVal,
                  builder: (context, value, child) => value == null
                      ? fields(
                          txt: "Add Image",
                          controller: iCntr,
                          isread: true,
                          onTap: () async {
                            await getImage();
                          },
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
                                    onPressed: () {
                                      imgVal.value = null;
                                    },
                                    icon: Icon(Icons.clear))
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 200,
                              width: sW(context),
                              color: Config.white,
                              child: Image.file(
                                File(imgVal.value!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: fields(
                            txt: "Date",
                            controller: dateCntr,
                            onTap: () {
                              startDatePicker(context, dateCntr);
                            },
                            isread: true,
                            ic: Icons.calendar_month)),
                    spaceWidth(10),
                    Expanded(
                      child: fields(
                          txt: "Time",
                          onTap: () async {
                            startTimePicker(context, timeCntr);
                          },
                          controller: timeCntr,
                          isread: true,
                          ic: CupertinoIcons.time),
                    ),
                  ],
                ),
                fields(txt: "Note", controller: noteCntr, isNote: true),
              ],
            ))
          ],
        ),
      ),
    );
  }

  //// image pick function

  XFile? image;

  final ImagePicker picker = ImagePicker();

  Future getImage() async {
    var img = await picker.pickImage(source: ImageSource.gallery);

    // setState(() {
    imgVal.value = img!.path;
    // });
  }
}
