import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/database/hive_models/task_hive_model.dart';

class HIveHelpers {
  static const task = 'task';

  static Box<TaskHiveModel> taskBox = Hive.box<TaskHiveModel>(task);

  createTask({required TaskHiveModel task}) async {
    await taskBox.put(task.id, task);
    log("task inserted to db..");
  }

  Box<TaskHiveModel> getTask() {
    return taskBox;
  }

  updateTask({required TaskHiveModel task}) async {
    await taskBox.delete(task.id);
    await taskBox.put(task.id, task);

    log("task updated at id -${task.id}");
  }

  editTask({required TaskHiveModel task}) async {
    await taskBox.delete(task.id);
    await taskBox.put(task.id, task);
    log("task edited at id -${task.id}");
  }

  Future deleteTask({required id}) async {
    await taskBox.delete(id);

    log("task deleted at id -$id");
  }
}
