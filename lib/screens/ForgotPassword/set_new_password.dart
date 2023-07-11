import 'dart:convert';
import 'dart:io';

import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/main_layout.dart';
import 'package:course_mate/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SetNewPassword extends StatefulWidget {
  final String email;
  const SetNewPassword(this.email, {Key? key}) : super(key: key);

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _codeController = TextEditingController();
  final _passController = TextEditingController();

  bool obsecurePass = true;
  bool loading = false;

  resetPassword() async {
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
        path: "$basePath/set_new_password",
      );

      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(headers);

      request.fields['email'] = widget.email;
      request.fields['password'] = _passController.text.trim();

      // print(uri.toString());
      var response = await request.send();
      if (response.statusCode == 200) {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        if (result != null) {
          if (!mounted) return;
          // debugPrint('Verified');
              Navigator.of(context).pushNamed('/');
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
                      controller: _passController,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Config.primaryColor,
                      obscureText: obsecurePass,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'New Password',
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
                                  resetPassword();
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
                              'Reset',
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
