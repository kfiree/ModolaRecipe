// ignore_for_file: unused_import, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:modolar_recipe/views/main_screen.dart';
import 'package:modolar_recipe/views/signup.dart';
import 'package:modolar_recipe/Widgets/headers.dart';
import 'package:modolar_recipe/Widgets/loading.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  TextEditingController emailTextEdittingController = TextEditingController();
  TextEditingController passwordTextEdittingController =
      TextEditingController();

  bool rememberpwd = false;
  bool sec = true;

  var visable = Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  var visableoff = Icon(
    Icons.visibility_off,
    color: Color(0xff4c5166),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/chef.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        // Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //       Colors.white,
        //       Color.fromARGB(255, 248, 191, 176),
        //     ]),
        //   ),
        // ),

        Container(
          padding: EdgeInsets.symmetric(
              vertical: Platform.isIOS ? 60 : 30, horizontal: 30),
          child: Column(
            children: <Widget>[
              RecipeHeader(
                color1: Colors.black,
                color2: Colors.white,
                size: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSignupQuestion(),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              buildEmail(),
              SizedBox(
                height: 50,
              ),
              buildPassword(),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [buildRememberassword(), buildForgetPassword()],
              ),
              SizedBox(
                height: 30,
              ),
              buildLoginButton(),
              // SizedBox(
              //   height: 30,
              // ),

              // SizedBox(
              //   height: 30,
              // ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 110,
          child: SizedBox(
            height: 110,
            width: 150,
            child: buildUnregisteredLoginButton(),
          ),
        )
      ]),
    );
  }

  Widget buildSignupQuestion() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
          child: Text("Still not s user?! Sign-Up",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black45)),
          onPressed: () {
            // setState(() => loading = true);
            Navigator.pushNamedAndRemoveUntil(
                context, SignupScreen.idScreen, (route) => false);
          }),
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Color(0xffebefff),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                )
              ]),
          child: TextField(
            controller: emailTextEdittingController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xff4c5166),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xffebefff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ],
          ),
          height: 60,
          child: TextField(
            controller: passwordTextEdittingController,
            obscureText: sec,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    sec = !sec;
                    sec = !sec;
                  });
                },
                icon: sec ? visableoff : visable,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.vpn_key,
                color: Color(0xff4c5166),
              ),
              hintText: "password",
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
        )
      ],
    );
  }

  Widget buildRememberassword() {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.grey),
            child: Checkbox(
              value: rememberpwd,
              checkColor: Colors.blueGrey,
              activeColor: Colors.black,
              onChanged: (value) {
                setState(
                  () {
                    rememberpwd = value!;
                  },
                );
              },
            ),
          ),
          Text(
            "Remember me 🥺",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget buildForgetPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
          child: Text("Forget Password !",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          onPressed: () => {}),
    );
  }

  Widget buildUnregisteredLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              MainScreen.idScreen,
              arguments: {'UID': '0'},
            );
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          elevation: 0.0,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: const [
                    Color.fromARGB(255, 248, 191, 176),
                    Color.fromARGB(255, 248, 137, 99),
                  ]),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: 130.0, minHeight: 50.0, maxHeight: 50),
              alignment: Alignment.center,
              child: Text(
                "Guest!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            setState(() => loading = true);
            if (!emailTextEdittingController.text.contains("@")) {
              displayToastMessage("Email is not valid.", context);
            } else if (passwordTextEdittingController.text.isEmpty) {
              displayToastMessage("Password is missing.", context);
            } else {
              loginUserAndAuthenticate(context);
            }
            setState(() => loading = true);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          elevation: 0.0,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: const [
                    Color.fromARGB(255, 248, 191, 176),
                    Color.fromARGB(255, 248, 137, 99),
                  ]),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Login!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginUserAndAuthenticate(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Loading();
          ;
        });
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEdittingController.text,
                password: passwordTextEdittingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          // Navigator.pushNamedAndRemoveUntil(
          //     context, MainScreen.idScreen, (route) => false);
          Navigator.of(context).pushNamed(
            MainScreen.idScreen,
            arguments: {'UID': firebaseUser.uid},
          );
          displayToastMessage("Welcome! you are now logged in.", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage(
              "Account not exist. Please create new account.", context);
        }
      });
    } else {
      //Error accured.
      displayToastMessage(
          "Error occured, cannot sign-in. Please try again later.", context);
    }
  }

  displayToastMessage(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg);
  }
}
