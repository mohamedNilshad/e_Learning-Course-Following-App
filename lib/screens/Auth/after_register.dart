import 'package:flutter/material.dart';

class AfterRegister extends StatefulWidget {
  const AfterRegister({super.key});

  @override
  State<AfterRegister> createState() => _AfterRegisterState();
}
String AppName = 'Course Mate';
class _AfterRegisterState extends State<AfterRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                 Text(
                  AppName,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.blueAccent,

                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Are You an ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const Student();
                      }));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Student',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const Worker();
                      }));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Worker',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Other',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//For Student
class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                 Text(
                  AppName,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.blueAccent,

                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'What is your Education Level ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'School Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'High School',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Diploma',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Degree',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//for worker
class Worker extends StatefulWidget {
  const Worker({super.key});

  @override
  State<Worker> createState() => _WorkerState();
}

class _WorkerState extends State<Worker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 8.0,
            right: 8.0,
            ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  AppName,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'What is your field of work ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Programming',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Electronic',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Electrical',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Graphic Design',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Medical',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Mechanical',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 400.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('main');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                      side: const BorderSide(width: 1, color: Colors.black),
                    ),
                    child: const Text(
                      'Other',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
