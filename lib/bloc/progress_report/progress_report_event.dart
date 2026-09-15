
import '../../models/student.dart';

sealed class ProgressReportEvent {}

class GenerateReport extends ProgressReportEvent {
  final Student student;

  GenerateReport(this.student);
}