import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/stat_card.dart';
import '../widgets/subject_progress_card.dart';

/// Shows full details for one student: identity, weekly study time,
/// overall progress, and subject-wise performance.
///
/// Stateless for now — it just displays whatever [Student] it's given.
/// We'll revisit this once "Add Study Session" needs to update it live.
class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            student.studentClass,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Weekly Study Time',
                  value: '${student.weeklyStudyMinutes} min',
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Overall Progress',
                  value: '${(student.overallProgress * 100).round()}%',
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Subject-wise Performance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          for (final subject in student.subjects)
            SubjectProgressCard(subject: subject),
        ],
      ),
    );
  }
}