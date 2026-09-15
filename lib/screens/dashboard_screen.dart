import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/student/student_bloc.dart';
import '../bloc/student/student_event.dart';
import '../bloc/student/student_state.dart';

import '../models/study_session.dart';

import '../widgets/stat_card.dart';
import '../widgets/student_card.dart';
import '../widgets/subject_progress_card.dart';

import 'add_study_session_screen.dart';
import 'student_details_screen.dart';
import 'progress_report_screen.dart';

import '../bloc/progress_report/progress_report_bloc.dart';
import '../bloc/progress_report/progress_report_event.dart';
import '../bloc/progress_report/progress_report_state.dart';
import '../services/progress_report_service.dart';

/// The Parent Dashboard — the app's home screen.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard')),

      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          // -----------------------------------
          // Student is being loaded
          // -----------------------------------
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // -----------------------------------
          // Student loaded successfully
          // -----------------------------------
          if (state is StudentLoaded) {
            final student = state.student;
            return BlocProvider(
              create: (_) =>
                  ProgressReportBloc(reportService: ProgressReportService()),
              child: BlocListener<ProgressReportBloc, ProgressReportState>(
                listener: (context, reportState) {
                  if (reportState is ProgressReportLoaded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProgressReportScreen(report: reportState.report),
                      ),
                    );
                  }

                  if (reportState is ProgressReportError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(reportState.message)),
                    );
                  }
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Student card
                    StudentCard(
                      student: student,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentDetailsScreen(student: student),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Today's and weekly study time
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: "Today's Study Time",
                            value: '${student.todayStudyMinutes} min',
                            icon: Icons.timer,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: StatCard(
                            label: 'Weekly Study Time',
                            value: '${student.weeklyStudyMinutes} min',
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Add Study Session button
                    FilledButton.icon(
                      onPressed: () async {
                        final StudySession? newSession =
                            await Navigator.push<StudySession>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AddStudySessionScreen(),
                              ),
                            );

                        // User cancelled / pressed back
                        if (newSession == null) {
                          return;
                        }
                        if (!context.mounted) {
                          return;
                        }

                        // Send event to BLoC
                        context.read<StudentBloc>().add(
                          AddStudySession(newSession),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Study Session'),
                    ),
                    const SizedBox(height: 12),

                    BlocBuilder<ProgressReportBloc, ProgressReportState>(
                      builder: (context, reportState) {
                        final isLoading = reportState is ProgressReportLoading;

                        return ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<ProgressReportBloc>().add(
                                    GenerateReport(student),
                                  );
                                },
                          icon: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.auto_awesome),
                          label: Text(
                            isLoading
                                ? 'Generating Report...'
                                : 'Generate AI Report',
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Subject-wise progress
                    Text(
                      'Subject-wise Progress',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    for (final subject in student.subjects)
                      SubjectProgressCard(subject: subject),
                  ],
                ),
              ),
            );
          }

          // -----------------------------------
          // Error
          // -----------------------------------
          if (state is StudentError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          // -----------------------------------
          // Initial state
          // -----------------------------------
          return const Center(child: Text('Loading student...'));
        },
      ),
    );
  }
}
