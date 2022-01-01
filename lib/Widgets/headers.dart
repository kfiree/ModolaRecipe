import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RecipeHeader extends StatelessWidget {
  const RecipeHeader(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.size})
      : super(key: key);

  final Color color1;
  final Color color2;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Modula",
          style: TextStyle(
              fontSize: size,
              fontWeight: Platform.isIOS ? FontWeight.w400 : FontWeight.w900),
          textAlign: TextAlign.center,
        ),
        GradientText("R",
            style: TextStyle(
              fontSize: size + 5,
              fontWeight: Platform.isIOS ? FontWeight.w400 : FontWeight.w900,
            ),
            colors: [color1, color2]),
        Text(
          "ecipies",
          style: TextStyle(
              color: Colors.white,
              fontSize: size,
              fontWeight: Platform.isIOS ? FontWeight.w400 : FontWeight.w900),
        )
      ],
    );
  }
}

class SubHeader extends StatelessWidget {
  const SubHeader({Key? key, required this.text, required this.size})
      : super(key: key);

  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: size, color: Colors.white),
      ),
    );
  }
}
