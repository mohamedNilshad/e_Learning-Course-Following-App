import 'dart:convert';

import 'package:course_mate/Authentication/auth.dart';
import 'package:course_mate/screens/Auth/after_register.dart';
import 'package:course_mate/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'button.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  var result;

  _register() async{
    var data={
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passController.text.trim(),
    };



    var response = AuthenticationController().sendData(data, 'register');
    var body = await jsonDecode(response.body);
    result = body['success'];
    // if(body['success']){
    //   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
    //     return const AfterRegister();
    //   }));
    // }
  }

  bool obsecurePass = true;
  @override
  Widget build(BuildContext context) {
    return Form(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
              onPressed: () {
                _register();

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 7, 49, 115),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  // <-- Radius
                ),
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
          )


        ],
      ),
    );
  }
}
