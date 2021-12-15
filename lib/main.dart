import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modolar_recipe/views/login.dart';
import 'package:modolar_recipe/views/recipe_screen.dart';
import 'package:modolar_recipe/views/signup.dart';
import 'package:modolar_recipe/views/enter_screen.dart';
import 'package:modolar_recipe/views/recipe_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ModulaRecipe",
      initialRoute: LoginScreen.idScreen,
      // initialRoute: DetailRecipe.idScreen,
      routes: {
        // '/': (context) => LoginScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        EnterScreen.idScreen: (context) => EnterScreen(),
        DetailRecipe.idScreen: (context) => DetailRecipe(),
        SignupScreen.idScreen: (context) => SignupScreen(),
        RecipeScreen.idScreen: (context) => RecipeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");
