import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_mate/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:course_mate/components/cards.dart';
import 'package:course_mate/components/popular_courses.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

var publicPath;

class _HomePageState extends State<HomePage> {
  var _userProfile;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  Future _getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());

    http.Response courseRes;

    courseRes = await http.get(Uri.parse("${fullURL}getUserData/$uID"));
    if (courseRes.statusCode == 200) {
      setState(() {
        var response = json.decode(courseRes.body);
        var res = response?['data']['userData'] ?? [];

        //public path
        publicPath = response?['data']['publicPath'];
        _userProfile = publicPath + res['profileImage'].toString();
        // debugPrint(_userProfile);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String formatter = DateFormat.yMMMMd('en_US').format(now);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    imageUrl: _userProfile ??
                        'gs://testvideo-a5e31.appspot.com/images/profile.png', // Replace with the actual image URL
                    placeholder: (context, url) => const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        )),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      color: Color(0xffCCCCCC),
                    ),
                  ),
                ),
              ),
              Text(
                formatter,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.cyan,
                  size: 35,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // backgroundColor: Config.primaryColor,
        backgroundColor: const Color.fromRGBO(244, 244, 244, 50),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            count += 1;
          });
          await Future.delayed(const Duration(microseconds: 800));
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  title: const Text(
                    'Popular Courses',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const PopularCourse(),
                // const SizedBox(height: 20),
                // Container(
                //   width: 500,
                //   height: 200,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(255, 4, 42, 214),
                //     //borderRadius: const BorderRadius.all(Radius.circular(10)),
                //     borderRadius: const BorderRadius.only(
                //       bottomRight: Radius.circular(30),
                //       topLeft: Radius.circular(30),
                //     ),
                //
                //     border: Border.all(color: Colors.blueAccent),
                //   ),
                // ),
                //
                // // CategoryCard(),
                //
                // const SizedBox(
                //   height: 20,
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        title: Text(
                          'New Courses',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TopCourses(
                        count: count,
                      ),
                    ],
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

//Search Code
//
// class CustomSearch extends SearchDelegate {
//   List<String> allData = [
//     'IT and Software',
//     'Design',
//     'Development',
//     'Marketing',
//     'Personal Development',
//     'Business',
//     'Photography',
//     'Music'
//   ];
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: const Icon(Icons.clear),
//       ),
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: const Icon(Icons.arrow_back),
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var item in allData) {
//       if (item.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(item);
//       }
//     }
//     return ListView.builder(
//         itemCount: matchQuery.length,
//         itemBuilder: (context, index) {
//           var result = matchQuery[index];
//           return ListTile(
//             title: Text(result),
//           );
//         });
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var item in allData) {
//       if (item.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(item);
//       }
//     }
//     return ListView.builder(
//         itemCount: matchQuery.length,
//         itemBuilder: (context, index) {
//           var result = matchQuery[index];
//           return ListTile(
//             title: Text(result),
//           );
//         });
//   }
// }
