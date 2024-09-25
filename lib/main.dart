import 'dart:convert';
import 'package:crud_flutter/read.dart';
import 'package:crud_flutter/update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'widget/card.dart';
import 'package:crud_flutter/create.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Activity',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CRUD Activity'),
        ),
        body: const StudentList(),
      ),
    );
  }
}

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    final response = await http.get(
      //Uri.parse('http://127.0.0.1:8000/api/students'), //for chrome
      //Uri.parse('http://localhost:8000/api/students'), //for Mac
      Uri.parse('http://10.0.2.2:8000/api/students'),  //for android
    );

    if (response.statusCode == 200) {
      List<dynamic> studentsJson = json.decode(response.body);
      setState(() {
        students = studentsJson.map((json) => Student.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load student data');
    }
  }

  Future<void> _navigateToCreateStudentPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateStudent()),
    );

    if (result == true) {
      fetchStudentData();
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('main page');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return StudentCard(
                  student: students[index],
                  onCardTapped: () async {   
                  }, onTap: () async
                   { 
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentDetail(student: students[index]),
                      ),
                    );

                    if (result == true) {
                      // Refresh the list after updating or deleting
                      fetchStudentData();
                    }
                   },
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55),
        child: FloatingActionButton(
          onPressed: () => _navigateToCreateStudentPage(context),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
