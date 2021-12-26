import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:modolar_recipe/Widgets/loading.dart';
import 'package:modolar_recipe/views/profile_screen.dart';
import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/views/login.dart';
import 'package:modolar_recipe/views/add_recipe.dart';
import 'package:modolar_recipe/Widgets/recipes.dart';
import 'package:modolar_recipe/Widgets/headers.dart';
// import 'package:modolar_recipe/views/recipe_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String idScreen = "main_screen";
  // final String applicationId = "2051cf6b",
  //     applicationKey = "23b5c49d42ef07d39fb68e1b6e04bf42";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool loading = false, searchMode = false;
  double headerSize = 40;
  List<RecipeTile> tiles = [];
  // String query = 'sugar';

  //text controllers
  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // safety check
    if (ModalRoute.of(context)?.settings.arguments == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.idScreen,
        (route) => false,
      );
    }

    // route arguments
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map;
    final UID = routeArgs['UID'];

    return Scaffold(
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
                colors: [Color.fromARGB(255, 248, 191, 176), Colors.white],
              ),
            ),
          ),

          // screen content
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //headers
                  MainHeaders(
                    searchMode: searchMode,
                    mainSize: searchMode ? 40 : 50,
                  ),

                  Container(
                    child: Row(
                      children: <Widget>[
                        // search
                        Expanded(
                          child: TextField(
                            controller: txtController,
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
                            if (txtController.text.isNotEmpty) {
                              setState(
                                () => {
                                  loading = true,
                                  searchMode = true,
                                },
                              );
                              fetchRecipes(txtController.text, tiles, UID);
                              setState(
                                () => {
                                  loading = false,
                                },
                              );
                            } else {
                              setState(
                                () => {
                                  searchMode = false,
                                },
                              );
                            }
                          },
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  //recipe views
                  Container(
                    child: searchMode
                        ? GridView.count(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            children: tiles,
                          )
                        : InitialRecipe(UID),
                  )
                ],
              ),
            ),
          ),

          // loading
          if (loading)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Loading(),
              ),
            ),
          //buttons
          LogOut(),
          Profile(UID: UID),
          NewRecipe(UID: UID),
        ],
      ),
    );
  }

  Future<List<RecipeTile>> fetchRecipes(
      String query, List<RecipeTile> recipes, String UID) async {
    String applicationId = "2051cf6b",
        applicationKey = "23b5c49d42ef07d39fb68e1b6e04bf42";
    String queryUrl =
        'https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey';
    final response = await http.get(Uri.parse(queryUrl));

    if (response.statusCode == 200) {
      // recipes.clear();
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      jsonData["hits"].forEach(
        (hit) {
          recipes.add(RecipeTile(
            recipeModel: RecipeModel.fromJson(hit["recipe"]),
            UID: UID,
          ));
        },
      );

      setState(() => {loading = false});
      return recipes;
    } else {
      setState(() => loading = false);
      throw Exception(
          'Failed to load Recipe. response statusCode = ${response.statusCode}');
    }
  }
  // // return recipes
  // Future<List<Widget>> fetchRecipes(
  //     String query, List<Widget> recipes, String UID,
  //     {int from = 0, required bool search}) async {
  //   String queryUrl =
  //       'https://api.edamam.com/search?q=$query&from=$from&to=${from + 15}&app_id=${widget.applicationId}&app_key=${widget.applicationKey}';
  //   final response = await http.get(Uri.parse(queryUrl));
  //   if (response.statusCode == 200) {
  //     // recipes.clear();
  //     Map<String, dynamic> jsonData = jsonDecode(response.body);
  //     jsonData["hits"].forEach(
  //       (hit) {
  //         recipes.add((RecipeMediumView(
  //           UID: UID,
  //           recipeModel: RecipeModel.fromJson(hit["recipe"]),
  //         )));
  //       },
  //     );
  //     return recipes;
  //   } else {
  //     throw Exception(
  //         'Failed to load Recipe. response statusCode = ${response.statusCode} queryUrl = $queryUrl');
  //   }
  // }
}

class InitialRecipe extends StatelessWidget {
  final UID;
  CollectionReference collection =
      FirebaseFirestore.instance.collection("recipes");
  InitialRecipe(this.UID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: collection.doc('VRWodus2pN2wXXHSz8JH').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<RecipeMediumView> recipeWidgets = [];
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          data.forEach((key, recipe) {
            print("  ====   Key : $key, Value : $recipe   ====   ");
            recipeWidgets.add(RecipeMediumView(
              UID: UID,
              recipeModel: RecipeModel.fromJson(recipe),
            ));
          });
          return SizedBox(
            height: 400,
            child: ListView(
              scrollDirection: Axis.horizontal,
              //TODO stack overflow: Overflow.clip

              children: recipeWidgets,
            ),
          );
        }
        return Loading();
      },
    );
  }
}

class MainHeaders extends StatelessWidget {
  const MainHeaders(
      {Key? key, required this.searchMode, required this.mainSize})
      : super(key: key);
  final bool searchMode;
  final double mainSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        // headers
        RecipeHeader(
            color1: Colors.black, color2: Colors.white, size: mainSize),
        if (!searchMode)
          Column(
            children: const <Widget>[
              SizedBox(
                height: 30,
              ),
              SubHeader(text: "Are you hungry??", size: 20),
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
      ],
    );
  }
}
// /*
// ===================== RESPONSE EXAMPLE =====================
// {
//     "q": "milk",
//     "from": 0,
//     "to": 10,
//     "more": true,
//     "count": 7000,
//     "hits": [
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_95661be6f77a57b4c85c789a3b737ada",
//                 "label": "Milk Liqueur",
//                 "image": "https://www.edamam.com/web-img/417/417cb5d5c104db03142e6cbea430b259.jpg",
//                 "source": "Serious Eats",
//                 "url": "http://www.seriouseats.com/recipes/2010/08/milk-liqueur-recipe.html",
//                 "shareAs": "http://www.edamam.com/recipe/milk-liqueur-95661be6f77a57b4c85c789a3b737ada/milk",
//                 "yield": 8,
//                 "dietLabels": [
//                     "Low-Fat",
//                     "Low-Sodium"
//                 ],
//                 "healthLabels": [
//                     "Low Potassium",
//                     "Kidney-Friendly",
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "Kosher",
//                     "Alcohol-Cocktail"
//                 ],
//                 "cautions": [
//                     "Wheat",
//                     "Sulfites"
//                 ],
//                 "ingredientLines": [
//                     "2 1/2 cups grappa or unflavored vodka",
//                     "2 cups whole milk",
//                     "2 cups sugar",
//                     "2 ounces bittersweet chocolate (preferably 70%), grated",
//                     "1/2 lemon, seeded and chopped, with rind"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "2 1/2 cups grappa or unflavored vodka",
//                         "quantity": 2.5,
//                         "measure": "cup",
//                         "food": "vodka",
//                         "weight": 556.0000000000001,
//                         "foodCategory": "liquors and cocktails",
//                         "foodId": "food_aqnx4i8aieyph2athk58cb3cr69w",
//                         "image": "https://www.edamam.com/food-img/e1a/e1a4708099e89fdadeb81c2d95deaa34.jpg"
//                     },
//                     {
//                         "text": "2 cups whole milk",
//                         "quantity": 2,
//                         "measure": "cup",
//                         "food": "whole milk",
//                         "weight": 488,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "2 cups sugar",
//                         "quantity": 2,
//                         "measure": "cup",
//                         "food": "sugar",
//                         "weight": 400,
//                         "foodCategory": "sugars",
//                         "foodId": "food_axi2ijobrk819yb0adceobnhm1c2",
//                         "image": "https://www.edamam.com/food-img/ecb/ecb3f5aaed96d0188c21b8369be07765.jpg"
//                     },
//                     {
//                         "text": "2 ounces bittersweet chocolate (preferably 70%), grated",
//                         "quantity": 2,
//                         "measure": "ounce",
//                         "food": "bittersweet chocolate",
//                         "weight": 56.69904625,
//                         "foodCategory": "chocolate",
//                         "foodId": "food_beu5dozavhrqdpblca414a55qow3",
//                         "image": "https://www.edamam.com/food-img/0a1/0a1b6f30cb99e1842cac6167f6f424d7.jpg"
//                     },
//                     {
//                         "text": "1/2 lemon, seeded and chopped, with rind",
//                         "quantity": 0.5,
//                         "measure": "<unit>",
//                         "food": "lemon",
//                         "weight": 29,
//                         "foodCategory": "fruit",
//                         "foodId": "food_a6uzc62astrxcgbtzyq59b6fncrr",
//                         "image": "https://www.edamam.com/food-img/70a/70acba3d4c734d7c70ef4efeed85dc8f.jpg"
//                     }
//                 ],
//                 "calories": 3410.6054220000005,
//                 "totalWeight": 1529.69904625,
//                 "totalTime": 0,
//                 "cuisineType": [
//                     "world"
//                 ],
//                 "mealType": [
//                     "lunch/dinner"
//                 ],
//                 "dishType": [
//                     "alcohol-cocktail"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 3410.6054220000005,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 32.956713875000005,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 19.176590709375006,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 9.616376949275,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 1.525122786775,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 462.27749055375,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 4.157243728750001,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 455.46998020625,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 430.10098020625,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 18.0723599425,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 48.8,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 226.2168950875,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 581.1236948,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 116.3239031875,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 904.6915188124999,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 2.3506801476250003,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 2.78152454925,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 517.20274105,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 224.76999999999998,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 15.37,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 0.29506447543750003,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 0.996469141625,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 0.7054249274875001,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.21872466618749997,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 34.9608760125,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 34.9608760125,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 2.196,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 6.344,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 0.53251752025,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 4.63914659,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 826.6514933237501,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 170.53027110000002,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 50.702636730769235,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 95.88295354687503,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 154.09249685125002,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 16.628974915000004,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 36.144719885,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 16.266666666666666,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 9.425703961979167,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 58.11236947999999,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 27.696167425595238,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 19.24875571941489,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 13.059334153472225,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 25.286586811363634,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 73.88610586428571,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 24.974444444444444,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 17.07777777777778,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 24.588706286458336,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 76.6514724326923,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 4.408905796796875,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 16.82497432211538,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 8.740219003125,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 91.50000000000001,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 42.29333333333333,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 3.550116801666667,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 3.865955491666667,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 32.956713875000005,
//                         "hasRDI": true,
//                         "daily": 50.702636730769235,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 19.176590709375006,
//                                 "hasRDI": true,
//                                 "daily": 95.88295354687503,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 9.616376949275,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 1.525122786775,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 462.27749055375,
//                         "hasRDI": true,
//                         "daily": 154.09249685125002,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 4.157243728750001,
//                                 "hasRDI": true,
//                                 "daily": 16.628974915000004,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 455.46998020625,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 430.10098020625,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 18.0723599425,
//                         "hasRDI": true,
//                         "daily": 36.144719885,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 48.8,
//                         "hasRDI": true,
//                         "daily": 16.266666666666666,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 226.2168950875,
//                         "hasRDI": true,
//                         "daily": 9.425703961979167,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 581.1236948,
//                         "hasRDI": true,
//                         "daily": 58.11236947999999,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 116.3239031875,
//                         "hasRDI": true,
//                         "daily": 27.696167425595238,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 904.6915188124999,
//                         "hasRDI": true,
//                         "daily": 19.24875571941489,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 2.3506801476250003,
//                         "hasRDI": true,
//                         "daily": 13.059334153472225,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 2.78152454925,
//                         "hasRDI": true,
//                         "daily": 25.286586811363634,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 517.20274105,
//                         "hasRDI": true,
//                         "daily": 73.88610586428571,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 224.76999999999998,
//                         "hasRDI": true,
//                         "daily": 24.974444444444444,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 15.37,
//                         "hasRDI": true,
//                         "daily": 17.07777777777778,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 0.29506447543750003,
//                         "hasRDI": true,
//                         "daily": 24.588706286458336,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 0.996469141625,
//                         "hasRDI": true,
//                         "daily": 76.6514724326923,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 0.7054249274875001,
//                         "hasRDI": true,
//                         "daily": 4.408905796796875,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.21872466618749997,
//                         "hasRDI": true,
//                         "daily": 16.82497432211538,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 34.9608760125,
//                         "hasRDI": true,
//                         "daily": 8.740219003125,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 34.9608760125,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 2.196,
//                         "hasRDI": true,
//                         "daily": 91.50000000000001,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 6.344,
//                         "hasRDI": true,
//                         "daily": 42.29333333333333,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 0.53251752025,
//                         "hasRDI": true,
//                         "daily": 3.550116801666667,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 4.63914659,
//                         "hasRDI": true,
//                         "daily": 3.865955491666667,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 826.6514933237501,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_70b4465eaee604e8f23ed1f9df2f37ac",
//                 "label": "Milk Punch",
//                 "image": "https://www.edamam.com/web-img/b6f/b6faf987cd257636f01b50cf02124278.jpg",
//                 "source": "Smitten Kitchen",
//                 "url": "http://smittenkitchen.com/2010/12/milk-punch/",
//                 "shareAs": "http://www.edamam.com/recipe/milk-punch-70b4465eaee604e8f23ed1f9df2f37ac/milk",
//                 "yield": 6,
//                 "dietLabels": [],
//                 "healthLabels": [
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "No oil added",
//                     "Kosher"
//                 ],
//                 "cautions": [
//                     "Gluten",
//                     "Wheat",
//                     "Sulfites"
//                 ],
//                 "ingredientLines": [
//                     "5 cups of a mixture of whole milk and half-and-half (4:1 is suggested, but I might go more like 3:2 next time)",
//                     "1 1/2 cups bourbon, another whiskey or brandy",
//                     "1 cup powdered sugar, sifted",
//                     "1 tablespoon vanilla extract",
//                     "Freshly grated nutmeg, for garnish."
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "5 cups of a mixture of whole milk and half-and-half (4:1 is suggested, but I might go more like 3:2 next time)",
//                         "quantity": 5,
//                         "measure": "cup",
//                         "food": "whole milk",
//                         "weight": 1220,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "5 cups of a mixture of whole milk and half-and-half (4:1 is suggested, but I might go more like 3:2 next time)",
//                         "quantity": 0,
//                         "measure": null,
//                         "food": "half-and-half",
//                         "weight": 0,
//                         "foodCategory": "Dairy",
//                         "foodId": "food_bhxfjwwbw6wqyjaxv9zugbqayb0p",
//                         "image": "https://www.edamam.com/food-img/8f6/8f6397fd80a05aa12ee3b990737388a5.jpg"
//                     },
//                     {
//                         "text": "1 1/2 cups bourbon, another whiskey or brandy",
//                         "quantity": 1.5,
//                         "measure": "cup",
//                         "food": "whiskey",
//                         "weight": 333.6,
//                         "foodCategory": "liquors and cocktails",
//                         "foodId": "food_bbt0i11acd5rx6b2l3hwaas5ro3v",
//                         "image": "https://www.edamam.com/food-img/068/0682aefc964db752b41c04dece4bedcb.jpg"
//                     },
//                     {
//                         "text": "1 cup powdered sugar, sifted",
//                         "quantity": 1,
//                         "measure": "cup",
//                         "food": "powdered sugar",
//                         "weight": 100,
//                         "foodCategory": "sugars",
//                         "foodId": "food_b7rbtshahirxisbtyc77sbv8jdue",
//                         "image": "https://www.edamam.com/food-img/290/290624aa4c0e279551e462443e38bb40.jpg"
//                     },
//                     {
//                         "text": "1 tablespoon vanilla extract",
//                         "quantity": 1,
//                         "measure": "tablespoon",
//                         "food": "vanilla extract",
//                         "weight": 13,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_bh1wvnqaw3q7ciascfoygaabax2a",
//                         "image": "https://www.edamam.com/food-img/90f/90f910b0bf82750d4f6528263e014cca.jpg"
//                     },
//                     {
//                         "text": "Freshly grated nutmeg, for garnish.",
//                         "quantity": 0,
//                         "measure": null,
//                         "food": "grated nutmeg",
//                         "weight": 0,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_aa8vp2kadkkiiubgpp48fazrqiq2",
//                         "image": "https://www.edamam.com/food-img/b9e/b9e54f78ae18cf99a6504b472ba25e7b.jpg"
//                     }
//                 ],
//                 "calories": 2004.6400000000003,
//                 "totalWeight": 1666.6,
//                 "totalTime": 0,
//                 "cuisineType": [
//                     "british"
//                 ],
//                 "mealType": [
//                     "lunch/dinner"
//                 ],
//                 "dishType": [
//                     "drinks"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 2004.6400000000003,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 39.65780000000001,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 22.7543,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 9.907700000000002,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 2.3795200000000003,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 160.3081,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 161.0645,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 97.81,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 38.4378,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 122.00000000000001,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 531.106,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 1381.0300000000002,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 123.56000000000003,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 1638.3120000000001,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 0.5750399999999999,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 4.671740000000001,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 1038.9240000000002,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 561.2,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 0,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 0.5826460000000001,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 2.1064940000000005,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 1.1844180000000002,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.445916,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 61.00000000000001,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 61.00000000000001,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 5.49,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 15.860000000000001,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 0.8540000000000002,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 3.66,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 1295.4218,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 100.23200000000001,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 61.01200000000001,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 113.77150000000002,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 53.436033333333334,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 0,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 76.8756,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 40.66666666666667,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 22.129416666666668,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 138.10300000000004,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 29.419047619047628,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 34.85770212765958,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 3.194666666666666,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 42.47036363636364,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 148.4177142857143,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 62.35555555555556,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 0,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 48.553833333333344,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 162.03800000000004,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 7.402612500000001,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 34.30123076923077,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 15.250000000000002,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 228.75,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 105.73333333333335,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 5.693333333333334,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 3.05,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 39.65780000000001,
//                         "hasRDI": true,
//                         "daily": 61.01200000000001,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 22.7543,
//                                 "hasRDI": true,
//                                 "daily": 113.77150000000002,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 9.907700000000002,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 2.3795200000000003,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 160.3081,
//                         "hasRDI": true,
//                         "daily": 53.436033333333334,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 0,
//                                 "hasRDI": true,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 161.0645,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 97.81,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 38.4378,
//                         "hasRDI": true,
//                         "daily": 76.8756,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 122.00000000000001,
//                         "hasRDI": true,
//                         "daily": 40.66666666666667,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 531.106,
//                         "hasRDI": true,
//                         "daily": 22.129416666666668,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 1381.0300000000002,
//                         "hasRDI": true,
//                         "daily": 138.10300000000004,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 123.56000000000003,
//                         "hasRDI": true,
//                         "daily": 29.419047619047628,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 1638.3120000000001,
//                         "hasRDI": true,
//                         "daily": 34.85770212765958,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 0.5750399999999999,
//                         "hasRDI": true,
//                         "daily": 3.194666666666666,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 4.671740000000001,
//                         "hasRDI": true,
//                         "daily": 42.47036363636364,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 1038.9240000000002,
//                         "hasRDI": true,
//                         "daily": 148.4177142857143,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 561.2,
//                         "hasRDI": true,
//                         "daily": 62.35555555555556,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": true,
//                         "daily": 0,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 0.5826460000000001,
//                         "hasRDI": true,
//                         "daily": 48.553833333333344,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 2.1064940000000005,
//                         "hasRDI": true,
//                         "daily": 162.03800000000004,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 1.1844180000000002,
//                         "hasRDI": true,
//                         "daily": 7.402612500000001,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.445916,
//                         "hasRDI": true,
//                         "daily": 34.30123076923077,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 61.00000000000001,
//                         "hasRDI": true,
//                         "daily": 15.250000000000002,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 61.00000000000001,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 5.49,
//                         "hasRDI": true,
//                         "daily": 228.75,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 15.860000000000001,
//                         "hasRDI": true,
//                         "daily": 105.73333333333335,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 0.8540000000000002,
//                         "hasRDI": true,
//                         "daily": 5.693333333333334,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 3.66,
//                         "hasRDI": true,
//                         "daily": 3.05,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 1295.4218,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_290727e0c9bc98848a7f0225c80e4314",
//                 "label": "Strawberry Milk",
//                 "image": "https://www.edamam.com/web-img/9c3/9c33940a117c378a3dc189ab098a5201.jpg",
//                 "source": "Simply Recipes",
//                 "url": "http://simplyrecipes.com/recipes/strawberry_milk/",
//                 "shareAs": "http://www.edamam.com/recipe/strawberry-milk-290727e0c9bc98848a7f0225c80e4314/milk",
//                 "yield": 2,
//                 "dietLabels": [
//                     "Balanced",
//                     "Low-Sodium"
//                 ],
//                 "healthLabels": [
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "Alcohol-Free",
//                     "No oil added",
//                     "Kosher"
//                 ],
//                 "cautions": [
//                     "Sulfites"
//                 ],
//                 "ingredientLines": [
//                     "1-2 cups milk",
//                     "A handful of strawberries, rinsed, stems removed",
//                     "1 to 3 Tbsp honey"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "1-2 cups milk",
//                         "quantity": 1.5,
//                         "measure": "cup",
//                         "food": "milk",
//                         "weight": 366,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "A handful of strawberries, rinsed, stems removed",
//                         "quantity": 1,
//                         "measure": "handful",
//                         "food": "strawberries",
//                         "weight": 22.3125,
//                         "foodCategory": "fruit",
//                         "foodId": "food_b4s2ibkbrrucmbabbaxhfau8ay42",
//                         "image": "https://www.edamam.com/food-img/00c/00c8851e401bf7975be7f73499b4b573.jpg"
//                     },
//                     {
//                         "text": "1 to 3 Tbsp honey",
//                         "quantity": 2,
//                         "measure": "tablespoon",
//                         "food": "honey",
//                         "weight": 42,
//                         "foodCategory": null,
//                         "foodId": "food_bn6aoj9atkqx8fbkli859bbbxx62",
//                         "image": "https://www.edamam.com/food-img/198/198c7b25c23b4235b4cc33818c7b335f.jpg"
//                     }
//                 ],
//                 "calories": 358.08000000000004,
//                 "totalWeight": 430.3125,
//                 "totalTime": 0,
//                 "cuisineType": [
//                     "american"
//                 ],
//                 "mealType": [
//                     "lunch/dinner"
//                 ],
//                 "dishType": [
//                     "drinks"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 358.08000000000004,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 11.9619375,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 6.829246875,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 2.981514375,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 0.748284375,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 53.8896,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 0.53025,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 54.06448125,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 34.4904,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 11.804493749999999,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 36.6,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 159.283125,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 419.67,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 40.340625,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 539.0981250000001,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 0.37768124999999997,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 1.4778375000000001,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 314.475,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 168.58312500000002,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 13.32975,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 0.173715,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 0.6394087500000001,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 0.46268624999999997,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.152326875,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 24.495,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 24.495,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 1.647,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 4.758,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 0.32090625000000006,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 1.5888750000000003,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 350.03101875,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 17.904000000000003,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 18.40298076923077,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 34.146234375,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 17.9632,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 2.121,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 23.608987499999998,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 12.2,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 6.636796875000001,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 41.967,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 9.604910714285715,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 11.470172872340427,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 2.0982291666666666,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 13.434886363636366,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 44.925000000000004,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 18.731458333333336,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 14.810833333333335,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 14.476250000000002,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 49.18528846153846,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 2.8917890625,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 11.717451923076924,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 6.12375,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 68.625,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 31.720000000000002,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 2.1393750000000002,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 1.3240625000000001,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 11.9619375,
//                         "hasRDI": true,
//                         "daily": 18.40298076923077,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 6.829246875,
//                                 "hasRDI": true,
//                                 "daily": 34.146234375,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 2.981514375,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 0.748284375,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 53.8896,
//                         "hasRDI": true,
//                         "daily": 17.9632,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 0.53025,
//                                 "hasRDI": true,
//                                 "daily": 2.121,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 54.06448125,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 34.4904,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 11.804493749999999,
//                         "hasRDI": true,
//                         "daily": 23.608987499999998,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 36.6,
//                         "hasRDI": true,
//                         "daily": 12.2,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 159.283125,
//                         "hasRDI": true,
//                         "daily": 6.636796875000001,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 419.67,
//                         "hasRDI": true,
//                         "daily": 41.967,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 40.340625,
//                         "hasRDI": true,
//                         "daily": 9.604910714285715,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 539.0981250000001,
//                         "hasRDI": true,
//                         "daily": 11.470172872340427,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 0.37768124999999997,
//                         "hasRDI": true,
//                         "daily": 2.0982291666666666,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 1.4778375000000001,
//                         "hasRDI": true,
//                         "daily": 13.434886363636366,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 314.475,
//                         "hasRDI": true,
//                         "daily": 44.925000000000004,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 168.58312500000002,
//                         "hasRDI": true,
//                         "daily": 18.731458333333336,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 13.32975,
//                         "hasRDI": true,
//                         "daily": 14.810833333333335,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 0.173715,
//                         "hasRDI": true,
//                         "daily": 14.476250000000002,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 0.6394087500000001,
//                         "hasRDI": true,
//                         "daily": 49.18528846153846,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 0.46268624999999997,
//                         "hasRDI": true,
//                         "daily": 2.8917890625,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.152326875,
//                         "hasRDI": true,
//                         "daily": 11.717451923076924,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 24.495,
//                         "hasRDI": true,
//                         "daily": 6.12375,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 24.495,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 1.647,
//                         "hasRDI": true,
//                         "daily": 68.625,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 4.758,
//                         "hasRDI": true,
//                         "daily": 31.720000000000002,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 0.32090625000000006,
//                         "hasRDI": true,
//                         "daily": 2.1393750000000002,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 1.5888750000000003,
//                         "hasRDI": true,
//                         "daily": 1.3240625000000001,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 350.03101875,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_0eea3968f71f4b365ddeaf2407d2c75b",
//                 "label": "Condensed Milk Ice Cream",
//                 "image": "https://www.edamam.com/web-img/76d/76db7df7d859936a8aa2eb00ee62e312.jpg",
//                 "source": "Seven Spoons",
//                 "url": "http://www.sevenspoons.net/blog/2009/11/18/an-impatient-age.html",
//                 "shareAs": "http://www.edamam.com/recipe/condensed-milk-ice-cream-0eea3968f71f4b365ddeaf2407d2c75b/milk",
//                 "yield": 12,
//                 "dietLabels": [
//                     "Low-Sodium"
//                 ],
//                 "healthLabels": [
//                     "Kidney-Friendly",
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Mediterranean",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "Alcohol-Free",
//                     "No oil added",
//                     "Sulfite-Free",
//                     "Kosher"
//                 ],
//                 "cautions": [
//                     "Sulfites"
//                 ],
//                 "ingredientLines": [
//                     "1 14-ounce can sweetened condensed milk",
//                     "1 14-ounce can evaporated milk",
//                     "1 fresh vanilla bean",
//                     "3 xgreen cardamom cloves, bruised but not broken (optional)",
//                     "A generous pinch of kosher salt",
//                     "1 to 1 1/2 cups heavy cream"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "1 14-ounce can sweetened condensed milk",
//                         "quantity": 14,
//                         "measure": "ounce",
//                         "food": "sweetened condensed milk",
//                         "weight": 396.89332375000004,
//                         "foodCategory": "Milk",
//                         "foodId": "food_a89byenbz1jssabxmx7i6aa77jz1",
//                         "image": "https://www.edamam.com/food-img/bc9/bc97e9aa15ccef74dbad4d6267e30e3f.jpg"
//                     },
//                     {
//                         "text": "1 14-ounce can evaporated milk",
//                         "quantity": 14,
//                         "measure": "ounce",
//                         "food": "evaporated milk",
//                         "weight": 396.89332375000004,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b5vvoi3bbh7uenae22mbjaz51y79",
//                         "image": "https://www.edamam.com/food-img/07a/07a7a508fcf9a2f8ea0f34a493f76529.jpg"
//                     },
//                     {
//                         "text": "1 fresh vanilla bean",
//                         "quantity": 1,
//                         "measure": "<unit>",
//                         "food": "vanilla bean",
//                         "weight": 5,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_bh1wvnqaw3q7ciascfoygaabax2a",
//                         "image": "https://www.edamam.com/food-img/90f/90f910b0bf82750d4f6528263e014cca.jpg"
//                     },
//                     {
//                         "text": "3 xgreen cardamom cloves, bruised but not broken (optional)",
//                         "quantity": 3,
//                         "measure": "<unit>",
//                         "food": "cloves",
//                         "weight": 0.44999999999999996,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_abb00nxbw761ggavcuto7b3mw1s0",
//                         "image": "https://www.edamam.com/food-img/8bc/8bc63f9742815a245d37e5f346674ca4.jpg"
//                     },
//                     {
//                         "text": "A generous pinch of kosher salt",
//                         "quantity": 1,
//                         "measure": "pinch",
//                         "food": "kosher salt",
//                         "weight": 0.30338541705136723,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_a1vgrj1bs8rd1majvmd9ubz8ttkg",
//                         "image": "https://www.edamam.com/food-img/694/6943ea510918c6025795e8dc6e6eaaeb.jpg"
//                     },
//                     {
//                         "text": "1 to 1 1/2 cups heavy cream",
//                         "quantity": 1.25,
//                         "measure": "cup",
//                         "food": "heavy cream",
//                         "weight": 297.5,
//                         "foodCategory": "Dairy",
//                         "foodId": "food_bgtkr21b5v16mca246x9ebnaswyo",
//                         "image": "https://www.edamam.com/food-img/484/4848d71f6a14dd5076083f5e17925420.jpg"
//                     }
//                 ],
//                 "calories": 2847.8726230624998,
//                 "totalWeight": 1097.0400329170516,
//                 "totalTime": 0,
//                 "cuisineType": [
//                     "american"
//                 ],
//                 "mealType": [
//                     "lunch/dinner"
//                 ],
//                 "dishType": [
//                     "desserts"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 2847.8726230624998,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 174.67135444175,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 108.53342423428751,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0.001143,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 50.69767857697501,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 6.413996144225001,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 264.9856928245,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 0.15255,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 264.7015178245,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 64.551312256,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 657.6177939625,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 1157.094064278269,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 2359.910426937593,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 221.04019572917053,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 2910.2002729083642,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 1.6576808021262694,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 7.4873692215420515,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 1995.0515563000004,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 1774.4427200125,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 19.646099568750003,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 0.6104548535375002,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 3.23824912985,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 1.74774402795,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.48127175698750013,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 87.4222315125,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 87.4222315125,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 2.9168599425,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 10.8141531225,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 4.38386997125,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 14.52392656125,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 576.0173154058342,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 142.393631153125,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 268.7251606796154,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 542.6671211714375,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 88.32856427483334,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 0.6102,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 129.102624512,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 219.20593132083334,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 48.21225267826121,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 235.9910426937593,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 52.628618030754886,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 61.91915474273116,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 9.209337789590386,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 68.06699292310955,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 285.0073651857143,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 197.16030222361113,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 21.828999520833335,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 50.87123779479168,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 249.09608691153844,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 10.923400174687501,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 37.02090438365386,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 21.855557878125,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 121.5358309375,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 72.09435415,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 29.22579980833333,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 12.103272134375,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 174.67135444175,
//                         "hasRDI": true,
//                         "daily": 268.7251606796154,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 108.53342423428751,
//                                 "hasRDI": true,
//                                 "daily": 542.6671211714375,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0.001143,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 50.69767857697501,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 6.413996144225001,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 264.9856928245,
//                         "hasRDI": true,
//                         "daily": 88.32856427483334,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 0.15255,
//                                 "hasRDI": true,
//                                 "daily": 0.6102,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 264.7015178245,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 64.551312256,
//                         "hasRDI": true,
//                         "daily": 129.102624512,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 657.6177939625,
//                         "hasRDI": true,
//                         "daily": 219.20593132083334,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 1157.094064278269,
//                         "hasRDI": true,
//                         "daily": 48.21225267826121,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 2359.910426937593,
//                         "hasRDI": true,
//                         "daily": 235.9910426937593,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 221.04019572917053,
//                         "hasRDI": true,
//                         "daily": 52.628618030754886,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 2910.2002729083642,
//                         "hasRDI": true,
//                         "daily": 61.91915474273116,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 1.6576808021262694,
//                         "hasRDI": true,
//                         "daily": 9.209337789590386,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 7.4873692215420515,
//                         "hasRDI": true,
//                         "daily": 68.06699292310955,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 1995.0515563000004,
//                         "hasRDI": true,
//                         "daily": 285.0073651857143,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 1774.4427200125,
//                         "hasRDI": true,
//                         "daily": 197.16030222361113,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 19.646099568750003,
//                         "hasRDI": true,
//                         "daily": 21.828999520833335,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 0.6104548535375002,
//                         "hasRDI": true,
//                         "daily": 50.87123779479168,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 3.23824912985,
//                         "hasRDI": true,
//                         "daily": 249.09608691153844,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 1.74774402795,
//                         "hasRDI": true,
//                         "daily": 10.923400174687501,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.48127175698750013,
//                         "hasRDI": true,
//                         "daily": 37.02090438365386,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 87.4222315125,
//                         "hasRDI": true,
//                         "daily": 21.855557878125,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 87.4222315125,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 2.9168599425,
//                         "hasRDI": true,
//                         "daily": 121.5358309375,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 10.8141531225,
//                         "hasRDI": true,
//                         "daily": 72.09435415,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 4.38386997125,
//                         "hasRDI": true,
//                         "daily": 29.22579980833333,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 14.52392656125,
//                         "hasRDI": true,
//                         "daily": 12.103272134375,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 576.0173154058342,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_17f83b1c1c844c54d12cf605b81ea9ca",
//                 "label": "Strawberry milk pops",
//                 "image": "https://www.edamam.com/web-img/82f/82fb4a65a5bf2fb38b8953d57043e5eb.jpg",
//                 "source": "BBC Good Food",
//                 "url": "https://www.bbcgoodfood.com/recipes/strawberry-milk-pops",
//                 "shareAs": "http://www.edamam.com/recipe/strawberry-milk-pops-17f83b1c1c844c54d12cf605b81ea9ca/milk",
//                 "yield": 12,
//                 "dietLabels": [
//                     "Low-Sodium"
//                 ],
//                 "healthLabels": [
//                     "Kidney-Friendly",
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Mediterranean",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "Alcohol-Free",
//                     "No oil added",
//                     "Sulfite-Free",
//                     "Kosher",
//                     "Immuno-Supportive"
//                 ],
//                 "cautions": [
//                     "Sulfites"
//                 ],
//                 "ingredientLines": [
//                     "400g ripe strawberry",
//                     "200ml semi-skimmed milk",
//                     "405g can light condensed milk"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "400g ripe strawberry",
//                         "quantity": 400,
//                         "measure": "gram",
//                         "food": "strawberry",
//                         "weight": 400,
//                         "foodCategory": "fruit",
//                         "foodId": "food_b4s2ibkbrrucmbabbaxhfau8ay42",
//                         "image": "https://www.edamam.com/food-img/00c/00c8851e401bf7975be7f73499b4b573.jpg"
//                     },
//                     {
//                         "text": "200ml semi-skimmed milk",
//                         "quantity": 200,
//                         "measure": "milliliter",
//                         "food": "milk",
//                         "weight": 206.26553848124226,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "405g can light condensed milk",
//                         "quantity": 405,
//                         "measure": "gram",
//                         "food": "condensed milk",
//                         "weight": 405,
//                         "foodCategory": "Milk",
//                         "foodId": "food_a89byenbz1jssabxmx7i6aa77jz1",
//                         "image": "https://www.edamam.com/food-img/bc9/bc97e9aa15ccef74dbad4d6267e30e3f.jpg"
//                     }
//                 ],
//                 "calories": 1553.8719784735576,
//                 "totalWeight": 1011.2655384812423,
//                 "totalTime": 10,
//                 "cuisineType": [
//                     "american"
//                 ],
//                 "mealType": [
//                     "lunch/dinner"
//                 ],
//                 "dishType": [
//                     "desserts"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 1553.8719784735576,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 43.13863000064037,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 26.125152292675168,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 11.676226172467686,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 2.3870678000384227,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 260.9407458470996,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 8,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 250.29640969330273,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 41.21286446215913,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 158.3265538481242,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 607.0441815469342,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 1447.2800584838037,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 177.92655384812423,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 2386.82051079524,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 2.4713796615443724,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 5.130182492380596,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 1293.9130523242434,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 398.58214770137147,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 245.73,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 0.5553821477013714,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 2.1213887600332995,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 2.5780763292483058,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.46880559385324716,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 150.86327692406212,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 150.86327692406212,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 2.71019492316559,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 3.4914520002561495,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 1.9523858769368694,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 11.848796615443728,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 655.5798190635189,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 77.69359892367788,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 66.36712307790826,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 130.62576146337582,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 86.98024861569986,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 32,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 82.42572892431826,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 52.77551794937474,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 25.29350756445559,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 144.72800584838035,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 42.363465201934346,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 50.78341512330297,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 13.729887008579846,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 46.63802265800542,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 184.84472176060618,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 44.286905300152384,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 273.03333333333336,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 46.28184564178095,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 163.18375077179226,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 16.11297705780191,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 36.06196875794209,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 37.71581923101553,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 112.92478846523294,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 23.27634666837433,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 13.015905846245797,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 9.87399717953644,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 43.13863000064037,
//                         "hasRDI": true,
//                         "daily": 66.36712307790826,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 26.125152292675168,
//                                 "hasRDI": true,
//                                 "daily": 130.62576146337582,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 11.676226172467686,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 2.3870678000384227,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 260.9407458470996,
//                         "hasRDI": true,
//                         "daily": 86.98024861569986,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 8,
//                                 "hasRDI": true,
//                                 "daily": 32,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 250.29640969330273,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 41.21286446215913,
//                         "hasRDI": true,
//                         "daily": 82.42572892431826,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 158.3265538481242,
//                         "hasRDI": true,
//                         "daily": 52.77551794937474,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 607.0441815469342,
//                         "hasRDI": true,
//                         "daily": 25.29350756445559,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 1447.2800584838037,
//                         "hasRDI": true,
//                         "daily": 144.72800584838035,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 177.92655384812423,
//                         "hasRDI": true,
//                         "daily": 42.363465201934346,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 2386.82051079524,
//                         "hasRDI": true,
//                         "daily": 50.78341512330297,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 2.4713796615443724,
//                         "hasRDI": true,
//                         "daily": 13.729887008579846,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 5.130182492380596,
//                         "hasRDI": true,
//                         "daily": 46.63802265800542,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 1293.9130523242434,
//                         "hasRDI": true,
//                         "daily": 184.84472176060618,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 398.58214770137147,
//                         "hasRDI": true,
//                         "daily": 44.286905300152384,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 245.73,
//                         "hasRDI": true,
//                         "daily": 273.03333333333336,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 0.5553821477013714,
//                         "hasRDI": true,
//                         "daily": 46.28184564178095,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 2.1213887600332995,
//                         "hasRDI": true,
//                         "daily": 163.18375077179226,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 2.5780763292483058,
//                         "hasRDI": true,
//                         "daily": 16.11297705780191,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.46880559385324716,
//                         "hasRDI": true,
//                         "daily": 36.06196875794209,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 150.86327692406212,
//                         "hasRDI": true,
//                         "daily": 37.71581923101553,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 150.86327692406212,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 2.71019492316559,
//                         "hasRDI": true,
//                         "daily": 112.92478846523294,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 3.4914520002561495,
//                         "hasRDI": true,
//                         "daily": 23.27634666837433,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 1.9523858769368694,
//                         "hasRDI": true,
//                         "daily": 13.015905846245797,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 11.848796615443728,
//                         "hasRDI": true,
//                         "daily": 9.87399717953644,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 655.5798190635189,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_3ece6114847ddec1d156d118ef4c0f51",
//                 "label": "Milk Peas",
//                 "image": "https://www.edamam.com/web-img/800/8002ac5eeef852e8a6075291fbdc59a8.jpg",
//                 "source": "Food52",
//                 "url": "http://www.food52.com/recipes/11802_milk_peas",
//                 "shareAs": "http://www.edamam.com/recipe/milk-peas-3ece6114847ddec1d156d118ef4c0f51/milk",
//                 "yield": 4,
//                 "dietLabels": [
//                     "Balanced"
//                 ],
//                 "healthLabels": [
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "Alcohol-Free",
//                     "Sulfite-Free",
//                     "Kosher",
//                     "Immuno-Supportive"
//                 ],
//                 "cautions": [
//                     "Sulfites"
//                 ],
//                 "ingredientLines": [
//                     "2 1/2 cups fresh peas",
//                     "1 1/2 cup whole milk",
//                     "Salt",
//                     "4 pats unsalted butter",
//                     "Freshly grated zest of 1/2 lemon",
//                     "Freshly ground black pepper"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "2 1/2 cups fresh peas",
//                         "quantity": 2.5,
//                         "measure": "cup",
//                         "food": "peas",
//                         "weight": 362.5,
//                         "foodCategory": "vegetables",
//                         "foodId": "food_bbi35jtbjt7un9bsa2m7eazlsk91",
//                         "image": "https://www.edamam.com/food-img/5ed/5ed641d646c028598a90bdb9ece34fc8.jpg"
//                     },
//                     {
//                         "text": "1 1/2 cup whole milk",
//                         "quantity": 1.5,
//                         "measure": "cup",
//                         "food": "whole milk",
//                         "weight": 366,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "Salt",
//                         "quantity": 0,
//                         "measure": null,
//                         "food": "Salt",
//                         "weight": 4.665,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_btxz81db72hwbra2pncvebzzzum9",
//                         "image": "https://www.edamam.com/food-img/694/6943ea510918c6025795e8dc6e6eaaeb.jpg"
//                     },
//                     {
//                         "text": "4 pats unsalted butter",
//                         "quantity": 4,
//                         "measure": "pat",
//                         "food": "unsalted butter",
//                         "weight": 20,
//                         "foodCategory": "Dairy",
//                         "foodId": "food_awz3iefajbk1fwahq9logahmgltj",
//                         "image": "https://www.edamam.com/food-img/713/71397239b670d88c04faa8d05035cab4.jpg"
//                     },
//                     {
//                         "text": "Freshly grated zest of 1/2 lemon",
//                         "quantity": 0.5,
//                         "measure": "<unit>",
//                         "food": "lemon",
//                         "weight": 29,
//                         "foodCategory": "fruit",
//                         "foodId": "food_a6uzc62astrxcgbtzyq59b6fncrr",
//                         "image": "https://www.edamam.com/food-img/70a/70acba3d4c734d7c70ef4efeed85dc8f.jpg"
//                     },
//                     {
//                         "text": "Freshly ground black pepper",
//                         "quantity": 0,
//                         "measure": null,
//                         "food": "black pepper",
//                         "weight": 2.3325,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_b6ywzluaaxv02wad7s1r9ag4py89",
//                         "image": "https://www.edamam.com/food-img/c6e/c6e5c3bd8d3bc15175d9766971a4d1b2.jpg"
//                     }
//                 ],
//                 "calories": 674.5495749999999,
//                 "totalWeight": 784.0502960217245,
//                 "totalTime": 0,
//                 "cuisineType": [
//                     "british"
//                 ],
//                 "mealType": [
//                     "lunch/dinner"
//                 ],
//                 "dishType": [
//                     "drinks"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 674.5495749999999,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 29.7300395,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 17.400653400000003,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0.6556000000000001,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 7.323422175000001,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 2.04926335,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 74.15568375,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 19.889622499999998,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 39.788678,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 31.90784675,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 79.6,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 1813.4848820999998,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 527.890246045214,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 162.97575296021725,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 1443.776348681738,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 5.8569544768716915,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 5.9165745460217245,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 712.06535,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 443.82977500000004,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 160.37,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 1.1477291,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 1.1138385000000002,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 7.966050474999999,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.7749725750000002,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 258.11152500000003,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 258.11152500000003,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 1.681,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 5.058,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 1.259208,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 96.21630250000001,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 638.1145650920434,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 33.727478749999996,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 45.73852230769231,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 87.00326700000002,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 24.71856125,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 79.55848999999999,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 63.815693499999995,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 26.53333333333333,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 75.5618700875,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 52.7890246045214,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 38.80375070481363,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 30.718645716632725,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 32.538635982620505,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 53.78704132747023,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 101.72362142857143,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 49.31441944444445,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 178.1888888888889,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 95.64409166666668,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 85.67988461538464,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 49.78781546875,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 59.61327500000001,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 64.52788125000001,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 70.04166666666667,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 33.72,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 8.394720000000001,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 80.18025208333334,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 29.7300395,
//                         "hasRDI": true,
//                         "daily": 45.73852230769231,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 17.400653400000003,
//                                 "hasRDI": true,
//                                 "daily": 87.00326700000002,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0.6556000000000001,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 7.323422175000001,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 2.04926335,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 74.15568375,
//                         "hasRDI": true,
//                         "daily": 24.71856125,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 19.889622499999998,
//                                 "hasRDI": true,
//                                 "daily": 79.55848999999999,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 39.788678,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 31.90784675,
//                         "hasRDI": true,
//                         "daily": 63.815693499999995,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 79.6,
//                         "hasRDI": true,
//                         "daily": 26.53333333333333,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 1813.4848820999998,
//                         "hasRDI": true,
//                         "daily": 75.5618700875,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 527.890246045214,
//                         "hasRDI": true,
//                         "daily": 52.7890246045214,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 162.97575296021725,
//                         "hasRDI": true,
//                         "daily": 38.80375070481363,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 1443.776348681738,
//                         "hasRDI": true,
//                         "daily": 30.718645716632725,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 5.8569544768716915,
//                         "hasRDI": true,
//                         "daily": 32.538635982620505,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 5.9165745460217245,
//                         "hasRDI": true,
//                         "daily": 53.78704132747023,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 712.06535,
//                         "hasRDI": true,
//                         "daily": 101.72362142857143,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 443.82977500000004,
//                         "hasRDI": true,
//                         "daily": 49.31441944444445,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 160.37,
//                         "hasRDI": true,
//                         "daily": 178.1888888888889,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 1.1477291,
//                         "hasRDI": true,
//                         "daily": 95.64409166666668,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 1.1138385000000002,
//                         "hasRDI": true,
//                         "daily": 85.67988461538464,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 7.966050474999999,
//                         "hasRDI": true,
//                         "daily": 49.78781546875,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.7749725750000002,
//                         "hasRDI": true,
//                         "daily": 59.61327500000001,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 258.11152500000003,
//                         "hasRDI": true,
//                         "daily": 64.52788125000001,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 258.11152500000003,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 1.681,
//                         "hasRDI": true,
//                         "daily": 70.04166666666667,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 5.058,
//                         "hasRDI": true,
//                         "daily": 33.72,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 1.259208,
//                         "hasRDI": true,
//                         "daily": 8.394720000000001,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 96.21630250000001,
//                         "hasRDI": true,
//                         "daily": 80.18025208333334,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 638.1145650920434,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_332aa5ddf4e6fab4b6829fe293ac412a",
//                 "label": "Whole Milk Ricotta",
//                 "image": "https://www.edamam.com/web-img/222/222a38e45a1fd45dcf68ae238daec9a4.jpg",
//                 "source": "Honest Cooking",
//                 "url": "http://honestcooking.com/from-a-vermont-kitchen-whole-milk-ricotta-recipe/",
//                 "shareAs": "http://www.edamam.com/recipe/whole-milk-ricotta-332aa5ddf4e6fab4b6829fe293ac412a/milk",
//                 "yield": 2,
//                 "dietLabels": [],
//                 "healthLabels": [
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Mediterranean",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "Alcohol-Free",
//                     "No oil added",
//                     "Sulfite-Free",
//                     "Kosher"
//                 ],
//                 "cautions": [],
//                 "ingredientLines": [
//                     "2 cups whole milk",
//                     "2 tablespoons vinegar",
//                     "¼ teaspoon kosher salt"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "2 cups whole milk",
//                         "quantity": 2,
//                         "measure": "cup",
//                         "food": "whole milk",
//                         "weight": 488,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "2 tablespoons vinegar",
//                         "quantity": 2,
//                         "measure": "tablespoon",
//                         "food": "vinegar",
//                         "weight": 29.8,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_am3vwadag9arxtadrwyfcau2w3b2",
//                         "image": "https://www.edamam.com/food-img/5f6/5f69b84c399d778c4728e9ab4f8065a2.jpg"
//                     },
//                     {
//                         "text": "¼ teaspoon kosher salt",
//                         "quantity": 0.25,
//                         "measure": "teaspoon",
//                         "food": "kosher salt",
//                         "weight": 1.2135416667282188,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_a1vgrj1bs8rd1majvmd9ubz8ttkg",
//                         "image": "https://www.edamam.com/food-img/694/6943ea510918c6025795e8dc6e6eaaeb.jpg"
//                     }
//                 ],
//                 "calories": 303.044,
//                 "totalWeight": 519.0135416667282,
//                 "totalTime": 5,
//                 "cuisineType": [
//                     "british"
//                 ],
//                 "mealType": [
//                     "breakfast"
//                 ],
//                 "dishType": [
//                     "desserts"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 303.044,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 15.86,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 9.1012,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 3.9625600000000003,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 0.9516,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 23.43592,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 24.65592,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 15.372,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 48.8,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 680.7804791905231,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 553.5192500000147,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 49.11013541666728,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 644.8530833333382,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 0.15934468750020314,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 1.8097935416667281,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 411.112,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 224.48,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 0,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 0.22447999999999999,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 0.82472,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 0.43432,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.17567999999999998,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 24.4,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 24.4,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 2.196,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 6.344,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 0.3416,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 1.464,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 458.3212670833334,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 15.152199999999999,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 24.4,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 45.506,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 7.811973333333333,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 0,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 30.744,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 16.266666666666666,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 28.36585329960513,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 55.35192500000147,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 11.69288938492078,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 13.72027836879443,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 0.8852482638900175,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 16.452668560606618,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 58.73028571428572,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 24.942222222222224,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 0,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 18.706666666666663,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 63.43999999999999,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 2.7144999999999997,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 13.513846153846151,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 6.1,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 91.50000000000001,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 42.29333333333333,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 2.2773333333333334,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 1.22,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 15.86,
//                         "hasRDI": true,
//                         "daily": 24.4,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 9.1012,
//                                 "hasRDI": true,
//                                 "daily": 45.506,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 3.9625600000000003,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 0.9516,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 23.43592,
//                         "hasRDI": true,
//                         "daily": 7.811973333333333,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 0,
//                                 "hasRDI": true,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 24.65592,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 15.372,
//                         "hasRDI": true,
//                         "daily": 30.744,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 48.8,
//                         "hasRDI": true,
//                         "daily": 16.266666666666666,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 680.7804791905231,
//                         "hasRDI": true,
//                         "daily": 28.36585329960513,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 553.5192500000147,
//                         "hasRDI": true,
//                         "daily": 55.35192500000147,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 49.11013541666728,
//                         "hasRDI": true,
//                         "daily": 11.69288938492078,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 644.8530833333382,
//                         "hasRDI": true,
//                         "daily": 13.72027836879443,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 0.15934468750020314,
//                         "hasRDI": true,
//                         "daily": 0.8852482638900175,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 1.8097935416667281,
//                         "hasRDI": true,
//                         "daily": 16.452668560606618,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 411.112,
//                         "hasRDI": true,
//                         "daily": 58.73028571428572,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 224.48,
//                         "hasRDI": true,
//                         "daily": 24.942222222222224,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": true,
//                         "daily": 0,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 0.22447999999999999,
//                         "hasRDI": true,
//                         "daily": 18.706666666666663,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 0.82472,
//                         "hasRDI": true,
//                         "daily": 63.43999999999999,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 0.43432,
//                         "hasRDI": true,
//                         "daily": 2.7144999999999997,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.17567999999999998,
//                         "hasRDI": true,
//                         "daily": 13.513846153846151,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 24.4,
//                         "hasRDI": true,
//                         "daily": 6.1,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 24.4,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 2.196,
//                         "hasRDI": true,
//                         "daily": 91.50000000000001,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 6.344,
//                         "hasRDI": true,
//                         "daily": 42.29333333333333,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 0.3416,
//                         "hasRDI": true,
//                         "daily": 2.2773333333333334,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 1.464,
//                         "hasRDI": true,
//                         "daily": 1.22,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 458.3212670833334,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_0677757f04d943c0f8563285c1da8954",
//                 "label": "Momofuku Milk Bar’s Cereal Milk Ice Cream recipes",
//                 "image": "https://www.edamam.com/web-img/e1a/e1a8a4491ac4e11617264b3740c15939",
//                 "source": "Café Fernando",
//                 "url": "http://cafefernando.com/momofuku-milk-bars-cereal-milk-ice-cream/",
//                 "shareAs": "http://www.edamam.com/recipe/momofuku-milk-bar-s-cereal-milk-ice-cream-recipes-0677757f04d943c0f8563285c1da8954/milk",
//                 "yield": 18,
//                 "dietLabels": [],
//                 "healthLabels": [
//                     "Kidney-Friendly",
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "Alcohol-Free",
//                     "Kosher"
//                 ],
//                 "cautions": [
//                     "Sulfites"
//                 ],
//                 "ingredientLines": [
//                     "10 oz cornflakes",
//                     "2 oz nonfat dry milk powder",
//                     "4 tbsp sugar",
//                     "1/2 tsp salt",
//                     "6,5 oz (one and a half stick) unsalted butter, melted",
//                     "4 cups whole milk",
//                     "14 oz caramelized cornflakes",
//                     "1 cup heavy cream",
//                     "1 cup cereal milk",
//                     "1/2 cup sugar",
//                     "1/4 tsp salt",
//                     "1 tsp vanilla extract",
//                     "4 large egg yolks",
//                     "4 oz caramelized cornflakes, to serve"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "10 oz cornflakes",
//                         "quantity": 10,
//                         "measure": "ounce",
//                         "food": "cornflakes",
//                         "weight": 283.49523125,
//                         "foodCategory": "ready-to-eat cereals",
//                         "foodId": "food_aj8qyl6ap2bot8b2tomgkbsf8c60",
//                         "image": "https://www.edamam.com/food-img/41d/41d5be2eed127f64f9b2c3e74cf6b12b.jpg"
//                     },
//                     {
//                         "text": "2 oz nonfat dry milk powder",
//                         "quantity": 2,
//                         "measure": "ounce",
//                         "food": "milk powder",
//                         "weight": 56.69904625,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b38p7p7ai6h0lia0o4096a01gyiu",
//                         "image": "https://www.edamam.com/food-img/01d/01d896826d7930934f5c9124166c42e9.jpg"
//                     },
//                     {
//                         "text": "4 tbsp sugar",
//                         "quantity": 4,
//                         "measure": "tablespoon",
//                         "food": "sugar",
//                         "weight": 49.9999999991548,
//                         "foodCategory": "sugars",
//                         "foodId": "food_axi2ijobrk819yb0adceobnhm1c2",
//                         "image": "https://www.edamam.com/food-img/ecb/ecb3f5aaed96d0188c21b8369be07765.jpg"
//                     },
//                     {
//                         "text": "1/2 tsp salt",
//                         "quantity": 0.5,
//                         "measure": "teaspoon",
//                         "food": "salt",
//                         "weight": 3,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_btxz81db72hwbra2pncvebzzzum9",
//                         "image": "https://www.edamam.com/food-img/694/6943ea510918c6025795e8dc6e6eaaeb.jpg"
//                     },
//                     {
//                         "text": "6,5 oz (one and a half stick) unsalted butter, melted",
//                         "quantity": 6.5,
//                         "measure": "ounce",
//                         "food": "unsalted butter",
//                         "weight": 184.2719003125,
//                         "foodCategory": "Dairy",
//                         "foodId": "food_awz3iefajbk1fwahq9logahmgltj",
//                         "image": "https://www.edamam.com/food-img/713/71397239b670d88c04faa8d05035cab4.jpg"
//                     },
//                     {
//                         "text": "4 cups whole milk",
//                         "quantity": 4,
//                         "measure": "cup",
//                         "food": "whole milk",
//                         "weight": 976,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "14 oz caramelized cornflakes",
//                         "quantity": 14,
//                         "measure": "ounce",
//                         "food": "cornflakes",
//                         "weight": 396.89332375000004,
//                         "foodCategory": "ready-to-eat cereals",
//                         "foodId": "food_aj8qyl6ap2bot8b2tomgkbsf8c60",
//                         "image": "https://www.edamam.com/food-img/41d/41d5be2eed127f64f9b2c3e74cf6b12b.jpg"
//                     },
//                     {
//                         "text": "1 cup heavy cream",
//                         "quantity": 1,
//                         "measure": "cup",
//                         "food": "heavy cream",
//                         "weight": 238,
//                         "foodCategory": "Dairy",
//                         "foodId": "food_bgtkr21b5v16mca246x9ebnaswyo",
//                         "image": "https://www.edamam.com/food-img/484/4848d71f6a14dd5076083f5e17925420.jpg"
//                     },
//                     {
//                         "text": "1 cup cereal milk",
//                         "quantity": 1,
//                         "measure": "cup",
//                         "food": "milk",
//                         "weight": 244,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "1/2 cup sugar",
//                         "quantity": 0.5,
//                         "measure": "cup",
//                         "food": "sugar",
//                         "weight": 100,
//                         "foodCategory": "sugars",
//                         "foodId": "food_axi2ijobrk819yb0adceobnhm1c2",
//                         "image": "https://www.edamam.com/food-img/ecb/ecb3f5aaed96d0188c21b8369be07765.jpg"
//                     },
//                     {
//                         "text": "1/4 tsp salt",
//                         "quantity": 0.25,
//                         "measure": "teaspoon",
//                         "food": "salt",
//                         "weight": 1.5,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_btxz81db72hwbra2pncvebzzzum9",
//                         "image": "https://www.edamam.com/food-img/694/6943ea510918c6025795e8dc6e6eaaeb.jpg"
//                     },
//                     {
//                         "text": "1 tsp vanilla extract",
//                         "quantity": 1,
//                         "measure": "teaspoon",
//                         "food": "vanilla extract",
//                         "weight": 4.2,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_bh1wvnqaw3q7ciascfoygaabax2a",
//                         "image": "https://www.edamam.com/food-img/90f/90f910b0bf82750d4f6528263e014cca.jpg"
//                     },
//                     {
//                         "text": "4 large egg yolks",
//                         "quantity": 4,
//                         "measure": "<unit>",
//                         "food": "egg yolks",
//                         "weight": 68,
//                         "foodCategory": "Eggs",
//                         "foodId": "food_awlnigdb6qm6i1biwv7rlalfg2ni",
//                         "image": "https://www.edamam.com/food-img/e3f/e3f697887aec0e8ecf09a9ca8ef3944a.jpg"
//                     },
//                     {
//                         "text": "4 oz caramelized cornflakes, to serve",
//                         "quantity": 4,
//                         "measure": "ounce",
//                         "food": "cornflakes",
//                         "weight": 113.3980925,
//                         "foodCategory": "ready-to-eat cereals",
//                         "foodId": "food_aj8qyl6ap2bot8b2tomgkbsf8c60",
//                         "image": "https://www.edamam.com/food-img/41d/41d5be2eed127f64f9b2c3e74cf6b12b.jpg"
//                     }
//                 ],
//                 "calories": 6813.1311262123545,
//                 "totalWeight": 2714.9575940616546,
//                 "totalTime": 90,
//                 "cuisineType": [
//                     "american"
//                 ],
//                 "mealType": [
//                     "lunch/dinner"
//                 ],
//                 "dishType": [
//                     "desserts"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 6813.1311262123545,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 313.54212018684376,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 189.13439658679997,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 6.04043289224375,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 87.08180564336564,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 16.048272413171876,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 907.6116072560926,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 26.194959367499997,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 316.166368221094,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 149.6999999991565,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 130.11981868815627,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 1637.042660534375,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 6666.886030896866,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 2223.9918902499912,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 504.02041984375,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 4004.1201389999833,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 232.08152102493713,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 16.642479330031165,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 2731.684235425,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 7094.7179102125,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 172.99931395250002,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 11.54011497240313,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 15.52656299541859,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 143.74426993940625,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 15.125712266934375,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 4824.082959046876,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 466.194264271875,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 2563.930871425,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 49.089713608656254,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 58.4917976709375,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 10.6877065325,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 25.898412039375,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 1314.6501833044374,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 340.6565563106177,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 482.37249259514425,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 945.6719829339997,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 302.5372024186975,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 104.77983746999999,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 260.23963737631254,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 545.6808868447918,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 277.7869179540361,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 222.39918902499912,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 120.00486186755953,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 85.19404551063795,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 1289.341783471873,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 151.29526663664694,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 390.2406050607143,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 788.3019900236111,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 192.22145994722223,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 961.6762477002609,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 1194.3509996475839,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 898.4016871212891,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 1163.516328225721,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 1206.020739761719,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 2045.4047336940107,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 389.94531780625005,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 71.25137688333332,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 21.582010032812498,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 313.54212018684376,
//                         "hasRDI": true,
//                         "daily": 482.37249259514425,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 189.13439658679997,
//                                 "hasRDI": true,
//                                 "daily": 945.6719829339997,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 6.04043289224375,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 87.08180564336564,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 16.048272413171876,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 907.6116072560926,
//                         "hasRDI": true,
//                         "daily": 302.5372024186975,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 26.194959367499997,
//                                 "hasRDI": true,
//                                 "daily": 104.77983746999999,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 316.166368221094,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 149.6999999991565,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 130.11981868815627,
//                         "hasRDI": true,
//                         "daily": 260.23963737631254,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 1637.042660534375,
//                         "hasRDI": true,
//                         "daily": 545.6808868447918,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 6666.886030896866,
//                         "hasRDI": true,
//                         "daily": 277.7869179540361,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 2223.9918902499912,
//                         "hasRDI": true,
//                         "daily": 222.39918902499912,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 504.02041984375,
//                         "hasRDI": true,
//                         "daily": 120.00486186755953,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 4004.1201389999833,
//                         "hasRDI": true,
//                         "daily": 85.19404551063795,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 232.08152102493713,
//                         "hasRDI": true,
//                         "daily": 1289.341783471873,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 16.642479330031165,
//                         "hasRDI": true,
//                         "daily": 151.29526663664694,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 2731.684235425,
//                         "hasRDI": true,
//                         "daily": 390.2406050607143,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 7094.7179102125,
//                         "hasRDI": true,
//                         "daily": 788.3019900236111,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 172.99931395250002,
//                         "hasRDI": true,
//                         "daily": 192.22145994722223,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 11.54011497240313,
//                         "hasRDI": true,
//                         "daily": 961.6762477002609,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 15.52656299541859,
//                         "hasRDI": true,
//                         "daily": 1194.3509996475839,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 143.74426993940625,
//                         "hasRDI": true,
//                         "daily": 898.4016871212891,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 15.125712266934375,
//                         "hasRDI": true,
//                         "daily": 1163.516328225721,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 4824.082959046876,
//                         "hasRDI": true,
//                         "daily": 1206.020739761719,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 466.194264271875,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 2563.930871425,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 49.089713608656254,
//                         "hasRDI": true,
//                         "daily": 2045.4047336940107,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 58.4917976709375,
//                         "hasRDI": true,
//                         "daily": 389.94531780625005,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 10.6877065325,
//                         "hasRDI": true,
//                         "daily": 71.25137688333332,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 25.898412039375,
//                         "hasRDI": true,
//                         "daily": 21.582010032812498,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 1314.6501833044374,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_f1ed389bd886fae051451da61bdf15fa",
//                 "label": "Milk Punch",
//                 "image": "https://www.edamam.com/web-img/cd7/cd7da19efeff608337907b4bf0fb5a27.jpg",
//                 "source": "Martha Stewart",
//                 "url": "https://www.marthastewart.com/344533/milk-punch",
//                 "shareAs": "http://www.edamam.com/recipe/milk-punch-f1ed389bd886fae051451da61bdf15fa/milk",
//                 "yield": 8,
//                 "dietLabels": [
//                     "Low-Sodium"
//                 ],
//                 "healthLabels": [
//                     "Low Potassium",
//                     "Kidney-Friendly",
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "No oil added",
//                     "Kosher",
//                     "Alcohol-Cocktail"
//                 ],
//                 "cautions": [],
//                 "ingredientLines": [
//                     "1/2 cup granulated sugar",
//                     "1 1/2 cups whole milk",
//                     "1 1/2 cups heavy cream",
//                     "1 teaspoon pure vanilla extract",
//                     "1/2 teaspoon ground cinnamon",
//                     "1 cup bourbon",
//                     "Freshly grated nutmeg, for serving"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "1/2 cup granulated sugar",
//                         "quantity": 0.5,
//                         "measure": "cup",
//                         "food": "granulated sugar",
//                         "weight": 100,
//                         "foodCategory": "sugars",
//                         "foodId": "food_axi2ijobrk819yb0adceobnhm1c2",
//                         "image": "https://www.edamam.com/food-img/ecb/ecb3f5aaed96d0188c21b8369be07765.jpg"
//                     },
//                     {
//                         "text": "1 1/2 cups whole milk",
//                         "quantity": 1.5,
//                         "measure": "cup",
//                         "food": "whole milk",
//                         "weight": 366,
//                         "foodCategory": "Milk",
//                         "foodId": "food_b49rs1kaw0jktabzkg2vvanvvsis",
//                         "image": "https://www.edamam.com/food-img/7c9/7c9962acf83654a8d98ea6a2ade93735.jpg"
//                     },
//                     {
//                         "text": "1 1/2 cups heavy cream",
//                         "quantity": 1.5,
//                         "measure": "cup",
//                         "food": "heavy cream",
//                         "weight": 357,
//                         "foodCategory": "Dairy",
//                         "foodId": "food_bgtkr21b5v16mca246x9ebnaswyo",
//                         "image": "https://www.edamam.com/food-img/484/4848d71f6a14dd5076083f5e17925420.jpg"
//                     },
//                     {
//                         "text": "1 teaspoon pure vanilla extract",
//                         "quantity": 1,
//                         "measure": "teaspoon",
//                         "food": "vanilla extract",
//                         "weight": 4.2,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_bh1wvnqaw3q7ciascfoygaabax2a",
//                         "image": "https://www.edamam.com/food-img/90f/90f910b0bf82750d4f6528263e014cca.jpg"
//                     },
//                     {
//                         "text": "1/2 teaspoon ground cinnamon",
//                         "quantity": 0.5,
//                         "measure": "teaspoon",
//                         "food": "ground cinnamon",
//                         "weight": 1.3,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_atjxtznauw5zabaixm24xa787onz",
//                         "image": "https://www.edamam.com/food-img/d4d/d4daa18b92c596a1c99c08537c38e65b.jpg"
//                     },
//                     {
//                         "text": "1 cup bourbon",
//                         "quantity": 1,
//                         "measure": "cup",
//                         "food": "bourbon",
//                         "weight": 223.999999998738,
//                         "foodCategory": "liquors and cocktails",
//                         "foodId": "food_b88jy7va2cw6z3ao080f4b0dqg7d",
//                         "image": "https://www.edamam.com/food-img/0ff/0ffe9f2bc332f9add8b904467a79f818.jpg"
//                     },
//                     {
//                         "text": "Freshly grated nutmeg, for serving",
//                         "quantity": 1,
//                         "measure": "serving",
//                         "food": "nutmeg",
//                         "weight": 3,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_aa8vp2kadkkiiubgpp48fazrqiq2",
//                         "image": "https://www.edamam.com/food-img/b9e/b9e54f78ae18cf99a6504b472ba25e7b.jpg"
//                     }
//                 ],
//                 "calories": 2432.966999996845,
//                 "totalWeight": 1055.499999998738,
//                 "totalTime": 40,
//                 "cuisineType": [
//                     "world"
//                 ],
//                 "mealType": [
//                     "lunch/dinner"
//                 ],
//                 "dishType": [
//                     "alcohol-cocktail"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 2432.966999996845,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 145.09294000000003,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 89.83324500000002,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 41.221157999999996,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 5.630432000000002,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 130.78996999999876,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 1.3143,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 129.11650999999873,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 99.8,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 19.077090000000002,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 525.69,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 295.028,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 665.638,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 68.364,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 777.4289999999874,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 0.5160999999997476,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 2.3230099999997478,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 542.9739999999621,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 1635.9750000000001,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 2.2813999999999997,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 0.27594799999989905,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 1.0387129999999873,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 0.651105999999369,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.232526,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 34.938,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 34.938,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 2.2896,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 7.257,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 4.070560000000001,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 12.927600000000002,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 674.2692999991935,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 121.64834999984225,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 223.21990769230774,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 449.1662250000001,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 43.596656666666256,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 5.2572,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 38.154180000000004,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 175.23000000000002,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 12.292833333333334,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 66.5638,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 16.27714285714286,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 16.54104255319122,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 2.8672222222208203,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 21.118272727270433,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 77.56771428570887,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 181.775,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 2.5348888888888883,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 22.995666666658256,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 79.90099999999903,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 4.069412499996057,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 17.886615384615386,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 8.7345,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 95.4,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 48.379999999999995,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 27.137066666666676,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 10.773000000000001,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 145.09294000000003,
//                         "hasRDI": true,
//                         "daily": 223.21990769230774,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 89.83324500000002,
//                                 "hasRDI": true,
//                                 "daily": 449.1662250000001,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 41.221157999999996,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 5.630432000000002,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 130.78996999999876,
//                         "hasRDI": true,
//                         "daily": 43.596656666666256,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 1.3143,
//                                 "hasRDI": true,
//                                 "daily": 5.2572,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 129.11650999999873,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 99.8,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 19.077090000000002,
//                         "hasRDI": true,
//                         "daily": 38.154180000000004,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 525.69,
//                         "hasRDI": true,
//                         "daily": 175.23000000000002,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 295.028,
//                         "hasRDI": true,
//                         "daily": 12.292833333333334,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 665.638,
//                         "hasRDI": true,
//                         "daily": 66.5638,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 68.364,
//                         "hasRDI": true,
//                         "daily": 16.27714285714286,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 777.4289999999874,
//                         "hasRDI": true,
//                         "daily": 16.54104255319122,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 0.5160999999997476,
//                         "hasRDI": true,
//                         "daily": 2.8672222222208203,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 2.3230099999997478,
//                         "hasRDI": true,
//                         "daily": 21.118272727270433,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 542.9739999999621,
//                         "hasRDI": true,
//                         "daily": 77.56771428570887,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 1635.9750000000001,
//                         "hasRDI": true,
//                         "daily": 181.775,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 2.2813999999999997,
//                         "hasRDI": true,
//                         "daily": 2.5348888888888883,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 0.27594799999989905,
//                         "hasRDI": true,
//                         "daily": 22.995666666658256,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 1.0387129999999873,
//                         "hasRDI": true,
//                         "daily": 79.90099999999903,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 0.651105999999369,
//                         "hasRDI": true,
//                         "daily": 4.069412499996057,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.232526,
//                         "hasRDI": true,
//                         "daily": 17.886615384615386,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 34.938,
//                         "hasRDI": true,
//                         "daily": 8.7345,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 34.938,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 2.2896,
//                         "hasRDI": true,
//                         "daily": 95.4,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 7.257,
//                         "hasRDI": true,
//                         "daily": 48.379999999999995,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 4.070560000000001,
//                         "hasRDI": true,
//                         "daily": 27.137066666666676,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 12.927600000000002,
//                         "hasRDI": true,
//                         "daily": 10.773000000000001,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 674.2692999991935,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         },
//         {
//             "recipe": {
//                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_7ce2b4bb36c9bec7a42a6e8805169f89",
//                 "label": "Milk Chocolate Sauce",
//                 "image": "https://www.edamam.com/web-img/928/92840ddb113ef222b8421eaafb4a9aef.jpg",
//                 "source": "Epicurious",
//                 "url": "https://www.epicurious.com/recipes/food/views/milk-chocolate-sauce",
//                 "shareAs": "http://www.edamam.com/recipe/milk-chocolate-sauce-7ce2b4bb36c9bec7a42a6e8805169f89/milk",
//                 "yield": 2.5,
//                 "dietLabels": [
//                     "Low-Carb"
//                 ],
//                 "healthLabels": [
//                     "Kidney-Friendly",
//                     "Vegetarian",
//                     "Pescatarian",
//                     "Gluten-Free",
//                     "Wheat-Free",
//                     "Egg-Free",
//                     "Peanut-Free",
//                     "Tree-Nut-Free",
//                     "Soy-Free",
//                     "Fish-Free",
//                     "Shellfish-Free",
//                     "Pork-Free",
//                     "Red-Meat-Free",
//                     "Crustacean-Free",
//                     "Celery-Free",
//                     "Mustard-Free",
//                     "Sesame-Free",
//                     "Lupine-Free",
//                     "Mollusk-Free",
//                     "Alcohol-Free",
//                     "Sulfite-Free",
//                     "Kosher"
//                 ],
//                 "cautions": [
//                     "Sulfites"
//                 ],
//                 "ingredientLines": [
//                     "4 ounces milk chocolate, finely chopped",
//                     "1/2 teaspoon kosher salt",
//                     "3/4 cup heavy cream",
//                     "2 tablespoons unsalted butter, room temperature"
//                 ],
//                 "ingredients": [
//                     {
//                         "text": "4 ounces milk chocolate, finely chopped",
//                         "quantity": 4,
//                         "measure": "ounce",
//                         "food": "milk chocolate",
//                         "weight": 113.3980925,
//                         "foodCategory": "chocolate",
//                         "foodId": "food_bln15nrase9ec3by5dp50affuwzj",
//                         "image": "https://www.edamam.com/food-img/818/8181456202f62ca321fdaf8513ce3282.jpg"
//                     },
//                     {
//                         "text": "1/2 teaspoon kosher salt",
//                         "quantity": 0.5,
//                         "measure": "teaspoon",
//                         "food": "kosher salt",
//                         "weight": 2.4270833334564377,
//                         "foodCategory": "Condiments and sauces",
//                         "foodId": "food_a1vgrj1bs8rd1majvmd9ubz8ttkg",
//                         "image": "https://www.edamam.com/food-img/694/6943ea510918c6025795e8dc6e6eaaeb.jpg"
//                     },
//                     {
//                         "text": "3/4 cup heavy cream",
//                         "quantity": 0.75,
//                         "measure": "cup",
//                         "food": "heavy cream",
//                         "weight": 178.5,
//                         "foodCategory": "Dairy",
//                         "foodId": "food_bgtkr21b5v16mca246x9ebnaswyo",
//                         "image": "https://www.edamam.com/food-img/484/4848d71f6a14dd5076083f5e17925420.jpg"
//                     },
//                     {
//                         "text": "2 tablespoons unsalted butter, room temperature",
//                         "quantity": 2,
//                         "measure": "tablespoon",
//                         "food": "unsalted butter",
//                         "weight": 28.4,
//                         "foodCategory": "Dairy",
//                         "foodId": "food_awz3iefajbk1fwahq9logahmgltj",
//                         "image": "https://www.edamam.com/food-img/713/71397239b670d88c04faa8d05035cab4.jpg"
//                     }
//                 ],
//                 "calories": 1426.1327948750002,
//                 "totalWeight": 321.8056736834251,
//                 "totalTime": 0,
//                 "cuisineType": [
//                     "british"
//                 ],
//                 "mealType": [
//                     "snack"
//                 ],
//                 "dishType": [
//                     "condiments and sauces"
//                 ],
//                 "totalNutrients": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 1426.1327948750002,
//                         "unit": "kcal"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 122.7141142355,
//                         "unit": "g"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 76.689484940825,
//                         "unit": "g"
//                     },
//                     "FATRN": {
//                         "label": "Trans",
//                         "quantity": 0.9309519999999999,
//                         "unit": "g"
//                     },
//                     "FAMS": {
//                         "label": "Monounsaturated",
//                         "quantity": 33.19326092705,
//                         "unit": "g"
//                     },
//                     "FAPU": {
//                         "label": "Polyunsaturated",
//                         "quantity": 4.877159752800001,
//                         "unit": "g"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 72.35565694499999,
//                         "unit": "g"
//                     },
//                     "CHOCDF.net": {
//                         "label": "Carbohydrates (net)",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 3.855535145,
//                         "unit": "g"
//                     },
//                     "SUGAR": {
//                         "label": "Sugars",
//                         "quantity": 63.39720763750001,
//                         "unit": "g"
//                     },
//                     "SUGAR.added": {
//                         "label": "Sugars, added",
//                         "quantity": 58.400017637500014,
//                         "unit": "g"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 12.575604076250002,
//                         "unit": "g"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 331.68656127500003,
//                         "unit": "mg"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 744.8468081469001,
//                         "unit": "mg"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 337.5252143090221,
//                         "unit": "mg"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 84.51887408683426,
//                         "unit": "mg"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 562.6525105946741,
//                         "unit": "mg"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 2.7290601916553032,
//                         "unit": "mg"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 3.0457737086834253,
//                         "unit": "mg"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 353.3540324,
//                         "unit": "mg"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 994.795874575,
//                         "unit": "µg"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 1.071,
//                         "unit": "mg"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 0.16769586360000002,
//                         "unit": "mg"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 0.5439323156500001,
//                         "unit": "mg"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 0.5192596370500001,
//                         "unit": "mg"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 0.08808531330000001,
//                         "unit": "mg"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 20.465790175000002,
//                         "unit": "µg"
//                     },
//                     "FOLFD": {
//                         "label": "Folate (food)",
//                         "quantity": 20.465790175000002,
//                         "unit": "µg"
//                     },
//                     "FOLAC": {
//                         "label": "Folic acid",
//                         "quantity": 0,
//                         "unit": "µg"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 1.22006569375,
//                         "unit": "µg"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 1.6755,
//                         "unit": "µg"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 3.1293102717500005,
//                         "unit": "mg"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 14.163691272500001,
//                         "unit": "µg"
//                     },
//                     "Sugar.alcohol": {
//                         "label": "Sugar alcohol",
//                         "quantity": 0,
//                         "unit": "g"
//                     },
//                     "WATER": {
//                         "label": "Water",
//                         "quantity": 109.81129654986687,
//                         "unit": "g"
//                     }
//                 },
//                 "totalDaily": {
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "quantity": 71.30663974375001,
//                         "unit": "%"
//                     },
//                     "FAT": {
//                         "label": "Fat",
//                         "quantity": 188.7909449776923,
//                         "unit": "%"
//                     },
//                     "FASAT": {
//                         "label": "Saturated",
//                         "quantity": 383.44742470412496,
//                         "unit": "%"
//                     },
//                     "CHOCDF": {
//                         "label": "Carbs",
//                         "quantity": 24.118552315,
//                         "unit": "%"
//                     },
//                     "FIBTG": {
//                         "label": "Fiber",
//                         "quantity": 15.42214058,
//                         "unit": "%"
//                     },
//                     "PROCNT": {
//                         "label": "Protein",
//                         "quantity": 25.151208152500004,
//                         "unit": "%"
//                     },
//                     "CHOLE": {
//                         "label": "Cholesterol",
//                         "quantity": 110.56218709166669,
//                         "unit": "%"
//                     },
//                     "NA": {
//                         "label": "Sodium",
//                         "quantity": 31.035283672787507,
//                         "unit": "%"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 33.75252143090221,
//                         "unit": "%"
//                     },
//                     "MG": {
//                         "label": "Magnesium",
//                         "quantity": 20.12354144924625,
//                         "unit": "%"
//                     },
//                     "K": {
//                         "label": "Potassium",
//                         "quantity": 11.971330012652642,
//                         "unit": "%"
//                     },
//                     "FE": {
//                         "label": "Iron",
//                         "quantity": 15.16144550919613,
//                         "unit": "%"
//                     },
//                     "ZN": {
//                         "label": "Zinc",
//                         "quantity": 27.68885189712205,
//                         "unit": "%"
//                     },
//                     "P": {
//                         "label": "Phosphorus",
//                         "quantity": 50.479147485714286,
//                         "unit": "%"
//                     },
//                     "VITA_RAE": {
//                         "label": "Vitamin A",
//                         "quantity": 110.53287495277777,
//                         "unit": "%"
//                     },
//                     "VITC": {
//                         "label": "Vitamin C",
//                         "quantity": 1.19,
//                         "unit": "%"
//                     },
//                     "THIA": {
//                         "label": "Thiamin (B1)",
//                         "quantity": 13.974655300000002,
//                         "unit": "%"
//                     },
//                     "RIBF": {
//                         "label": "Riboflavin (B2)",
//                         "quantity": 41.840947357692315,
//                         "unit": "%"
//                     },
//                     "NIA": {
//                         "label": "Niacin (B3)",
//                         "quantity": 3.2453727315625005,
//                         "unit": "%"
//                     },
//                     "VITB6A": {
//                         "label": "Vitamin B6",
//                         "quantity": 6.775793330769232,
//                         "unit": "%"
//                     },
//                     "FOLDFE": {
//                         "label": "Folate equivalent (total)",
//                         "quantity": 5.1164475437500005,
//                         "unit": "%"
//                     },
//                     "VITB12": {
//                         "label": "Vitamin B12",
//                         "quantity": 50.836070572916675,
//                         "unit": "%"
//                     },
//                     "VITD": {
//                         "label": "Vitamin D",
//                         "quantity": 11.17,
//                         "unit": "%"
//                     },
//                     "TOCPHA": {
//                         "label": "Vitamin E",
//                         "quantity": 20.862068478333338,
//                         "unit": "%"
//                     },
//                     "VITK1": {
//                         "label": "Vitamin K",
//                         "quantity": 11.803076060416666,
//                         "unit": "%"
//                     }
//                 },
//                 "digest": [
//                     {
//                         "label": "Fat",
//                         "tag": "FAT",
//                         "schemaOrgTag": "fatContent",
//                         "total": 122.7141142355,
//                         "hasRDI": true,
//                         "daily": 188.7909449776923,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Saturated",
//                                 "tag": "FASAT",
//                                 "schemaOrgTag": "saturatedFatContent",
//                                 "total": 76.689484940825,
//                                 "hasRDI": true,
//                                 "daily": 383.44742470412496,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Trans",
//                                 "tag": "FATRN",
//                                 "schemaOrgTag": "transFatContent",
//                                 "total": 0.9309519999999999,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Monounsaturated",
//                                 "tag": "FAMS",
//                                 "schemaOrgTag": null,
//                                 "total": 33.19326092705,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Polyunsaturated",
//                                 "tag": "FAPU",
//                                 "schemaOrgTag": null,
//                                 "total": 4.877159752800001,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Carbs",
//                         "tag": "CHOCDF",
//                         "schemaOrgTag": "carbohydrateContent",
//                         "total": 72.35565694499999,
//                         "hasRDI": true,
//                         "daily": 24.118552315,
//                         "unit": "g",
//                         "sub": [
//                             {
//                                 "label": "Carbs (net)",
//                                 "tag": "CHOCDF.net",
//                                 "schemaOrgTag": null,
//                                 "total": 0,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Fiber",
//                                 "tag": "FIBTG",
//                                 "schemaOrgTag": "fiberContent",
//                                 "total": 3.855535145,
//                                 "hasRDI": true,
//                                 "daily": 15.42214058,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars",
//                                 "tag": "SUGAR",
//                                 "schemaOrgTag": "sugarContent",
//                                 "total": 63.39720763750001,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             },
//                             {
//                                 "label": "Sugars, added",
//                                 "tag": "SUGAR.added",
//                                 "schemaOrgTag": null,
//                                 "total": 58.400017637500014,
//                                 "hasRDI": false,
//                                 "daily": 0,
//                                 "unit": "g"
//                             }
//                         ]
//                     },
//                     {
//                         "label": "Protein",
//                         "tag": "PROCNT",
//                         "schemaOrgTag": "proteinContent",
//                         "total": 12.575604076250002,
//                         "hasRDI": true,
//                         "daily": 25.151208152500004,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Cholesterol",
//                         "tag": "CHOLE",
//                         "schemaOrgTag": "cholesterolContent",
//                         "total": 331.68656127500003,
//                         "hasRDI": true,
//                         "daily": 110.56218709166669,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Sodium",
//                         "tag": "NA",
//                         "schemaOrgTag": "sodiumContent",
//                         "total": 744.8468081469001,
//                         "hasRDI": true,
//                         "daily": 31.035283672787507,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Calcium",
//                         "tag": "CA",
//                         "schemaOrgTag": null,
//                         "total": 337.5252143090221,
//                         "hasRDI": true,
//                         "daily": 33.75252143090221,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Magnesium",
//                         "tag": "MG",
//                         "schemaOrgTag": null,
//                         "total": 84.51887408683426,
//                         "hasRDI": true,
//                         "daily": 20.12354144924625,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Potassium",
//                         "tag": "K",
//                         "schemaOrgTag": null,
//                         "total": 562.6525105946741,
//                         "hasRDI": true,
//                         "daily": 11.971330012652642,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Iron",
//                         "tag": "FE",
//                         "schemaOrgTag": null,
//                         "total": 2.7290601916553032,
//                         "hasRDI": true,
//                         "daily": 15.16144550919613,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Zinc",
//                         "tag": "ZN",
//                         "schemaOrgTag": null,
//                         "total": 3.0457737086834253,
//                         "hasRDI": true,
//                         "daily": 27.68885189712205,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Phosphorus",
//                         "tag": "P",
//                         "schemaOrgTag": null,
//                         "total": 353.3540324,
//                         "hasRDI": true,
//                         "daily": 50.479147485714286,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin A",
//                         "tag": "VITA_RAE",
//                         "schemaOrgTag": null,
//                         "total": 994.795874575,
//                         "hasRDI": true,
//                         "daily": 110.53287495277777,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin C",
//                         "tag": "VITC",
//                         "schemaOrgTag": null,
//                         "total": 1.071,
//                         "hasRDI": true,
//                         "daily": 1.19,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Thiamin (B1)",
//                         "tag": "THIA",
//                         "schemaOrgTag": null,
//                         "total": 0.16769586360000002,
//                         "hasRDI": true,
//                         "daily": 13.974655300000002,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Riboflavin (B2)",
//                         "tag": "RIBF",
//                         "schemaOrgTag": null,
//                         "total": 0.5439323156500001,
//                         "hasRDI": true,
//                         "daily": 41.840947357692315,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Niacin (B3)",
//                         "tag": "NIA",
//                         "schemaOrgTag": null,
//                         "total": 0.5192596370500001,
//                         "hasRDI": true,
//                         "daily": 3.2453727315625005,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin B6",
//                         "tag": "VITB6A",
//                         "schemaOrgTag": null,
//                         "total": 0.08808531330000001,
//                         "hasRDI": true,
//                         "daily": 6.775793330769232,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Folate equivalent (total)",
//                         "tag": "FOLDFE",
//                         "schemaOrgTag": null,
//                         "total": 20.465790175000002,
//                         "hasRDI": true,
//                         "daily": 5.1164475437500005,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folate (food)",
//                         "tag": "FOLFD",
//                         "schemaOrgTag": null,
//                         "total": 20.465790175000002,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Folic acid",
//                         "tag": "FOLAC",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin B12",
//                         "tag": "VITB12",
//                         "schemaOrgTag": null,
//                         "total": 1.22006569375,
//                         "hasRDI": true,
//                         "daily": 50.836070572916675,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin D",
//                         "tag": "VITD",
//                         "schemaOrgTag": null,
//                         "total": 1.6755,
//                         "hasRDI": true,
//                         "daily": 11.17,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Vitamin E",
//                         "tag": "TOCPHA",
//                         "schemaOrgTag": null,
//                         "total": 3.1293102717500005,
//                         "hasRDI": true,
//                         "daily": 20.862068478333338,
//                         "unit": "mg"
//                     },
//                     {
//                         "label": "Vitamin K",
//                         "tag": "VITK1",
//                         "schemaOrgTag": null,
//                         "total": 14.163691272500001,
//                         "hasRDI": true,
//                         "daily": 11.803076060416666,
//                         "unit": "µg"
//                     },
//                     {
//                         "label": "Sugar alcohols",
//                         "tag": "Sugar.alcohol",
//                         "schemaOrgTag": null,
//                         "total": 0,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     },
//                     {
//                         "label": "Water",
//                         "tag": "WATER",
//                         "schemaOrgTag": null,
//                         "total": 109.81129654986687,
//                         "hasRDI": false,
//                         "daily": 0,
//                         "unit": "g"
//                     }
//                 ]
//             }
//         }
//     ]
// }
//  */
