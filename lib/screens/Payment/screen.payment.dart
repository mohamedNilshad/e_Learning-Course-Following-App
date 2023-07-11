import 'dart:convert';
import 'dart:io';

import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/entities/course.entity.dart';
import 'package:course_mate/main_layout.dart';
import 'package:course_mate/screens/Main/screen.course_content.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  final ncID;
  const Payment(this.ncID, {Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpController = TextEditingController();
  final _cardCvvController = TextEditingController();
  List<Course> course = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourse();
  }

  Future getCourse() async {
    http.Response responseCourse;
    responseCourse =
        await http.get(Uri.parse("${fullURL}getCourse/${widget.ncID}"));
    if (responseCourse.statusCode == 200) {
      setState(() {
        var response = json.decode(responseCourse.body);
        var res = response?['data'] ?? [];
        course = res.map<Course>((v) => Course.fromJson(v)).toList();
      });
    } else {
      setState(() {
        debugPrint('error in receiving data');
      });
    }
  }

  newPayment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      Uri uri = Uri(
        scheme: urlScheme,
        host: urlHost,
        port: hostPort,
        path: "$basePath/deposit",
      );

      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(headers);

      request.fields['holderName'] = _nameController.text.trim();
      request.fields['cardNumber'] = _cardNumberController.text.trim();
      request.fields['expDate'] = _cardExpController.text.trim();
      request.fields['cvvNumber'] = _cardCvvController.text.trim();

      request.fields['amount'] = course[0].coursePrice.toString();
      request.fields['educator_id'] = course[0].educatorId.toString();
      request.fields['course_id'] = (widget.ncID).toString();
      request.fields['user_id'] = uID;

      var response = await request.send();
      if (response.statusCode == 200) {
        var res = await http.Response.fromStream(response);
        var result = json.decode(res.body);
        debugPrint(result.toString());
        if (result != null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(result["message"] ?? 'Reg!')));
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseContent(widget.ncID)),
        );
      } else {
        debugPrint('error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Page'),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Card Holder\'s Name',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    cursorColor: primaryColor,
                    decoration: const InputDecoration(
                      hintText: 'Card Holder\'s Name',
                      labelText: 'Name',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Card Number',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    cursorColor: primaryColor,
                    decoration: const InputDecoration(
                      hintText: 'Card Number',
                      labelText: 'card number',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.credit_card_rounded),
                      prefixIconColor: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Card Number',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Card Number',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextFormField(
                          controller: _cardExpController,
                          keyboardType: TextInputType.text,
                          cursorColor: primaryColor,
                          decoration: const InputDecoration(
                            hintText: 'Exp',
                            labelText: 'Exp',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.date_range),
                            prefixIconColor: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 120,
                        child: TextFormField(
                          controller: _cardCvvController,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: const InputDecoration(
                            hintText: 'cvv',
                            labelText: 'cvv',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.numbers),
                            prefixIconColor: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      newPayment();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.indigo), // Set the desired background color
                    ),
                    child: const Text(
                      'Pay',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
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
