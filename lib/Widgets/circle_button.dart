import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modolar_recipe/views/enter_screen.dart';

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
              color: HexColor('##785ac7'),
            ),
            color: Colors.white,
            iconSize: 40,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, EnterScreen.idScreen, (route) => false);
              // Navigator.pop(context);
            }),
      ),
    );
  }
}
