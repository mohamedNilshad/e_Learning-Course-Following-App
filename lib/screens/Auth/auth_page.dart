import 'package:course_mate/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:course_mate/components/login_form.dart';
import 'package:course_mate/screens/Auth/reg_page.dart';
import 'package:course_mate/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/social_media_button.dart';
import '../../utils/text.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Future<String?> _getCurrentUserFuture;
  Future<String?> _getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  @override
  void initState() {
    _getCurrentUserFuture = _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    return FutureBuilder(
      future: _getCurrentUserFuture,
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data != '') {

            return const MainLayout();
          }
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          'COURSE',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 7, 49, 115),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'MATE',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(143, 170, 220, 50),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Learn without limits',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(127, 127, 127, 50),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    const LoginForm(),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Or',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const RegPage();
                        }));
                      },
                      child: const Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(47, 85, 151, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
