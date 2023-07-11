import 'package:flutter/material.dart';

class CourseGrid extends StatefulWidget {
  const CourseGrid({super.key});

  @override
  State<CourseGrid> createState() => _CourseGridState();
}

class _CourseGridState extends State<CourseGrid> {
  final List<Map<String, dynamic>> gridMap = [
    {
      'rating': '4.6',
      'ratingCount': '60',
      'image': 'images/course1.jpg',
      'title': 'Photoshop CS6',
      'price': '\$15'
    },
    {
      'rating': '5.0',
      'ratingCount': '50',
      'image': 'images/course1.jpg',
      'title': 'Photoshop CS5',
      'price': '\$25'
    },
    {
      'rating': '4.0',
      'ratingCount': '80',
      'image': 'images/course1.jpg',
      'title': 'After Effects CS6',
      'price': '\$30'
    },
    {
      'rating': '4.2',
      'ratingCount': '98',
      'image': 'images/course1.jpg',
      'title': 'CorelDrew x 11',
      'price': '\$25'
    },
    {
      'rating' : '4.3',
      'ratingCount' : '40',
      'image': 'images/course1.jpg',
      'title' : 'Microsoft Office 2016',
      'price':'\$16'
    },
    {
      'rating' : '3.6',
      'ratingCount' : '50',
      'image': 'images/course1.jpg',
      'title' : 'Spoken English',
      'price':'\$10'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
