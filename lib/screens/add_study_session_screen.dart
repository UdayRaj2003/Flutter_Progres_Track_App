import 'package:flutter/material.dart';

import '../core/utils/date_utils.dart';
import '../models/study_session.dart';
import '../core/logging/app_logger.dart';

/// A form for the parent to log a new study session.
///
/// StatefulWidget because this screen needs to remember what the user
/// has typed into each field as they type it, and needs to manage
/// controllers that must be created once and cleaned up once.
class AddStudySessionScreen extends StatefulWidget {
  const AddStudySessionScreen({super.key});

  @override
  State<AddStudySessionScreen> createState() => _AddStudySessionScreenState();
}

class _AddStudySessionScreenState extends State<AddStudySessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    appLogger.d('AddStudySessionScreen: initState — controllers created');
  }

  @override
  void dispose() {
    appLogger.d('AddStudySessionScreen: dispose — cleaning up controllers');
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newSession = StudySession(
        subject: _selectedSubject!,
        durationMinutes: int.parse(_durationController.text.trim()),
        date: _selectedDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      Navigator.pop(context, newSession);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Study Session')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedSubject,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Select a subject'),
              items: const [
                DropdownMenuItem(
                  value: 'Mathematics',
                  child: Text('Mathematics'),
                ),
                DropdownMenuItem(value: 'Science', child: Text('Science')),
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'History', child: Text('History')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a subject';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a duration';
                }
                final parsed = int.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid number of minutes';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(AppDateUtils.formatDate(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Save Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
