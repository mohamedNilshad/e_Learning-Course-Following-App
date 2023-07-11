import 'package:course_mate/screens/home_page.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatelessWidget {
  final courseID;
  const CoursePage(this.courseID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Course Details'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('$courseID'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('click'),
            )
          ],
        ),
      ),
    );
  }
}
