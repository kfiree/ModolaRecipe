// ignore_for_file: avoid_print
/*      === REMOTE ===    */
// import 'dart:html';
// import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/*      === LOCAL ===    */
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:modolar_recipe/Widgets/recipe_card.dart';
import 'package:modolar_recipe/views/recipe_view.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({Key? key}) : super(key: key);

  static const String idScreen = "EnterScreen";

  @override
  _EnterScreenState createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  List<recipe_card> recipes = <recipe_card>[];

  TextEditingController engrideintsTextController = TextEditingController();
  TextEditingController recipesTextController = TextEditingController();

  String applicationId = "41ca25af";
  String applicationKey = "ab51bad1b862188631ce612a9b1787a9";

  debugFlag(String place) {
    print(
        " =========================================================================================");
    print(
        " ====================================  $place ====================================");
    print(
        " =========================================================================================");
  }

  // get recipe with api call
  fetchRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON. and build recipeMap
      Map<String, dynamic> jsonData = jsonDecode((response.body));

      jsonData["hits"].forEach((element) {
        print(element.toString());
        // ignore: unused_local_variable
        recipe_card recipe = recipe_card(
            image: "image", url: "url", label: "label", source: "source");
        recipe_card.fromMap(element["recipe"]);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Recipes');
    }

    print("${response.toString()} this is the response");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xFFFFECD9),
            Color(0xFFFFECD9),
          ])),
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
                          fetchRecipe(engrideintsTextController.text);
                          Navigator.pushNamedAndRemoveUntil(
                              context, DetailRecipe.idScreen, (route) => false);
                        } else {
                          print("text box is empty");
                        }
                      },
                      child: Icon(Icons.search, color: Colors.white),
                      // child: Container(
                      //   child: Icon(Icons.search, color: Colors.white),
                      // ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: recipesTextController,
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
                        if (recipesTextController.text.isNotEmpty) {
                          print("just do it");
                        } else {
                          print(" dont");
                        }
                      },
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 30,
              // ),
              // GridView(
              //   children: [],
              //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              // maxCrossAxisExtent: 200,
              // childAspectRatio: 3 / 2,
              // crossAxisSpacing: 20,
              // mainAxisSpacing: 20,
              //   ),
              // ),
            ],
          ),
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
