import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({required this.icon});

  final IconData icon;

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
              color: HexColor('#F9AF9C'),
            ),
            color: Colors.white,
            iconSize: 40,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}