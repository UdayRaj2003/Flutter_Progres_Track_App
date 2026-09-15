import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/progress_report_service.dart';
import 'progress_report_event.dart';
import 'progress_report_state.dart'; 

class ProgressReportBloc
    extends Bloc<ProgressReportEvent, ProgressReportState> {
  final ProgressReportService reportService;
  ProgressReportBloc({required this.reportService})
    : super(ProgressReportInitial()) {
    on<GenerateReport>(_onGenerateReport);
  }

  Future<void> _onGenerateReport(
    GenerateReport event,
    Emitter<ProgressReportState> emit,
  ) async {
    emit(ProgressReportLoading());

    // AI report generation will be added here later.
    try {
      final student = event.student;
      final report = await reportService.generateReport(
        studentName: student.name,
        studentClass: student.studentClass,
        overallProgress: student.overallProgress,
        subjects: student.subjects.map((subject) {
          return {
            'subject': subject.subjectName,
            'progress': subject.progressPercent,
          };
        }).toList(),
        studySessions: student.studySessions.map((session) {
          return {
            'subject': session.subject,
            'durationMinutes': session.durationMinutes,
            'date': session.date.toIso8601String(),
            'notes': session.notes,
          };
        }).toList(),
      );

      emit(ProgressReportLoaded(report));
    } catch (error) {
      emit(ProgressReportError(error.toString()));
    }
  }
}
