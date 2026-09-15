import '../../models/progress_report.dart';

sealed class ProgressReportState {}

class ProgressReportInitial extends ProgressReportState {}

class ProgressReportLoading extends ProgressReportState {}

class ProgressReportLoaded extends ProgressReportState {
  final ProgressReport report;

  ProgressReportLoaded(this.report);
}

class ProgressReportError extends ProgressReportState {
  final String message;

  ProgressReportError(this.message);
}