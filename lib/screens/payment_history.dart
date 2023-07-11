import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/entities/course.entity.dart';
import 'package:course_mate/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

Map<String, dynamic>? cMapResponse;

class _PaymentPageState extends State<PaymentPage> {
  bool dataLoading = false;

  List<Course> course = [];
  bool courseLoading = true;
  bool courseIsEmpty = true;
  var publicPath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCallCourse();
  }

  Future apiCallCourse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());
    setState(() {
      courseLoading = true;
    });
    http.Response response;
    response = await http.get(Uri.parse("${fullURL}getMyCourse/$uID"));
    if (response.statusCode == 200) {
      setState(() {
        cMapResponse = jsonDecode(response.body);
        var res = cMapResponse?['data'] ?? [];
        course = res.map<Course>((v) => Course.fromJson(v)).toList();

        if (course.isNotEmpty) {
          // debugPrint('Not Empty');
          courseIsEmpty = false;
        } else {
          // debugPrint('Is Empty');
          courseIsEmpty = true;
        }

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payment History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Visibility(
            visible: !courseLoading,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: !dataLoading,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: Column(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: course.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            // send real elements in here
                            // setElement(
                            //     'http://192.168.8.140:8000/images/thumb/defaultThumb1.png',
                            //     'Course Title',
                            //     '17 June 2023',
                            //     '15'),
                            setElement(
                                course[index].courseThumbnail!,
                                course[index].courseName!,
                                '17 June 2023',
                                (course[index].coursePrice).toString()),
                            Container(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: const Divider(
                                color: Colors.black,
                                thickness: 1.0,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget setElement(
      String imgURL, String courseTitle, String purDate, String coursePrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          width: 60,
          height: 60,
          fit: BoxFit.cover,

          key: UniqueKey(),
          imageUrl: '$publicPath$imgURL', // Replace with the actual image URL
          imageBuilder: (context, imageProvider) => Image(image: imageProvider),
          placeholder: (context, url) => const SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              )),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),

        // Container(
        //   width: 60,
        //   height: 60,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     image: DecorationImage(
        //       image: NetworkImage(
        //         imgURL,
        //       ),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                courseTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                width: 150,
              ),
              Text(
                purDate,
                style: const TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$coursePrice \$',
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 30,
          ),
        ),
      ],
    );
  }
}
