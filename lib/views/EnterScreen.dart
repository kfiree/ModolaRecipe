// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modolar_recipe/Widgets/recipeBox.dart';

class EnterScreen extends StatefulWidget {
    static const String idScreen = "EnterScreen";

  @override
  _EnterScreenState createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff65b0bb),
                      Color(0xff5a9ea8),
                      Color(0xff508c95),
                      Color(0xff467b82),
                      Color(0xff3c6970),
                      Color(0xff32585d),
                      Color(0xff28464a),
                    ],
                  ),
                ),
                child: Expanded(
                  // padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Hello User!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Text(
                          "Top recipes for today",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildPostRecipe(),
                              buildSearchRecipe(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildPostRecipe() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: RaisedButton(
        onPressed: (){
          // Post ride
        },
        child: Image.asset("assets/facebook.png",),
      ),
    );
  }

  Widget buildSearchRecipe() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: RaisedButton(
        onPressed: (){
          // Search ride
        },
        child: Image.asset("assets/facebook.png",),
      ),
    );
  }
}
