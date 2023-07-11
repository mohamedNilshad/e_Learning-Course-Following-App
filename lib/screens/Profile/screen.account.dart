import 'dart:convert';
import 'dart:io';

import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/constant/constants.user.dart';
import 'package:course_mate/main_layout.dart';
import 'package:course_mate/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

Map<String, dynamic>? uMapResponse;

class _MyAccountState extends State<MyAccount> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passController = TextEditingController();

  bool obsecurePass = true;
  bool userLoading = false;
  bool isUpdating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());
    setState(() {
      userLoading = true;
    });
    http.Response response;
    response = await http.get(Uri.parse("${fullURL}getUserData/$uID"));
    if (response.statusCode == 200) {
      setState(() {
        uMapResponse = jsonDecode(response.body);
        var uRes = uMapResponse?['data'] ?? [];
        // debugPrint(uRes.toString());
        _emailController.text = uRes['userData']['user_email'];
        _nameController.text = uRes['userData']['user_name'];
        userLoading = false;
      });
    }
  }

  void updateData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());

    setState(() {
      isUpdating = true;
    });

    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    try {
      Uri uri = Uri(
        scheme: urlScheme,
        host: urlHost,
        port: hostPort,
        path: "$basePath/updateUserProfile",
      );

      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(headers);

      request.fields['id'] = uID;
      request.fields['name'] = _nameController.text.trim();
      request.fields['email'] = _emailController.text.trim();
      request.fields['password'] = _passController.text.trim();

      // print(uri.toString());
      var response = await request.send();
      if (response.statusCode == 200) {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        if (result != null) {
          if (!mounted) return;

          setState(() {
            _passController.text='';
            isUpdating = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(result["message"] ?? 'Updated!')));
          // debugPrint('updated');
        }
      } else {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        if (result != null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(result["message"] ?? 'Something went wrong!'),
            ),
          );

          setState(() {
            isUpdating = false;
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Visibility(
          visible: !userLoading,
          replacement: const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        labelText: 'Name',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: primaryColor,
                      ),
                    ),
                    Config.spaceSmall,
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Config.primaryColor,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        labelText: 'Email',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.email_outlined),
                        prefixIconColor: Config.primaryColor,
                      ),
                    ),
                    Config.spaceSmall,
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passController,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Config.primaryColor,
                      obscureText: obsecurePass,
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
                    Config.spaceSmall,
                    SizedBox(
                      width: 125,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: isUpdating
                            ? null
                            : () {
                                updateData();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 7, 115, 68),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            // <-- Radius
                          ),
                        ),
                        child: !isUpdating
                            ? const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
