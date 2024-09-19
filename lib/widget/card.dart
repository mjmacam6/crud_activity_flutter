import 'package:crud_flutter/read.dart';
import 'package:flutter/material.dart';
import 'package:crud_flutter/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final Future<Null> Function()
      onCardTapped; 
  final VoidCallback onTap;// Added onCardTapped to the constructor

  const StudentCard({
    super.key,
    required this.onTap,
    required this.student,
    required this.onCardTapped, // Include this in the constructor
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.9, // Limit card width to 90% of screen width
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: InkWell(
          onTap: onTap, 
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'First Name: ${student.firstName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Last Name: ${student.lastName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Course: ${student.course}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Year: ${student.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Enrolled: ${student.enrolled ? 'Yes' : 'No'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
