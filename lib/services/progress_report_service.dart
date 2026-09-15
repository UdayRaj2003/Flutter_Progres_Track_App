import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/progress_report.dart';

class ProgressReportService {
  Future<ProgressReport> generateReport({
    required String studentName,
    required String studentClass,
    required double overallProgress,
    required List<Map<String, dynamic>> subjects,
    required List<Map<String, dynamic>> studySessions,
  }) async {
    final prompt = _buildPrompt(
      studentName: studentName,
      studentClass: studentClass,
      overallProgress: overallProgress,
      subjects: subjects,
      studySessions: studySessions,
    );

    final response = await http.post(
      Uri.parse('${AppConfig.openRouterBaseUrl}/chat/completions'),
      headers: {
        'Authorization': 'Bearer ${AppConfig.openRouterApiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': AppConfig.openRouterModel,

        'messages': [
          {
            'role': 'system',
            'content': '''
You are an educational progress analysis assistant.

Analyze the student's study data and create a useful,
encouraging progress report for the parent.
''',
          },
          {'role': 'user', 'content': prompt},
        ],

        // Structured JSON response
        'response_format': _buildResponseSchema(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenRouter request failed: ${response.statusCode}');
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    final content = responseData['choices'][0]['message']['content'] as String;

    final jsonStart = content.indexOf('{');
    final jsonEnd = content.lastIndexOf('}');

    if (jsonStart == -1 || jsonEnd == -1 || jsonStart > jsonEnd) {
      throw Exception('AI response did not contain a valid JSON report.');
    }

    final jsonText = content.substring(jsonStart, jsonEnd + 1);

    final reportJson = jsonDecode(jsonText) as Map<String, dynamic>;

    return ProgressReport.fromJson(reportJson);
  }

  Map<String, dynamic> _buildResponseSchema() {
    return {
      'type': 'json_schema',
      'json_schema': {
        'name': 'progress_report',
        'strict': true,
        'schema': {
          'type': 'object',
          'properties': {
            'summary': {'type': 'string'},
            'overallProgress': {'type': 'number'},
            'strengths': {
              'type': 'array',
              'items': {'type': 'string'},
            },
            'weaknesses': {
              'type': 'array',
              'items': {'type': 'string'},
            },
            'recommendations': {
              'type': 'array',
              'items': {'type': 'string'},
            },
            'subjectReports': {
              'type': 'array',
              'items': {
                'type': 'object',
                'properties': {
                  'subject': {'type': 'string'},
                  'progress': {'type': 'number'},
                  'status': {'type': 'string'},
                  'recommendation': {'type': 'string'},
                },
                'required': ['subject', 'progress', 'status', 'recommendation'],
                'additionalProperties': false,
              },
            },
          },
          'required': [
            'summary',
            'overallProgress',
            'strengths',
            'weaknesses',
            'recommendations',
            'subjectReports',
          ],
          'additionalProperties': false,
        },
      },
    };
  }

  String _buildPrompt({
    required String studentName,
    required String studentClass,
    required double overallProgress,
    required List<Map<String, dynamic>> subjects,
    required List<Map<String, dynamic>> studySessions,
  }) {
    return '''
Create a progress report for this student.

Student:
Name: $studentName
Class: $studentClass
Overall Progress: $overallProgress

Subjects:
${jsonEncode(subjects)}

Study Sessions:
${jsonEncode(studySessions)}

Analyze the student's performance and provide:

- A short overall summary.
- Strengths.
- Weaknesses or areas needing improvement.
- Practical recommendations for the parent.
- A report for every subject.

Keep the recommendations realistic, encouraging,
and based only on the provided student data.
''';
  }
}
