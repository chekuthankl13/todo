import 'package:hive/hive.dart';

part 'task_hive_model.g.dart';

@HiveType(typeId: 0)
class TaskHiveModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String date;
  @HiveField(2)
  final String time;
  @HiveField(3)
  final String img;
  @HiveField(4)
  final String note;
  @HiveField(5)
  final String status;
  @HiveField(6)
  final String id;

  TaskHiveModel(
      {required this.title,
      required this.date,
      required this.id,
      required this.time,
      required this.status,
      required this.img,
      required this.note});
}
