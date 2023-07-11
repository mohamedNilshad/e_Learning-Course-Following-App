import 'dart:convert';

import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/entities/course.entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PopularCourse extends StatefulWidget {
  const PopularCourse({super.key});

  @override
  State<PopularCourse> createState() => _PopularCourseState();
}

class _PopularCourseState extends State<PopularCourse> {
  var publicPath;
  List<Course> course = [];
  bool courseLoading = true;
  Map<String, dynamic>? cMapResponse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCallCourse();
  }

  Future apiCallCourse() async {
    setState(() {
      courseLoading = true;
    });

    // final Map<String, String> headers = {
    //   HttpHeaders.authorizationHeader: "Bearer ${}",
    //   HttpHeaders.contentTypeHeader: "application/json",
    // };
    http.Response response;
    response = await http.get(
      Uri.parse("${fullURL}getPopulerCourses"),
    );

    if (response.statusCode == 200) {
      setState(() {
        //course
        cMapResponse = jsonDecode(response.body);
        var res = cMapResponse?['data'] ?? [];
        course = res.map<Course>((v) => Course.fromJson(v)).toList();

        //public path
        publicPath = cMapResponse?['publicPath'];
        courseLoading = false;
      });
    } else {
      setState(() {
        courseLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                          onTap: () {
                            // ignore: avoid_print
                            print('Tapped a Container 1');
                          },
                          child: courseCard(),
                        ),
                  );

                }),
          ),
        )
        // GestureDetector(
        //       onTap: () {
        //         // ignore: avoid_print
        //         print('Tapped a Container 1');
        //       },
        //       child: courseCard(),
        //     ),

        // const SizedBox(width: 12),
      ],
    );
  }

  Widget courseCard() => Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          //borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Image.asset(
              'images/course1.jpg',
              width: 200,
              height: 100,
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Course Category',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ],
            ),
            Text(
              'loading',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
}
