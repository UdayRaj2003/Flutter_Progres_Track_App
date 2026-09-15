class ProgressReport {
  final String summary;
  final double overallProgress;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;
  final List<SubjectReport> subjectReports;

  ProgressReport({
    required this.summary,
    required this.overallProgress,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
    required this.subjectReports,
  });

  factory ProgressReport.fromJson(Map<String, dynamic> json) {
    return ProgressReport(
      summary: json['summary'] as String,
      overallProgress: (json['overallProgress'] as num).toDouble(),
      strengths: List<String>.from(json['strengths'] as List),
      weaknesses: List<String>.from(json['weaknesses'] as List),
      recommendations:
          List<String>.from(json['recommendations'] as List),
      subjectReports: (json['subjectReports'] as List)
          .map(
            (item) => SubjectReport.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class SubjectReport {
  final String subject;
  final double progress;
  final String status;
  final String recommendation;

  SubjectReport({
    required this.subject,
    required this.progress,
    required this.status,
    required this.recommendation,
  });

  factory SubjectReport.fromJson(Map<String, dynamic> json) {
    return SubjectReport(
      subject: json['subject'] as String,
      progress: (json['progress'] as num).toDouble(),
      status: json['status'] as String,
      recommendation: json['recommendation'] as String,
    );
  }
}