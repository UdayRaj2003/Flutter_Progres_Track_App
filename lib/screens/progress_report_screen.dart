import 'package:flutter/material.dart';

import '../models/progress_report.dart';


class ProgressReportScreen extends StatelessWidget {
  final ProgressReport report;

  const ProgressReportScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Progress Report'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overall Summary
          Text(
            'Overall Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(report.summary),

          const SizedBox(height: 24),

          // Overall Progress
          Text(
            'Overall Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: report.overallProgress,
          ),
          const SizedBox(height: 8),
          Text(
            '${(report.overallProgress * 100).toStringAsFixed(0)}%',
          ),

          const SizedBox(height: 24),

          // Strengths
          Text(
            'Strengths',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          for (final strength in report.strengths)
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: Text(strength),
              contentPadding: EdgeInsets.zero,
            ),

          const SizedBox(height: 16),

          // Weaknesses
          Text(
            'Areas to Improve',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          for (final weakness in report.weaknesses)
            ListTile(
              leading: const Icon(Icons.warning_amber),
              title: Text(weakness),
              contentPadding: EdgeInsets.zero,
            ),

          const SizedBox(height: 16),

          // Recommendations
          Text(
            'Recommendations',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          for (final recommendation in report.recommendations)
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: Text(recommendation),
              contentPadding: EdgeInsets.zero,
            ),

          const SizedBox(height: 16),

          // Subject Reports
          Text(
            'Subject Reports',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          for (final subjectReport in report.subjectReports)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subjectReport.subject,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Progress: '
                      '${(subjectReport.progress * 100).toStringAsFixed(0)}%',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${subjectReport.status}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subjectReport.recommendation,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}