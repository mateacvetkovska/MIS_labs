import 'package:flutter/material.dart';
import 'exam.dart';

class ExamPage extends StatefulWidget {
  final Function(Exam) addExam;

  const ExamPage({Key? key, required this.addExam}) : super(key: key);

  @override
  ExamPageState createState() => ExamPageState();
}

class ExamPageState extends State<ExamPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _classroomController = TextEditingController();
  final TextEditingController _professorController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? dateTimePicked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (dateTimePicked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (timePicked != null) {
        setState(() {
          _selectedDateTime = DateTime(
            dateTimePicked.year,
            dateTimePicked.month,
            dateTimePicked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _classroomController,
              decoration: const InputDecoration(
                labelText: 'Classroom',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _professorController,
              decoration: const InputDecoration(
                labelText: 'Professor',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.date_range, size: 24, color: Colors.blue),
                Text(
                  'Date: ${_selectedDateTime.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () => _selectDateTime(context),
                  child: const Text(
                    'Select Date & Time',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.access_time, size: 24, color: Colors.blue),
                Text(
                  'Time: ${_selectedDateTime.toLocal().toString().split(' ')[1].substring(0, 5)}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () => _selectDateTime(context),
                  child: const Text(
                    'Select Time',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final exam = Exam(
                    course: _subjectController.text,
                    timestamp: _selectedDateTime,
                    description: _descriptionController.text,
                    classroom: _classroomController.text,
                    professor: _professorController.text,
                  );
                  widget.addExam(exam);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add Exam',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
