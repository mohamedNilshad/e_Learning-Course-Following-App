import 'package:course_mate/main_layout.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  AboutUs({Key? key}) : super(key: key);

  final String intro = 'Course Mate is a groundbreaking mobile application '
      'designed to revolutionize the way learners access and '
      'engage with educational content. With Course Mate, '
      'users can conveniently follow courses from the '
      'comfort of their own space, enabling them to '
      'learn at their own pace and on their own schedule. '
      'This innovative app combines video-based courses '
      'with comprehensive course materials, making it a one-stop '
      'solution for all your educational needs.';

  final List<String> keyFeatures = [
    '1. Extensive Course Library: Course Mate offers a vast collection of '
        'courses across various subjects and disciplines. From academic '
        'subjects like math, science, and literature to professional skills '
        'such as programming, marketing, and design, there is a wide range of '
        'courses to cater to every learner\'s interests and aspirations.',
    '2. Video-Based Learning: The courses in Course Mate are presented in video '
        'format, ensuring an engaging and interactive learning experience. '
        'Users can watch high-quality video lectures delivered by expert instructors, '
        'allowing them to grasp concepts effectively and visualize complex topics with ease.',
    '3. Comprehensive Course Materials: Alongside video lectures, Course Mate provides course '
        'materials such as lecture notes, PDFs, quizzes, and assignments. '
        'These materials supplement the video content, helping users reinforce their learning, '
        'test their understanding, and track their progress throughout the course.',
    '4. User-Friendly Interface: The app boasts a user-friendly interface that makes navigation '
        'and course discovery effortless. Users can easily search for specific courses, '
        'browse through categories, and access their enrolled courses from a neatly organized '
        'dashboard. Additionally, personalized recommendations based on user preferences and '
        'learning history enhance the user experience.',
    '5. Account Settings and Notifications: Course Mate allows users to update their account settings, '
        'including personal information, notification preferences, and communication options. '
        'This ensures that users stay informed about course updates, new releases, and other '
        'relevant announcements, tailored to their specific needs and interests.',
    '6. Secure Payment Integration: Course Mate integrates a secure payment gateway, '
        'enabling users to make payments directly within the app. This eliminates the '
        'hassle of external transactions and provides a seamless and trustworthy payment '
        'process, ensuring the privacy and security of users\' financial information.',
  ];

  final String outro =
      'Course Mate aims to empower learners worldwide by providing them with '
      'a convenient and accessible platform to enhance their education. '
      'Whether you are a student looking for supplementary learning materials or a professional '
      'seeking to upskill, Course Mate offers a comprehensive learning solution that fits your '
      'individual needs.';

  final String ending =
      'Download Course Mate today and embark on a transformative learning journey, right from the palm of your hand!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Introducing Course Mate: Learn without limits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    intro,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Key Features:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: keyFeatures.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            keyFeatures[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    outro,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ending,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: primaryColor
                    ),
                    textAlign: TextAlign.justify,
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
