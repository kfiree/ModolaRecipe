// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:modolar_recipe/views/profile_screen.dart';
import 'package:modolar_recipe/views/login_screen.dart';
import 'package:modolar_recipe/views/add_screen.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    Key? key,
    required this.icon,
    required this.callback,
    required this.color,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback callback;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          color: Colors.white,
          iconSize: 40,
          onPressed: callback),
    );
  }
}

class LogOut extends StatelessWidget {
  const LogOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleButton(
          color: Colors.black,
          icon: Icons.logout,
          callback: () => {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.idScreen, (route) => false)
          },
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key, required this.UID}) : super(key: key);
  final String UID;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30.0,
      left: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleButton(
          color: Colors.black,
          icon: Icons.account_box,
          callback: () => {
            Navigator.of(context).pushNamed(
              ProfileScreen.idScreen,
              arguments: {'UID': UID},
            ),
          },
        ),
      ),
    );
  }
}

class NewRecipe extends StatelessWidget {
  const NewRecipe({Key? key, required this.UID}) : super(key: key);
  final String UID;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30.0,
      left: 0.0,
      child: CircleButton(
        color: Colors.black,
        icon: Icons.add,
        callback: () => {
          Navigator.of(context).pushNamed(
            AddScreen.idScreen,
            arguments: {'UID': UID},
          ),
        },
      ),
    );
  }
}
