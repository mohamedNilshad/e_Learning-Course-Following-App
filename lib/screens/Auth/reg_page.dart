import 'dart:convert';
import 'dart:io';

import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/screens/Auth/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:course_mate/utils/config.dart';

import 'package:http/http.dart' as http;

import 'package:course_mate/components/registration_form.dart';
import 'package:course_mate/utils/text.dart';

class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  bool loading = false;

  register() async {
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
        path: "$basePath/register",
      );

      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(headers);

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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(result["message"] ?? 'Reg!')));
        }
        Navigator.of(context).pop();

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
      print(e.message);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));

      setState(() {
        loading = false;
      });
    } catch (e, t) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        loading = false;
      });

      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                    height: 50,
                  ),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    cursorColor: Config.primaryColor,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      labelText: 'Name',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: Config.primaryColor,
                    ),
                  ),
                  Config.spaceSmall,
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
                    width: 185,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                              register();
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
                          'Create Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const AuthPage();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
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
      ),
    );
  }
}
