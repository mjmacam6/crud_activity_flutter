import 'dart:convert';
import 'package:crud_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crud_flutter/student.dart';
import 'package:crud_flutter/update.dart'; // Import the update screen

class StudentDetail extends StatelessWidget {
  final Student student;

  const StudentDetail({super.key, required this.student});

  Future<void> _deleteStudent(BuildContext context) async {
    // Show loading screen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Perform delete operation
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/students/${student.id}'),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    if (response.statusCode == 200) {
      Navigator.pop  (
        context,true
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete student')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    //print('read page');
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${student.firstName}',
                style: const TextStyle(fontSize: 18)),
            Text('Last Name: ${student.lastName}',
                style: const TextStyle(fontSize: 18)),
            Text('Course: ${student.course}',
                style: const TextStyle(fontSize: 18)),
            Text('Year: ${student.year}', style: const TextStyle(fontSize: 18)),
            Text('Enrolled: ${student.enrolled ? 'Yes' : 'No'}',
                style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateStudent(student: student),
                      ),
                    );

                    if (result == true) {
                      // Trigger a refresh in the main list if an update occurred
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () => _deleteStudent(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
