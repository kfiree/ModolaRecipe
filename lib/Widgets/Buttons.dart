import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    required this.icon,
    required this.callback,
    required this.color,
    /*required this.size*/
  });

  final IconData icon;
  final VoidCallback callback;
  final Color color;
  // final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Ink(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: CircleBorder(),
        ),
        child: IconButton(
            icon: Icon(
              icon,
              color: color, //HexColor('##785ac7'),
            ),
            color: Colors.white,
            iconSize: 40,
            onPressed: callback),
      ),
    );
  }
}
