import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modolar_recipe/views/login.dart';
import 'package:modolar_recipe/views/signup.dart';
import 'package:modolar_recipe/views/EnterScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ModulaRecipe",
      initialRoute: LoginScreen.idScreen,
      routes: {
      // '/': (context) => LoginScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        EnterScreen.idScreen: (context) => EnterScreen(),
        SignupScreen.idScreen: (context) => SignupScreen(),
      } ,
      debugShowCheckedModeBanner: false,
    );
  }
}
DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");