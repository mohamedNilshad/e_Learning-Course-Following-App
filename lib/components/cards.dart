import 'dart:io';

import 'package:course_mate/entities/category.entity.dart';
import 'package:course_mate/entities/course.entity.dart';
import 'package:course_mate/screens/Main/screen.course.description.dart';
import 'package:course_mate/screens/Main/screen.course_details.dart';
import 'package:course_mate/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:course_mate/constant/constants.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map? catMapResponse;
List? catListResponse;

Map<String, dynamic>? cMapResponse;
Map<String, dynamic>? csMapResponse;
Map<String, dynamic>? userCourseMapResponse;
// List<dynamic>? cListResponse;
int _isCatSelected = -1;
int courseCount = 0;

//courses Card
class TopCourses extends StatefulWidget {
  final int count;
  const TopCourses({super.key, required this.count});

  @override
  State<TopCourses> createState() => _TopCoursesState();
}

class _TopCoursesState extends State<TopCourses> {
  int lastCount = 0;

  List<Course> course = [];
  List<Course> courseUser = [];
  bool courseLoading = true;

  List<Category> category = [];
  List<Course> courseDisplay = [];
  var publicPath;

  bool priceLoading = true;
  List<int> myCourse = [];

  final List<Map<String, dynamic>> gridMap = [
    {
      'rating': '4.6',
      'ratingCount': '60',
      'image': 'images/course1.jpg',
      'title': 'Photoshop CS6',
      'price': '\$15'
    },
    {
      'rating': '5.0',
      'ratingCount': '50',
      'image': 'images/course1.jpg',
      'title': 'Photoshop CS5',
      'price': '\$25'
    },
    {
      'rating': '4.0',
      'ratingCount': '80',
      'image': 'images/course1.jpg',
      'title': 'After Effects CS6',
      'price': '\$30'
    },
    {
      'rating': '4.2',
      'ratingCount': '98',
      'image': 'images/course1.jpg',
      'title': 'CorelDrew x 11',
      'price': '\$25'
    },
    {
      'rating': '4.3',
      'ratingCount': '40',
      'image': 'images/course1.jpg',
      'title': 'Microsoft Office 2016',
      'price': '\$16'
    },
    {
      'rating': '3.6',
      'ratingCount': '50',
      'image': 'images/course1.jpg',
      'title': 'Spoken English',
      'price': '\$10'
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCallCourse();
    apiCallCat();
    getUserCourse();
  }

  //sort Courses by topic
  Future sortCat(int id) async {
    http.Response response;
    response = await http.get(Uri.parse("${fullURL}sortCategory/$id"));

    if (response.statusCode == 200) {
      csMapResponse = json.decode(response.body);
      // cdListResponse = csMapResponse!['data'];
      // _isCatSelected = true;
      // print(csMapResponse);
    }
  }

  Future getUserCourse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());

    setState(() {
      priceLoading = true;
    });
    http.Response userResponse;
    userResponse = await http.get(
      Uri.parse("${fullURL}getMyCourse/$uID"),
    );
    if (userResponse.statusCode == 200) {
      setState(() {
        userCourseMapResponse = jsonDecode(userResponse.body);
        var uCourse = userCourseMapResponse?['data'] ?? [];
        courseUser = uCourse.map<Course>((v) => Course.fromJson(v)).toList();
        int value;
        for (int i = 0; i < courseUser.length; i++) {
          value = courseUser[i].id!;
          myCourse.add(value);
        }

        courseUser.isNotEmpty ? priceLoading = false : priceLoading = true;
      });
    }
  }

  //fetch all possible courses
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
      Uri.parse("${fullURL}allCourses"),
    );

    if (response.statusCode == 200) {
      setState(() {
        //course
        cMapResponse = jsonDecode(response.body);

        var res = cMapResponse?['data'] ?? [];

        course = res.map<Course>((v) => Course.fromJson(v)).toList();
        courseDisplay = course;
        courseCount = courseDisplay.length;

        //public path
        publicPath = cMapResponse?['publicPath'];
        getUserCourse();
        courseLoading = false;
      });
    } else {
      setState(() {
        courseLoading = false;
      });
    }
  }

  //fetch all possible course Categories
  Future apiCallCat() async {
    http.Response responseCat;
    responseCat = await http.get(Uri.parse("${fullURL}getCategory"));

    if (responseCat.statusCode == 200) {
      setState(() {
        var response = json.decode(responseCat.body);
        var res = response?['data'] ?? [];
        category = res.map<Category>((v) => Category.fromJson(v)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lastCount != widget.count) {
      apiCallCourse();
      apiCallCat();
      setState(() {
        lastCount = widget.count;
      });
    }
    print(courseDisplay.length);
    return Visibility(
      visible: !courseLoading,
      replacement: const Center(
        child: CircularProgressIndicator(),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10.0, left: 5.0),
              child: Text(
                "Results ($courseCount)",
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: category.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: ChoiceChip(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.blueAccent,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            label: const Text("All"),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            selected: _isCatSelected == -1,
                            backgroundColor: Colors.blueGrey[50],
                            onSelected: (isSelected) {
                              setState(() {
                                courseDisplay = course;
                                // _isCatSelected = isSelected;
                                courseCount = courseDisplay.length;
                                _isCatSelected = -1;
                              });
                            },
                            selectedColor: Colors.blueAccent,
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 10.0,
                          ),
                          child: ChoiceChip(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.blueAccent,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            label: Text(category[index - 1].topic ?? '-'),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            selected: _isCatSelected == index - 1,
                            backgroundColor: Colors.blueGrey[50],
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  courseDisplay = course
                                      .where((element) =>
                                          element.topicId ==
                                          category[index - 1].id)
                                      .toList();
                                  courseCount = courseDisplay.length;
                                } else {
                                  courseDisplay = course;
                                }
                                // _isCatSelected = isSelected;
                                _isCatSelected = isSelected ? index - 1 : -1;
                              });
                            },
                            selectedColor: Colors.blueAccent,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: courseDisplay.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: GestureDetector(
                  onTap: () {
                    bool buy = false;
                    if (!priceLoading) {
                      myCourse.contains(courseDisplay[index].id)
                          ? buy = true
                          : buy = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CourseDetail((courseDisplay[index].id), buy)),
                      );
                    }
                  },
                  child: Card(
                    elevation: 5,
                    clipBehavior: Clip.hardEdge,
                    color: const Color.fromARGB(255, 238, 240, 245),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150.0,
                          height: 120.0,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: CachedNetworkImage(
                              key: UniqueKey(),
                              imageUrl:
                                  '$publicPath${courseDisplay[index].courseThumbnail}', // Replace with the actual image URL
                              imageBuilder: (context, imageProvider) =>
                                  Image(image: imageProvider),
                              placeholder: (context, url) => const SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  )),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: RenderErrorBox.minimumWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    width: 120,
                                  ),
                                  myCourse.contains(courseDisplay[index].id) &&
                                          !priceLoading
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : Text(
                                          !priceLoading
                                              ? '${courseDisplay[index].coursePrice ?? '0'} \$'
                                              : '',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${gridMap.elementAt(0)['rating']}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 245, 208, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "(${gridMap.elementAt(0)['ratingCount']})",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 83, 83, 83),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              courseDisplay[index].courseName ?? '-',
                              overflow: TextOverflow
                                  .fade, // Truncate text with an ellipsis (...) if it overflows
                              maxLines: 1, // Limit the text to a single line
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TestForLoop extends StatefulWidget {
  const TestForLoop({super.key});

  @override
  State<TestForLoop> createState() => _TestForLoopState();
}

class _TestForLoopState extends State<TestForLoop> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 5; i++) ...[
          Text("$i"),
        ],
      ],
    );
  }
}
