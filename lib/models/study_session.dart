class StudySession {
  final String subject;
  final int durationMinutes;
  final DateTime date;
  final String? notes;

  StudySession({
    required this.subject,
    required this.durationMinutes,
    required this.date,
    this.notes,
  });
}