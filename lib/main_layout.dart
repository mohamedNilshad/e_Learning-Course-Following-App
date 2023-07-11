import 'package:course_mate/screens/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:course_mate/screens/profile_page.dart';
import 'package:course_mate/screens/search_page.dart';
import 'package:course_mate/screens/home_page.dart';
import 'package:flutter/cupertino.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}
const primaryColor = Color.fromARGB(255, 7, 49, 115);

class _MainLayoutState extends State<MainLayout> {
  // int currentPage = 0;
  // final PageController _page = PageController();

  int currentIndex = 0;

  List<Widget> screens = [
    HomePage(),
    SearchPage(),
    PaymentPage(),
    ProfilePage(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        currentIndex: currentIndex,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        unselectedIconTheme:  IconThemeData(
          color: Colors.grey,
        ),
        unselectedFontSize: 14,
        backgroundColor: primaryColor,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: screens[currentIndex],
    );
    //   Scaffold(
    //   body: PageView(
    //     controller: _page,
    //     onPageChanged: ((value) {
    //       setState(() {
    //         currentPage = value;
    //       });
    //     }),
    //     children: const <Widget>[
    //       HomePage(),
    //       SearchPage(),
    //       PaymentPage(),
    //       ProfilePage(),
    //     ],
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: currentPage,
    //     onTap: (page) {
    //       setState(() {
    //         currentPage = page;
    //         _page.jumpToPage(
    //           page,
    //         );
    //       });
    //     },
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         label: 'Home',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.search_outlined),
    //         label: 'Search',
    //
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.payment_outlined),
    //         label: 'Payments',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.person_2_outlined),
    //         label: 'Profile',
    //       ),
    //     ],
    //   ),
    // );
  }
}
