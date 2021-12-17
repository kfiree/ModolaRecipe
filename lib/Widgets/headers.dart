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
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        GradientText("R",
            style: TextStyle(fontSize: size + 5), colors: [color1, color2]),
        Text(
          "ecipies",
          style: TextStyle(
              color: Colors.white, fontSize: size, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
