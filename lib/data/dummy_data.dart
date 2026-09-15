import '../models/student.dart';
import '../models/subject_progress.dart';
import '../models/study_session.dart';

Student getDummyStudent() {
  final now = DateTime.now();

  return Student(
    name: 'Riya Sharma',
    studentClass: 'Class 8',
    overallProgress: 0.72,
    subjects: [
      SubjectProgress(subjectName: 'Mathematics', progressPercent: 0.80),
      SubjectProgress(subjectName: 'Science', progressPercent: 0.65),
      SubjectProgress(subjectName: 'English', progressPercent: 0.70),
      SubjectProgress(subjectName: 'History', progressPercent: 0.55),
    ],
    studySessions: [
      StudySession(
        subject: 'Mathematics',
        durationMinutes: 45,
        date: now,
        notes: 'Practiced algebra problems',
      ),
      StudySession(
        subject: 'Science',
        durationMinutes: 30,
        date: now.subtract(const Duration(days: 1)),
        notes: 'Read about photosynthesis',
      ),
      StudySession(
        subject: 'English',
        durationMinutes: 20,
        date: now.subtract(const Duration(days: 3)),
      ),
    ],
  );
}