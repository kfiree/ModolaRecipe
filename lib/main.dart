import 'package:flutter/material.dart';

import 'views/home.dart';
import 'views/recipe_view.dart';

void main() {
  runApp(ModolaRecipe());
}

class ModolaRecipe extends StatelessWidget {
  // const ModolaRecipe({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ModolaRecipe',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Home(),
    );
  }
}
