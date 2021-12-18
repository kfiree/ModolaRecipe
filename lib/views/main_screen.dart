import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modolar_recipe/Widgets/loading.dart';
import 'package:modolar_recipe/views/profile_screen.dart';

import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/views/login.dart';
import 'package:modolar_recipe/views/add_recipe.dart';
import 'package:modolar_recipe/views/recipe_full_view.dart';
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
  bool loading = false;

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
    print("======================  in fetch =============================");
    String queryUrl =
        'https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey';
    var response = await http.get(Uri.parse(queryUrl));
    Loading();
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
    List<Widget> recipesScrollView = [
      MediumRecipeView(
        cookTime: 10,
        energy: 420,
        name: 'Pancakes',
        recipeUrl:
            'https://media.eggs.ca/assets/RecipePhotos/_resampled/FillWyIxMjgwIiwiNzIwIl0/Fluffy-Pancakes-New-CMS.jpg',
      ),
      MediumRecipeView(
        cookTime: 20,
        energy: 1000000,
        name: 'Hamburger',
        recipeUrl:
            'https://www.keziefoods.co.uk/wp-content/uploads/2021/01/Kangaroo-Jalapeno-Burgers-228g-2-in-a-pack.jpg',
      ),
      MediumRecipeView(
        cookTime: 5,
        energy: 50,
        name: 'Mandarin Orange Salad',
        recipeUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkT6qXEFkfXaJMqUzgDpiCyav-ueCcdcKP1g&usqp=CAU',
      ),
      MediumRecipeView(
          cookTime: 0,
          energy: 88,
          name: 'Banana',
          recipeUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEZ_666h1r5_BQTw1uM2Q1LjM6_5qaiOEkeg&usqp=CAU'),
    ];
    // List<Widget> recipesScrollView =
    //     List.generate(recipeNum, (int i) => MediumRecipeView());

    List<Widget> smallTileList = List.generate(
        50,
        (int i) => RecipeTile(
              desc: 'source',
              title: 'title',
              imgUrl:
                  'https://media.eggs.ca/assets/RecipePhotos/_resampled/FillWyIxMjgwIiwiNzIwIl0/Fluffy-Pancakes-New-CMS.jpg',
              url: 'url',
            ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: <Widget>[
        // design data
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

        // screen content
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

            // profile
            Positioned(
              top: 30.0,
              left: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleButton(
                  color: Colors.black,
                  icon: Icons.account_box,
                  callback: () => {
                    Navigator.of(context).pushNamed(ProfileScreen.idScreen),
                  },
                ),
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

            Stack(
              children: <Widget>[
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
                                  Navigator.of(context)
                                      .pushNamed(ShowScreen.idScreen);
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

                      // Container(
                      //   height: 400,
                      //   child: ListView(
                      //     scrollDirection: Axis.horizontal,
                      //     //TODO stack overflow: Overflow.clip
                      //     children: recipesScrollView,
                      //   ),
                      // ),

                      GridView.count(
                        crossAxisCount: 3,
                        children: smallTileList,
                      ),
                    ],
                  ),
                ),
                loading ? Loading() : SizedBox(),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}

class RecipeTile extends StatelessWidget {
  const RecipeTile(
      {Key? key,
      required this.title,
      required this.desc,
      required this.imgUrl,
      required this.url})
      : super(key: key);

  final String title, desc, imgUrl, url;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.network(
        imgUrl,
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      ),
      Container(
        width: 200,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white30, Colors.white],
                begin: FractionalOffset.centerRight,
                end: FractionalOffset.centerLeft)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontFamily: 'Overpass'),
              ),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  // fontFamily: 'OverpassRegular'
                ),
              )
            ],
          ),
        ),
      ),
    ]);
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
  final int cookTime;
  final int energy;
  final String name;
  final String recipeUrl;
  //TODO get recipe data

  const MediumRecipeView(
      {Key? key,
      required this.cookTime,
      required this.energy,
      required this.name,
      required this.recipeUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => {
            Navigator.of(context).pushNamed(ShowScreen.idScreen)
            // Navigator.pushNamedAndRemoveUntil(
            //     context, ShowScreen.idScreen, (route) => false)
          },
          child: RecipeBigView(
            cookTime: cookTime,
            energy: energy,
            name: name,
            recipeImageURL: recipeUrl,
          ),
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
