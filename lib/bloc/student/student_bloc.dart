import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dummy_data.dart';
import '../../models/study_session.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial()) {
    on<LoadStudent>(_onLoadStudent);
    on<AddStudySession>(_onAddStudySession);
  }

  void _onLoadStudent(
    LoadStudent event,
    Emitter<StudentState> emit,
  ) {
    emit(StudentLoading());

    final student = getDummyStudent();

    emit(StudentLoaded(student));
  }

  void _onAddStudySession(
    AddStudySession event,
    Emitter<StudentState> emit,
  ) {
    if (state is! StudentLoaded) {
      return;
    }

    final currentState = state as StudentLoaded;
    final student = currentState.student;

    final StudySession newSession = event.session;

    student.studySessions.add(newSession);

    final enteredSubject = newSession.subject.trim().toLowerCase();

    for (final subject in student.subjects) {
      final subjectName = subject.subjectName.trim().toLowerCase();

      if (subjectName == enteredSubject) {
        subject.progressPercent =
            (subject.progressPercent + 0.05).clamp(0.0, 1.0);
        break;
      }
    }

    emit(StudentLoaded(student));
  }
}