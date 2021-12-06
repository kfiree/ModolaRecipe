import 'package:flutter/material.dart';

import 'views/home.dart';
import 'views/recipe_view.dart';

void main() {
  runApp(ModulaRecipe());
}

class ModulaRecipe extends StatelessWidget {
  // const ModulaRecipe({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ModulaRecipe',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Home(),
    );
  }
}
