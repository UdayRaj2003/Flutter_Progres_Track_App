import '../../models/study_session.dart';

sealed class StudentEvent {}

class LoadStudent extends StudentEvent {}

class AddStudySession extends StudentEvent {
  final StudySession session;

  AddStudySession(this.session);
}