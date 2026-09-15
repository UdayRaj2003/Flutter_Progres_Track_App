import '../../models/student.dart';

sealed class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final Student student;

  StudentLoaded(this.student);
}

class StudentError extends StudentState {
  final String message;

  StudentError(this.message);
}