import 'subject_progress.dart';
import 'study_session.dart';

class Student {
  final String name;
  final String studentClass;
  final double overallProgress;
  final List<SubjectProgress> subjects;
  final List<StudySession> studySessions;

  Student({
    required this.name,
    required this.studentClass,
    required this.overallProgress,
    required this.subjects,
    required this.studySessions,
  });

  int get todayStudyMinutes {
    final now = DateTime.now();
    return studySessions
        .where((session) =>
            session.date.year == now.year &&
            session.date.month == now.month &&
            session.date.day == now.day)
        .fold(0, (total, session) => total + session.durationMinutes);
  }

  int get weeklyStudyMinutes {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return studySessions
        .where((session) => session.date.isAfter(weekAgo))
        .fold(0, (total, session) => total + session.durationMinutes);
  }
}