import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/database/hive_helpers.dart';
import 'package:todo/database/hive_models/task_hive_model.dart';
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
        emit(TaskCreated());
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

        emit(TaskEdited());
      }
    } catch (e) {
      emit(TaskError(error: "some error occured ! ${e.toString()}"));
    }
  }
}
