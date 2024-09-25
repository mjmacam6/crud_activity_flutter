import 'dart:convert';
import 'package:crud_flutter/main.dart';
import 'package:crud_flutter/read.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student.dart';

class UpdateStudent extends StatefulWidget {
  final Student student;

  const UpdateStudent({super.key, required this.student});

  @override
  _UpdateStudentState createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String course;
  late String year;
  late bool enrolled;
  bool _isLoading = false;

  final List<String> years = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Fifth Year',
  ];

  @override
  void initState() {
    super.initState();
    firstName = widget.student.firstName;
    lastName = widget.student.lastName;
    course = widget.student.course;
    year = widget.student.year;
    enrolled = widget.student.enrolled;
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final response = await http.put(
        //Uri.parse('http://127.0.0.1:8000/api/students/${widget.student.id}'),
        Uri.parse('http://10.0.2.2:8000/api/students/${widget.student.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'course': course,
          'year': year,
          'enrolled': enrolled,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        Navigator.pop(
          context,true
          
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update student: ${response.reasonPhrase}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('update student');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                onSaved: (value) => firstName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'First Name is required' : null,
              ),
              TextFormField(
                initialValue: lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => lastName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Last Name is required' : null,
              ),
              TextFormField(
                initialValue: course,
                decoration: const InputDecoration(labelText: 'Course'),
                onSaved: (value) => course = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Course is required' : null,
              ),
              DropdownButtonFormField<String>(
                value: year,
                onChanged: (newValue) {
                  setState(() {
                    year = newValue!;
                  });
                },
                items: years.map((year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              SwitchListTile(
                title: const Text('Enrolled'),
                value: enrolled,
                onChanged: (value) {
                  setState(() {
                    enrolled = value;
                  });
                },
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateStudent,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Update Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
