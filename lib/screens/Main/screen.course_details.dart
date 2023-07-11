import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/entities/course.entity.dart';
import 'package:course_mate/main_layout.dart';
import 'package:course_mate/screens/Main/screen.course_content.dart';
import 'package:course_mate/screens/Payment/screen.payment.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic>? csMapResponse;

int courseID = -1;

class CourseDetail extends StatefulWidget {
  final cID;
  final bool buy;
  const CourseDetail(this.cID, this.buy, {Key? key}) : super(key: key);

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  String _cThumb = '';
  String _eduName = '';
  String _cName = '';
  String _cDesc = '';
  String _cPrice = '';
  int _courseId = -1;
  int _videoTot = 0;
  String _materials = 'No';
  String publicPath = '';
  bool isLoading = true;
  bool isFavorit = false;
  int favorite = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCallCourse();
  }

  List<Course> course = [];
  //fetch course details
  Future apiCallCourse() async {
    http.Response responseCourse;
    responseCourse =
        await http.get(Uri.parse("${fullURL}getCourse/${widget.cID}"));
    if (responseCourse.statusCode == 200) {
      setState(() {
        var response = json.decode(responseCourse.body);
        var res = response?['data'] ?? [];
        course = res.map<Course>((v) => Course.fromJson(v)).toList();

        //public path
        publicPath = response?['publicPath'];

        _cThumb = publicPath + course[0].courseThumbnail.toString();
        // _eduName = course[0].educatorId.toString();
        _courseId = course[0].id!;
        _cName = course[0].courseName.toString();
        _cDesc = course[0].courseDescription.toString();
        _cPrice = course[0].coursePrice.toString();
        _videoTot = 15;
        _materials = 'Yes';

        _eduName = (res[0]['educatorName'].toString());

        getFavorits(_courseId);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        debugPrint('abcd');
      });
    }
  }

  Future getFavorits(int cID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());

    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    try {
      Uri uri = Uri(
        scheme: urlScheme,
        host: urlHost,
        port: hostPort,
        path: "$basePath/favoriteValue",
      );

      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(headers);

      request.fields['uid'] = uID;
      request.fields['course_id'] = cID.toString();

      var response = await request.send();
      if (response.statusCode == 200) {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        setState(() {
          favorite = result['data']['like'];
        });
      } else {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        if (result != null) {
          setState(() {
            favorite = 0;
          });
        }
      }
    } catch (e) {
      // print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));

        setState(() {
          favorite = 0;
        });
    }
  }

  Future updateFavorite(int cID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());

    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    try {
      Uri uri = Uri(
        scheme: urlScheme,
        host: urlHost,
        port: hostPort,
        path: "$basePath/favorite",
      );

      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(headers);

      request.fields['uid'] = uID;
      request.fields['course_id'] = cID.toString();
      // print(uri.toString());
      var response = await request.send();
      if (response.statusCode == 200) {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        // debugPrint(result['data']['like'].toString());
        setState(() {
          favorite = result['data']['like'];
        });
      } else {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        if (result != null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(result["message"] ?? 'Something went wrong!')));
        }
        setState(() {
          favorite = 0;
        });
      }
    } catch (e) {
      // print(e.message);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));

      setState(() {
        isFavorit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        // title: const Text('Cour'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _cName.isNotEmpty ? _cName : 'loading',
            ),
            IconButton(
              icon: favorite == 0
                  ? const Icon(
                      Icons.favorite_outline,
                      color: Colors.white70,
                      size: 35,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 35,
                    ),
              onPressed: () {
                updateFavorite(_courseId);
              },
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: Visibility(
        visible: !isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text('Test'),
              CachedNetworkImage(
                width: double.infinity, // Specify the desired width
                // height: 400,
                alignment: Alignment.topCenter,
                key: UniqueKey(),
                imageUrl:
                    //'http://192.168.8.140:8000/images/thumb/1685332924.jpg', // Replace with the actual image URL
                    _cThumb.isNotEmpty
                        ? _cThumb
                        : 'http://192.168.8.140:8000/images/thumb/defaultThumb1.png',
                imageBuilder: (context, imageProvider) =>
                    Image(image: imageProvider),
                placeholder: (context, url) => const SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Container(
                width: double.infinity,
                color: Colors.blueGrey,
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Color(0xffCCCCCC),
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      // 'Seller Name ${widget.cID}',
                      _eduName.isNotEmpty ? _eduName : 'loading',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  // course.isNotEmpty ? course[0].courseName.toString() : '-',
                  _cName.isNotEmpty ? _cName : 'loading',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5.0, bottom: 10.0),
                child: ExpandableText(
                  //'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
                  _cDesc.isNotEmpty ? _cDesc : 'loading',
                  expandText: 'show more',
                  collapseText: 'show less',
                  maxLines: 2,
                  linkColor: Colors.blue,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                child: const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5.0),
                child: const Text(
                  'Course Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: const Text(
                  'Course Duration : 60 min',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Course Price : $_cPrice \$',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Total Video : $_videoTot',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Materials : $_materials',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),

              // Container(
              //   padding: const EdgeInsets.only(left: 5.0, bottom: 10.0),
              //   margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),
              //   color: Colors.blueAccent,
              //   height: 200,
              //   width: double.infinity,
              //   child: const Text('Trailer Video'),
              // ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                child: widget.buy
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CourseContent(widget.cID)),
                          );
                          // const Payment();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Set the desired background color
                        ),
                        child: const Text(
                          'Continue Watching',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Payment(widget.cID)),
                          );
                          // const Payment();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors
                                  .indigo), // Set the desired background color
                        ),
                        child: const Text(
                          'ENROLL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.only(left: 5.0),
                child: const Text(
                  'Similar Coursers',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // ignore: avoid_print
                              print('Tapped a Container 1');
                            },
                            child: courseCard(),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              // ignore: avoid_print
                              print('Tapped a Container 2');
                            },
                            child: courseCard(),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              // ignore: avoid_print
                              print('Tapped a Container 3');
                            },
                            child: courseCard(),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              // ignore: avoid_print
                              print('Tapped a Container 4');
                            },
                            child: courseCard(),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              )
            ],
          ),
        ),
      ),
    ));
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
            const Text(
              'Course Title',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
}
