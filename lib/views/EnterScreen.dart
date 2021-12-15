// ignore: file_names
// ignore_for_file: avoid_print, file_names, camel_case_types
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:modolar_recipe/Widgets/recipe_card.dart';

// ignore: use_key_in_widget_constructors
class enterScreen extends StatefulWidget {
  const enterScreen({Key? key}) : super(key: key);

  static const String idScreen = "EnterScreen";

  @override
  _enterScreenState createState() => _enterScreenState();
}

class _enterScreenState extends State<enterScreen> {
  List<recipe_card> recipes = <recipe_card>[];

  TextEditingController textEditingController_Engrideints =
      new TextEditingController();
  TextEditingController textEditingController_recipe =
      new TextEditingController();

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

  // search for recipe
  fetchRecipe(String query) async {
    // debugFlag("search");
    String url =
        "https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON. and build recipeMap
      Map<String, dynamic> jsonData = jsonDecode((response.body));

      jsonData["hits"].forEach((element) {
        print(element.toString());
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
            const Color(0xFFFFECD9),
            const Color(0xFFFFECD9),
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
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textEditingController_Engrideints,
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
                        if (textEditingController_Engrideints.text.isNotEmpty) {
                          fetchRecipe(textEditingController_Engrideints.text);
                        } else {
                          print("text box is empty");
                        }
                      },
                      // ignore: avoid_unnecessary_containers
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
                        controller: textEditingController_recipe,
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
                        if (textEditingController_recipe.text.isNotEmpty) {
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
              // Sized
              SizedBox(
                height: 30,
              ),
              Container(
                  child: GridView(
                children: [],
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              )
                  // child: GridView(
                  //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  //         mainAxisSpacing: 10.0, maxCrossAxisExtent: 200.0),
                  //     shrinkWrap: true,
                  //     scrollDirection: Axis.vertical,
                  //     physics: ClampingScrollPhysics(),
                  //     children: List.generate(recipies.length, (index) {
                  //       return GridTile(
                  //           child: RecipieTile(
                  //         title: recipies[index].label,
                  //         imgUrl: recipies[index].image,
                  //         desc: recipies[index].source,
                  //         url: recipies[index].url,
                  //       ));
                  //     })),
                  ),
            ],
          ),
        ),
      ]),
    );
  }
}

class RecipeTile extends StatelessWidget {
  late String url, source, title, postUrl;

  RecipeTile(
      {required this.url,
      required this.source,
      required this.title,
      required this.postUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Image.network(url),
        Container(
          child: Column(
            children: <Widget>[Text(title), Text(source)],
          ),
        )
      ],
    ));
  }
}
