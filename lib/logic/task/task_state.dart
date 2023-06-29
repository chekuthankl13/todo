part of 'task_cubit.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskError extends TaskState {
  final String error;

  const TaskError({required this.error});

  @override
  List<Object> get props => [error];
}

class TaskCreated extends TaskState {}

class TaskUpdated extends TaskState {}

class TaskEdited extends TaskState {}

class TaskDeleted extends TaskState {}
