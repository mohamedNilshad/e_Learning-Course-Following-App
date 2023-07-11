import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/main_layout.dart';
import 'package:course_mate/screens/Auth/auth_page.dart';
import 'package:course_mate/screens/Profile/screen.about_us.dart';
import 'package:course_mate/screens/Profile/screen.account.dart';
import 'package:course_mate/screens/Profile/screen.favorites.dart';
import 'package:course_mate/screens/Profile/screen.my_courses.dart';
import 'package:course_mate/screens/Profile/screen.profile_update.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _userProfile = 'gs://testvideo-a5e31.appspot.com/images/profile.png';
  var _userName;
  bool isProLoading = true;
  var publicPath;
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
        _userName = res['user_name'].toString();
        // debugPrint(_userProfile);
        isProLoading = false;
      });
    } else {
      setState(() {
        isProLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                const SizedBox(
                  width: 10,
                ),
                Text(
                  _userName ?? 'Loading',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------------------------General---------------------->
                  getHeader('General'),

                  myOption('My Courses', Icons.save, 0),
                  getDivider(),

                  myOption('Favorite List', Icons.favorite_outline, 1),

                  //------------------------------------------------Settings--------------------->
                  getHeader('Settings'),

                  myOption('Account', Icons.manage_accounts_outlined, 2),
                  getDivider(),

                  myOption('My Profile', Icons.person, 3),
                  // getDivider(),

                  //------------------------------------------------Help & Support-------------->
                  getHeader('Help & Support'),

                  myOption('About', Icons.manage_accounts_outlined, 4),
                  getDivider(),
                  myOption('Logout', Icons.logout, -1),
                  getDivider(),
                ],
              ),
            ],
          ),
        ));
  }

  Future<bool> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('access_token');
  }

  Widget myOption(String optionName, IconData iconName, int page) {
    return ListTile(
      title: Text(
        optionName,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(
        iconName,
        size: 30,
        color: Colors.grey,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        // debugPrint('Working');
        switch (page) {
          case -1:
            removeToken().then((value) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> AuthPage()), (route) => false);

            });
            break;

          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyCourse()),
            );
            break;

          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteCourse()),
            );
            break;

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyAccount()),
            );
            break;

          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadProfile()),
            );
            break;

          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUs()),
            );
            break;

          default:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUs()),
            );
        }
      },
    );

    //   Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     SizedBox(
    //       width: 50,
    //       height: 50,
    //       child: Icon(
    //         iconName,
    //         size: 30,
    //         color: Colors.grey,
    //       ),
    //     ),
    //     Text(
    //       optionName,
    //       style: const TextStyle(
    //         fontSize: 18,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     const SizedBox(
    //       width: 150,
    //     ),
    //     const SizedBox(
    //       width: 50,
    //       height: 50,
    //       child: Icon(
    //         Icons.arrow_forward_ios_sharp,
    //         size: 30,
    //         color: Colors.grey,
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget getDivider() {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: const Divider(
        thickness: 1.0,
      ),
    );
  }

  Widget getHeader(String headName) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black12,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        headName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
