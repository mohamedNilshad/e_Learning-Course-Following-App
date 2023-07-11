import 'package:flutter/material.dart';

import '../utils/config.dart';

class SocialButon extends StatelessWidget {
  const SocialButon({super.key, required this.social});
  final String social;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
        side: const BorderSide(width: 1, color: Colors.black),
      ),
      onPressed: () {},
      child: SizedBox(
        width: Config.widthSize * 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/$social.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(social.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                )),
          ],
        ),
      ),
    );
  }
}
