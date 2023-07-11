import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constant/constants.user.dart';

class AuthenticationController {
  final String url = 'http://10.0.2.2:8000/api/';

  sendData(data, apiUrl) async{
      var fullURL = url + apiUrl;
      return await http.post(
        Uri.parse(fullURL),
        body: jsonEncode(data),
        headers: setHeader(),
    );
  }

  setHeader() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
  };

}
