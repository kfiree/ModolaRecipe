// ignore_for_file: avoid_print, unused_import
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:modolar_recipe/views/profile_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:modolar_recipe/Widgets/circle_button.dart';
import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/views/login.dart';
import 'package:modolar_recipe/views/add_recipe.dart';
import 'package:modolar_recipe/views/recipe_view.dart';
import 'package:modolar_recipe/models/recipe_model.dart';
import 'package:modolar_recipe/Widgets/recipe_card.dart';
import 'package:modolar_recipe/Widgets/headers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String idScreen = "main_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //recipe list
  List<RecipeModel> recipes = <RecipeModel>[];

  //text controllers
  TextEditingController engrideintsTextController = TextEditingController();
  TextEditingController recipesTextController = TextEditingController();

  //api access data
  String applicationId = "41ca25af";
  String applicationKey = "ab51bad1b862188631ce612a9b1787a9";

  // return recipes
  fetchRecipes(String query) async {
    String queryUrl =
        'https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey';
    var response = await http.get(Uri.parse(queryUrl));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      jsonData["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);

        recipes.add(recipeModel);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Recipe');
    }
  }

  @override
  Widget build(BuildContext context) {
    //build recipe card for scroll view
    int recipeNum = 4;
    List<Widget> recipesScrollView =
        List.generate(recipeNum, (int i) => MediumRecipeView(i));

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 248, 191, 176),
                Colors.white,
              ],
            ),
          ),
        ),
        Stack(
          children: [
            // logout
            Positioned(
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
                        }),
              ),
            ),

            Positioned(
              top: 30.0,
              left: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleButton(
                    color: Colors.black,
                    icon: Icons.account_box,
                    callback: () => {
                          Navigator.pushNamedAndRemoveUntil(
                              context, ProfileScreen.idScreen, (route) => false)
                        }),
              ),
            ),
            // add recipe
            Positioned(
              bottom: 30.0,
              left: 0.0,
              child: CircleButton(
                  color: Colors.black,
                  icon: Icons.add,
                  callback: () => {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AddScreen.idScreen, (route) => false)
                      }),
            ),
            // Row(
            //   children: <Widget>[
            //     Container(
            //       margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            //       height: 30.0,
            //       width: 200.0,
            //       decoration: BoxDecoration(
            //         color: HexColor("#2a522a"),
            //         borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(10),
            //           bottomLeft: Radius.circular(10),
            //           bottomRight: Radius.elliptical(50, 18),
            //           topRight: Radius.elliptical(50, 18),
            //         ),
            //       ),
            //       child: Center(
            //         child: Text(
            //           "Add new recipe",
            //           style: TextStyle(
            //             fontSize: 20.0,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //     IconButton(
            //       iconSize: 40,
            //       color: HexColor("#2a522a"),
            //       icon: Icon(
            //         Icons.add,
            //       ),
            //       onPressed: () {
            //         Navigator.pushNamedAndRemoveUntil(
            //             context, AddScreen.idScreen, (route) => false);
            //       },
            //     ),
            //   ],
            // )),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),

                  // headers
                  RecipeHeader(
                      color1: Colors.black, color2: Colors.white, size: 40),
                  SizedBox(
                    height: 30,
                  ),
                  SubHeader(text: "What will you cock today?", size: 20),
                  SizedBox(
                    height: 8,
                  ),
                  SubHeader(
                    text:
                        "Search recipe by typeing in a name of a dish \nor simply just write what ingredients you want to use.",
                    size: 13,
                  ),

                  // inputs text boxes
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: engrideintsTextController,
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
                          onTap: () async {
                            if (engrideintsTextController.text.isNotEmpty) {
                              //TODO fix before commit

                              // fetchRecipes(engrideintsTextController.text);
                              Navigator.pushNamedAndRemoveUntil(context,
                                  ShowScreen.idScreen, (route) => false);
                            } else {
                              print("text box is empty");
                            }
                          },
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // favorte recipes
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 400,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: recipesScrollView,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class RecipeTile extends StatefulWidget {
  String url, source, title, postUrl;

  RecipeTile(
      {Key? key,
      required this.url,
      required this.source,
      required this.title,
      required this.postUrl})
      : super(key: key);

  @override
  State<RecipeTile> createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Image.network(widget.url),
        Container(
          child: Column(
            children: <Widget>[Text(widget.title), Text(widget.source)],
          ),
        )
      ],
    ));
  }
}

class SubHeader extends StatelessWidget {
  const SubHeader({Key? key, required this.text, required this.size})
      : super(key: key);

  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return
        // mainAxisAlignment: MainAxisAlignment.,
        // children: const <Widget>[
        Text(
      text,
      style: TextStyle(fontSize: size, color: Colors.white),
    );

    // Text(
    //   ,
    //   style: TextStyle(fontSize: 13, color: Colors.white),
    // ),
    // ]);
  }
}

class MediumRecipeView extends StatelessWidget {
  final int index;
  //TODO get recipe data

  MediumRecipeView(this.index);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.idScreen, (route) => false)
          },
          child: RecipeBigView(
            cookTime: 10,
            energy: 420,
            energyUnit: 'cal',
            name: 'Pancakes',
            recipeImageURL:
                'https://media.eggs.ca/assets/RecipePhotos/_resampled/FillWyIxMjgwIiwiNzIwIl0/Fluffy-Pancakes-New-CMS.jpg',
            timeUnit: 'min',
          ),
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
