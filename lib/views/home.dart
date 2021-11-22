import 'dart:io';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.blue])),
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: Platform.isIOS? 60 : 30, horizontal: 30),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "ModolaR",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Recipies",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 23,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("What will you cock today?"),
              Text("So.. what ingredients do you have?")
            ])),
      ]),
    );
  }
}
