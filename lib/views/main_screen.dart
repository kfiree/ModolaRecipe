import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modolar_recipe/Widgets/loading.dart';
import 'package:modolar_recipe/views/profile_screen.dart';

import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/views/login.dart';
import 'package:modolar_recipe/views/add_recipe.dart';
import 'package:modolar_recipe/Widgets/recipe_views.dart';
import 'package:modolar_recipe/Widgets/headers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modolar_recipe/views/recipe_screen.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  // CLASS VARIABLES

  String applicationId = "41ca25af",
      applicationKey = "ab51bad1b862188631ce612a9b1787a9";

  static const String idScreen = "main_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool loading = false, searchView = false;

  //recipe list
  List<RecipeModel> recipes = [];
  late FullRecipe recipe;

  //text controllers
  TextEditingController engrideintsTextController = TextEditingController(),
      recipesTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //build recipe card for scroll view
    List<Widget> recipesScrollView = [
      RecipeMediumView(
        cookTime: 10,
        energy: 420,
        name: 'Pancakes',
        recipeImageURL:
            'https://media.eggs.ca/assets/RecipePhotos/_resampled/FillWyIxMjgwIiwiNzIwIl0/Fluffy-Pancakes-New-CMS.jpg',
      ),
      RecipeMediumView(
        cookTime: 20,
        energy: 1000000,
        name: 'Hamburger',
        recipeImageURL:
            'https://www.keziefoods.co.uk/wp-content/uploads/2021/01/Kangaroo-Jalapeno-Burgers-228g-2-in-a-pack.jpg',
      ),
      RecipeMediumView(
        cookTime: 5,
        energy: 50,
        name: 'Mandarin Orange Salad',
        recipeImageURL:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkT6qXEFkfXaJMqUzgDpiCyav-ueCcdcKP1g&usqp=CAU',
      ),
      RecipeMediumView(
          cookTime: 0,
          energy: 88,
          name: 'Banana',
          recipeImageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEZ_666h1r5_BQTw1uM2Q1LjM6_5qaiOEkeg&usqp=CAU'),
    ];

    List<Widget> smallTileList = List.generate(
      recipes.length,
      (int i) => RecipeTile(
        desc: recipes[i].label,
        title: recipes[i].label,
        imgUrl: recipes[i].image,
        url: recipes[i].url,
        uri: recipes[i].uri,
        recipeJson: recipes[i].recipeJson,
      ),
    );

    return Container(
      // onWillPop: () async {
      //   return searchView = false;
      //   // bool? result = await Navigator.pushNamedAndRemoveUntil(
      //   //     context, MainScreen.idScreen, (route) => false);

      //   // if (result == null) {
      //   //   result = false;
      //   // }
      //   // return result!;
      // },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            // style data
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
              children: <Widget>[
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
                              color1: Colors.black,
                              color2: Colors.white,
                              size: 30),
                          if (!searchView)
                            Column(
                              children: const <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                SubHeader(
                                    text: "What will you cock today?",
                                    size: 20),
                                SizedBox(
                                  height: 8,
                                ),
                                SubHeader(
                                  text:
                                      "Search recipe by typeing in a name of a dish \nor simply just write what ingredients you want to use.",
                                  size: 13,
                                ),
                              ],
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
                                    if (engrideintsTextController
                                        .text.isNotEmpty) {
                                      setState(() => searchView = true);
                                      fetchRecipes(
                                          engrideintsTextController.text);
                                    } else {
                                      // ignore: avoid_print
                                      print("text box is empty");
                                    }
                                  },
                                  child:
                                      Icon(Icons.search, color: Colors.white),
                                ),
                              ],
                            ),
                          ),

                          // favorte recipes
                          SizedBox(
                            height: 0,
                          ),
                          searchView
                              ? Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 5,
                                    children: smallTileList,
                                  ),
                                )
                              : SizedBox(
                                  height: 400,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    //TODO stack overflow: Overflow.clip
                                    children: recipesScrollView,
                                  ),
                                )
                        ],
                      ),
                    ),
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
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      LoginScreen.idScreen, (route) => false)
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
                            Navigator.of(context)
                                .pushNamed(ProfileScreen.idScreen),
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
                                Navigator.pushNamedAndRemoveUntil(context,
                                    AddScreen.idScreen, (route) => false)
                              }),
                    ),

                    loading ? Loading() : SizedBox(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// return recipes
  Future<List<RecipeModel>> fetchRecipes(String query) async {

    String queryUrl =
        'https://api.edamam.com/search?q=$query&app_id=${widget.applicationId}&app_key=${widget.applicationKey}';
    final response = await http.get(Uri.parse(queryUrl));
    Loading();
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      jsonData["hits"].forEach((hit) {
        jsonData["hits"].forEach((hit) {
            recipes.add((RecipeModel.fromRecipeMap(hit["recipe"])));

          }
        );
        // recipes.add(RecipeModel.fromRecipeMap(jsonDecode(jsonData["hits"][i]["recipe"])) as Future<RecipeModel>);
        // return RecipeModel.fromJson(element["recipe"]);
      });
      // smallTileList();
      return recipes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Recipe');
    }
  }
//   fetchRecipe(String recipeId) async {
//     var queryUrl = 
//     'https://api.edamam.com/search?r=http%3A%2F%2Fwww.edamam.com%2Fontologies%2Fedamam.owl%23$recipeId&app_id=41ca25af&app_key=ab51bad1b862188631ce612a9b1787a9';

//     final response = await http.get(Uri.parse("https://api.edamam.com/search?r=http%3A%2F%2Fwww.edamam.com%2Fontologies%2Fedamam.owl%23recipe_95661be6f77a57b4c85c789a3b737ada&app_id=41ca25af&app_key=ab51bad1b862188631ce612a9b1787a9"));
//     Loading();
//     if (response.statusCode == 200) {
//       Map<String, dynamic> jsonData = jsonDecode(response.body);
//     }else{
//       throw Exception('Failed to load recipe');
//     }
//   }
}


class UserInfo extends InheritedWidget {
  UserInfo({
    Key? key,
    required this.userId,
    // required Widget child,
  }) : super(key: key, child: SizedBox());

  final String userId;

  static UserInfo of(BuildContext context) {
    final UserInfo? id = context.dependOnInheritedWidgetOfExactType<UserInfo>();
    assert(id != null, 'No UserInfo found in context');
    return id!;
  }

  @override
  bool updateShouldNotify(UserInfo old) => userId != old.userId;
}

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}