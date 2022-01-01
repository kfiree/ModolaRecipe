import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:modolar_recipe/views/login_screen.dart';
import 'package:modolar_recipe/views/signup_screen.dart';
import 'package:modolar_recipe/views/main_screen.dart';
import 'package:modolar_recipe/views/recipe_screen.dart';
import 'package:modolar_recipe/views/add_screen.dart';
import 'package:modolar_recipe/views/profile_screen.dart';

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
      routes: {
        SignupScreen.idScreen: (context) => SignupScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen(),
        AddScreen.idScreen: (context) => AddScreen(),
        ProfileScreen.idScreen: (context) => ProfileScreen(),
        FullViewScreen.idScreen: (context) => FullViewScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");
