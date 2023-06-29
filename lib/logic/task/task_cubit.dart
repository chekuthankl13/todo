import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/database/hive_helpers.dart';
import 'package:todo/database/hive_models/task_hive_model.dart';
import 'package:todo/notification/notification.dart';
import 'package:uuid/uuid.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  createTask(
      {required String title,
      required String? date,
      required String? time,
      required String note,
      required String? img}) async {
    try {
      emit(TaskLoading());

      if (title.isEmpty || note.isEmpty) {
        emit(const TaskError(
            error: "Title field and note field are required.. "));
      } else {
        var uuid = const Uuid().v1();
        TaskHiveModel task = TaskHiveModel(
            id: uuid,
            title: title,
            date: date ?? "",
            time: time ?? "",
            status: "pending",
            img: img ?? "",
            note: note);

        await HIveHelpers().createTask(task: task);

        if (time!.isNotEmpty && date!.isNotEmpty) {
          int year = int.parse(date.split("-")[0]);
          int month = int.parse(date.split("-")[1]);
          int day = int.parse(date.split("-")[2]);

          // int hour = int.parse(time.split(":")[0]);
          // int minutes = int.parse(time.split(":")[1].split(" ")[0]);

          // Split the time into hour and minute components
          List<String> components = time.split(':');
          int hour = int.parse(components[0]);
          int minutes = int.parse(components[1].split(' ')[0]);

// Determine whether it's AM or PM
          bool isPM = components[1].contains('PM');

// Convert the hour component to the 24-hour format
          if (isPM && hour != 12) {
            hour += 12;
          } else if (!isPM && hour == 12) {
            hour = 0;
          }

          await NotificationServices().scheduleNotification(
              year: year,
              month: month,
              day: day,
              hour: hour,
              minutes: minutes,
              title: title);
          emit(TaskCreated());
        } else {
          emit(TaskCreated());
        }
      }
    } catch (e) {
      emit(TaskError(error: "some error occured ! ${e.toString()}"));
    }
  }

  updateTask({required TaskHiveModel task, required status}) {
    TaskHiveModel updatedTask = TaskHiveModel(
        id: task.id,
        title: task.title,
        date: task.date,
        time: task.time,
        status: status,
        img: task.img,
        note: task.note);

    HIveHelpers().updateTask(task: updatedTask);
  }

  ///////// edit

  editTask(
      {required String title,
      required String? date,
      required String? time,
      required String note,
      required String? img,
      required String id}) async {
    try {
      emit(TaskLoading());
      if (title.isEmpty || note.isEmpty) {
        emit(const TaskError(
            error: "Title field and note field are required.. "));
      } else {
        TaskHiveModel task = TaskHiveModel(
            id: id,
            title: title,
            date: date ?? "",
            time: time ?? "",
            status: "pending",
            img: img ?? "",
            note: note);

        HIveHelpers().editTask(task: task);
        if (time!.isNotEmpty && date!.isNotEmpty) {
          int year = int.parse(date.split("-")[0]);
          int month = int.parse(date.split("-")[1]);
          int day = int.parse(date.split("-")[2]);

          // Split the time into hour and minute components
          List<String> components = time.split(':');
          int hour = int.parse(components[0]);
          int minutes = int.parse(components[1].split(' ')[0]);

// Determine whether it's AM or PM
          bool isPM = components[1].contains('PM');

// Convert the hour component to the 24-hour format
          if (isPM && hour != 12) {
            hour += 12;
          } else if (!isPM && hour == 12) {
            hour = 0;
          }

          await NotificationServices().scheduleNotification(
              year: year,
              month: month,
              day: day,
              hour: hour,
              minutes: minutes,
              title: title);
          emit(TaskEdited());
        } else {
          emit(TaskEdited());
        }
      }
    } catch (e) {
      emit(TaskError(error: "some error occured ! ${e.toString()}"));
    }
  }
}
