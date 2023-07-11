import 'dart:convert';

import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/main_layout.dart';
import 'package:course_mate/screens/Search/screen.custom_searched.dart';
import 'package:course_mate/screens/Search/screen.searched_course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:course_mate/utils/config.dart';

import 'package:course_mate/entities/category.entity.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool courseLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCallCat();
  }

  List<Category> category = [];

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
      // debugPrint(category.toString());
      courseLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearch(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: courseLoaded,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: category.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(category[index].topic.toString()),
                        leading: const Icon(
                          Icons.search_off_sharp,
                          size: 25,
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          int catID = courseLoaded ? category[index].id! : -1;
                          // debugPrint(catID.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SerchedCourses(
                                  catID, category[index].topic.toString()),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  // List<String> allData = [
  //   'IT and Software',
  //   'Design',
  //   'Development',
  //   'Marketing',
  //   'Personal Development',
  //   'Business',
  //   'Photography',
  //   'Music'
  // ];
  List<String> allData = [
    '',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  //fetch all possible course Topics for Search
  Future apiGetTopic(String value) async {
    http.Response responseTopic;
    responseTopic = await http.get(Uri.parse("${fullURL}search/$value"));
    if (responseTopic.statusCode == 200) {
      var response = json.decode(responseTopic.body);

      String cName = '';
      String cDescription = '';
      for (var searchData in response['data']) {
        cName = searchData['courseName'].toString();
        cDescription = searchData['courseDescription'].toString();

        if (!allData.contains(cName)) {
          allData.add(searchData['courseName'].toString());
        }
        if (!allData.contains(cDescription)) {
          allData.add(searchData['courseDescription'].toString());
        }
      }
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
      // debugPrint(query.toLowerCase());
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              debugPrint(result.toString());
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
      if (query.isNotEmpty) {
        apiGetTopic(query.toLowerCase());
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              // debugPrint(result.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FilteredCourse(result.toString())),
              );
            },
          );
        });
  }
}
