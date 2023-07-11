import 'dart:convert';
import 'dart:io';

import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/main_layout.dart';
import 'package:course_mate/screens/ForgotPassword/verify_code.dart';
import 'package:course_mate/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final _emailController = TextEditingController();
  bool obsecurePass = true;
  bool loading = false;

  verifyEmail() async {
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
        path: "$basePath/verify_email",
      );

      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(headers);

      request.fields['email'] = _emailController.text.trim();
      var response = await request.send();
      if (response.statusCode == 200) {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);

        if (result != null) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyCode(_emailController.text.trim().toString()),
            ),
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
        ),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        labelText: 'Email',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.email_outlined),
                        prefixIconColor: primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 185,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () {
                                  verifyEmail();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
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
                              'Get Code',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
