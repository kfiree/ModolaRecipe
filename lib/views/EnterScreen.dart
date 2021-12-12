import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class EnterScreen extends StatefulWidget {
  // const EnterScreen({Key? key}) : super(key: key);
  static const String idScreen = "EnterScreen";

  @override
  _EnterScreenState createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  TextEditingController textEditingController = new TextEditingController();

  String applicationId = "41ca25af";
  String applicationKey = "ab51bad1b862188631ce612a9b1787a9";

  // search for recipe
  search(String query) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFECD9),
                  const Color(0xFFFFECD9),
                ]
              )
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Modula",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  GradientText("R",
                      style: TextStyle(fontSize: 35),
                      colors: const [Colors.black, Colors.white]),
                  Text(
                    "ecipies",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "What will you cock today?",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Insert what ingredients you have?",
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            hintText: "Enter Ingrideints",
                            hintStyle: TextStyle(
                              fontSize: 18,
                            )),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        if (textEditingController.text.isNotEmpty) {
                          print("just do it");
                        } else {
                          print(" dont");
                        }
                      },
                      child: Container(
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            hintText: "Enter Recipe Name",
                            hintStyle: TextStyle(
                              fontSize: 18,
                            )),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        if (textEditingController.text.isNotEmpty) {
                          print("just do it");
                        } else {
                          print(" dont");
                        }
                      },
                      child: Container(
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
