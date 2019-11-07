import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/common/resources/t_colors.dart';
import 'package:flutter_template/common/resources/t_text_styles.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromARGB(255, 171, 220, 255),
              Color.fromARGB(255, 3, 150, 2550),
            ],
            stops: <double>[0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Flex(direction: Axis.horizontal, mainAxisSize: MainAxisSize.min, children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: Image.asset(
              'assets/images/meow.jpeg',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Text(
            'tvc12',
            style: TTextStyles.bold(fontSize: 18, color: TColors.white),
          )
        ]),
      ),
    );
  }
}
