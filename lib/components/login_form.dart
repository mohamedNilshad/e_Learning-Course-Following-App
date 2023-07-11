import 'package:course_mate/constant/constants.user.dart';
import 'package:course_mate/main_layout.dart';
import 'package:course_mate/screens/ForgotPassword/verify_email.dart';
import 'package:course_mate/utils/config.dart';
import 'package:course_mate/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:course_mate/constant/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  bool loading = false;

  Future<void> saveUserId(int userId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  login() async {
    setState(() {
      loading = true;
    });
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    try {
      Uri uri = Uri(
        scheme: urlScheme,
        host: urlHost,
        port: hostPort,
        path: "$basePath/login",
      );

      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(headers);

      request.fields['email'] = _emailController.text.trim();
      request.fields['password'] = _passController.text.trim();
      // print(uri.toString());
      var response = await request.send();
      if (response.statusCode == 200) {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        if (result != null) {
          if (!mounted) return;

          await saveUserId(result['data']['id']);
          saveAccessToken(result['token']).then((value) {
            if (value) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> MainLayout()), (route) => false);
            }
          });

          // Navigator.of(context).pop();
        }

        setState(() {
          loading = false;
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
          loading = false;
        });
      }
    } on SocketException catch (e) {
      // print(e.message);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));

      setState(() {
        loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        loading = false;
      });

      rethrow;
    }
  }

  Future<bool> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("[saveAccessToken] Saved Authorization.");
    return await prefs.setString('access_token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              } else {
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (emailValid) {
                  return null;
                } else {
                  return 'Please enter a valid email';
                }
              }
            },
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: Config.primaryColor,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obsecurePass = !obsecurePass;
                    });
                  },
                  icon: obsecurePass
                      ? const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.black38,
                        )
                      : const Icon(
                          Icons.visibility_outlined,
                          color: Config.primaryColor,
                        )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VerifyEmail()),
                  );
                },
                child: Text(
                  AppText.enText['forgot-password']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 185,
            height: 40,
            child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) login();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 49, 115),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    // <-- Radius
                  ),
                ),
                child: Visibility(
                  visible: !loading,
                  replacement: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
