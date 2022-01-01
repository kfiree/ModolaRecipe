// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:modolar_recipe/Widgets/ingredients.dart';
import 'dart:convert';

import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Styles/constants.dart';
import 'package:modolar_recipe/Widgets/loading.dart';
import 'package:modolar_recipe/views/recipe_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// class StepEntry extends StatelessWidget {
//   final String text;
//   final bool initialStep;

//   const StepEntry({Key? key, required this.text, this.initialStep = false})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         right: 25,
//         left: 10.0,
//         top: 0.0,
//       ),
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   width: 5.0,
//                   height: initialStep ? 0 : 40,
//                   decoration: BoxDecoration(
//                     color: HexColor('#998fb3'),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 69,
//                 child: SizedBox(
//                   height: 10.0,
//                 ),
//               )
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 height: 5.0,
//                 width: 5.0,
//                 decoration: BoxDecoration(
//                   color: HexColor('#998fb3'),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               SizedBox(
//                 width: 40.0,
//               ),
//               Flexible(
//                 child: Text(text),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class RecipeMediumView extends StatelessWidget {
  const RecipeMediumView({
    required this.recipeModel,
    required this.UID,
  });

  final RecipeModel recipeModel;
  final String UID;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          FullViewScreen.idScreen,
          arguments: {'UID': UID, 'Model': recipeModel},
        );
      },
      child: Row(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Container(
                height: 375.0,
                width: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: HexColor("#f9af9c"),
                ),
              ),
              Positioned(
                top: -13.0,
                left: -13.0,
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                child: CircleNetworkImage(
                  radius: 175,
                  imageURL: recipeModel.image,
                ),
              ),
              Positioned(
                left: 10,
                bottom: 130.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      recipeModel.name,
                      style: kMainTextStyle,
                    ),
                    if (recipeModel.cookingTime > 0)
                      Text(
                        "${recipeModel.cookingTime} min",
                        style: kSubHeaderTextStyle,
                      ),
                  ],
                ),
              ),
              Positioned(
                right: 30.0,
                bottom: 20.0,
                child: Row(
                  children: <Widget>[
                    Text(
                      recipeModel.calories.toInt().toString(),
                      style: kSmallTextStyle,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      "cal",
                      style: kSubHeaderTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  const RecipeTile({
    Key? key,
    required this.recipeModel,
    required this.UID,
  }) : super(key: key);

  final RecipeModel recipeModel;
  final String UID;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          FullViewScreen.idScreen,
          arguments: {'UID': UID, 'Model': recipeModel},
        );
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.network(
              recipeModel.image,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
            child: Container(
              width: 200,
              height: 50,
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
                      recipeModel.name,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontFamily: 'Overpass'),
                    ),
                    Text(
                      recipeModel.source,
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
          ),
        ],
      ),
    );
  }
}

// class FullRecipe {
//   final String label, image, source, url, uri, cuisineType;
//   final double calories;
//   final int cookingTime;
//   final List<Map<String, dynamic>> ingredients;
//   final List<String> cautions;

//   FullRecipe(
//       {required this.label,
//       required this.image,
//       required this.source,
//       required this.url,
//       required this.uri,
//       required this.calories,
//       required this.cookingTime,
//       required this.ingredients,
//       required this.cuisineType,
//       required this.cautions});

//   factory FullRecipe.fromJson(Map<String, dynamic> json) {
//     return FullRecipe(
//         label: json['label'],
//         image: json['image'],
//         source: json['source'],
//         url: json['url'],
//         uri: json['uri'],
//         calories: json['calories'],
//         cookingTime: json['cookingTime'],
//         ingredients: json['ingredients'],
//         cuisineType: json['cuisineType'],
//         cautions: json['cautions']);
//   }
// }

class RecipeModel {
  final String name, image, source, url, uri;
  final List<dynamic> mealType,
      dishType,
      dietLabels,
      healthLabels,
      cuisineType,
      cautions,
      instructions;
  // List<String> subs = [], removed = [];

  List<SubModel> subs = [];

  final int cookingTime, calories;
  List<IngredientModel> ingredients;

  RecipeModel({
    required this.uri,
    required this.name,
    required this.image,
    required this.source,
    required this.url,
    required this.dietLabels,
    required this.healthLabels,
    required this.cautions,
    required this.ingredients,
    required this.calories,
    required this.cookingTime,
    required this.cuisineType,
    required this.mealType,
    required this.dishType,
    required this.instructions,
    required this.subs,
    // required this.removed,
  });

  // addSubs(List<String> ingredientsNames) {
  //   for (String e in ingredientsNames) {
  //     subs.add(e);
  //   }
  // }

  // addRemoved(List<String> ingredientsNames) {
  //   for (String e in ingredientsNames) {
  //     removed.add(e);
  //   }
  // }

  // deleteIngredients(List<IngredientModel> ingredientsList) {
  //   for (IngredientModel e in ingredientsList) {
  //     ingredients.remove(e);
  //   }
  // }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    // json = format(json);
    // addToFB(json);
    return RecipeModel(
      uri: stringFormat(json['uri']),
      name: stringFormat(json['label']),
      image: stringFormat(json['image']),
      source: stringFormat(json['source']),
      url: stringFormat(json['url']),
      calories: numFormat(json['calories']),
      cookingTime: numFormat(json['totalTime']),
      dietLabels: ListFormat(json['dietLabels']),
      healthLabels: ListFormat(json['healthLabels']),
      cautions: ListFormat(json['cautions']),
      cuisineType: ListFormat(json['cuisineType']),
      mealType: ListFormat(json['mealType']),
      dishType: ListFormat(json['dishType']),
      ingredients: toIngredientList(json['ingredients']),
      instructions: ListFormat(json['instructions']),
      subs: [],
    );
  }

  addToFB(Map<String, dynamic> recipe) {
    if (recipe.isEmpty) {
      recipe = toMap();
    }
    CollectionReference collection =
        FirebaseFirestore.instance.collection("recipes");

    var formatRecipe = format(recipe);
    String recID = recipe['uri'].split("#")[1];

    collection
        .doc(recID)
        .set(formatRecipe)
        .then((value) => print('recipe $recID Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  dynamic format(dynamic doc) {
    doc['uri'] = stringFormat(doc['uri']);
    doc['label'] = stringFormat(doc['label']);
    doc['image'] = stringFormat(doc['image']);
    doc['source'] = stringFormat(doc['source']);
    doc['url'] = stringFormat(doc['url']);
    doc['calories'] = numFormat(doc['calories']);
    doc['totalTime'] = numFormat(doc['totalTime']);
    doc['dietLabels'] = ListFormat(doc['dietLabels']);
    doc['healthLabels'] = ListFormat(doc['healthLabels']);
    doc['cautions'] = ListFormat(doc['cautions']);
    doc['cuisineType'] = ListFormat(doc['cuisineType']);
    doc['mealType'] = ListFormat(doc['mealType']);
    doc['dishType'] = ListFormat(doc['dishType']);
    doc['instructions'] = ListFormat(doc['instructions']);
    doc['subs'] = formatSubs(doc['subs']);
    // doc['ingredients'] = toIngredientList(doc['ingredients']);
    return doc;
  }

  addSub(
      List<String> _added, List<String> _removed, List<String> _instructions) {
    var newSub =
        SubModel(added: _added, removed: _removed, instructions: _instructions);

    subs.add(newSub);
    // save();
  }

  // save() {
  //   Map<String, dynamic> recipeMap = toMap();
  //   CollectionReference collection =
  //       FirebaseFirestore.instance.collection("recipes");

  //   String recID = recipeMap['uri'].split("#")[1];

  //   collection
  //       .doc(recID)
  //       .set(recipeMap)
  //       .then((value) => print('recipe $recID Added'))
  //       .catchError((error) => print('Add failed: $error'));
  // }

  // rateSub(int newRate, int id) {
  //   double currentRate = subs[id]!['rate'];
  //   int ratesNum = subs[id]!['ratesNum'] + 1;

  //   subs[id]!['rate'] = (currentRate + newRate) / ratesNum;
  //   subs[id]!['ratesNum'] = ratesNum;
  // }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['uri'] = uri;
    data['label'] = name;
    data['image'] = image;
    data['source'] = source;
    data['url'] = url;
    data['dietLabels'] = dietLabels;
    data['healthLabels'] = healthLabels;
    data['cautions'] = cautions;
    data['ingredients'] = ingredients.map((v) => v.toJson()).toList();
    data['calories'] = calories;
    data['totalTime'] = cookingTime;
    data['cuisineType'] = cuisineType;
    data['mealType'] = mealType;
    data['dishType'] = dishType;
    data['instructions'] = instructions;
    data['subs'] = subs;
    return data;
  }

  @override
  String toString() {
    String data = '''
    calories: $calories,
    cookingTime: $cookingTime,
    ingredients: $ingredients,
    cuisineType: $cuisineType,
    cautions: $cautions,
    label: $name,
    source: $source,
    image: $image,
    uri: $uri
    ''';
    return '{\n$data}';
  }
}

class RecipeGrid extends StatelessWidget {
  const RecipeGrid({Key? key, this.query, this.UID}) : super(key: key);

  final query, UID;
// List<RecipeTile>
  Future<List<RecipeModel>> fetchFromAPI(String query) async {
    String applicationId = "2051cf6b",
        applicationKey = "23b5c49d42ef07d39fb68e1b6e04bf42";
    String queryUrl =
        'https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey';
    final response = await http.get(Uri.parse(queryUrl));

    if (response.statusCode == 200) {
      // recipes.clear();
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<RecipeModel> recipes = [];

      jsonData["hits"].forEach(
        (hit) {
          recipes.add(
            RecipeModel.fromJson(hit["recipe"]),
          );
        },
      );

      return recipes;
    } else {
      throw Exception(
          'Failed to load Recipe. response statusCode = ${response.statusCode} queryUrl = $queryUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipeModel>>(
      future: fetchFromAPI(query),
      builder:
          (BuildContext context, AsyncSnapshot<List<RecipeModel>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<RecipeTile> tiles = [];
          snapshot.data?.forEach((model) {
            tiles.add(RecipeTile(
              recipeModel: model,
              UID: UID,
            ));
          });
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            children: tiles,
          );
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}

String stringFormat(dynamic element) {
  return element ?? 'NULL';
}

int numFormat(dynamic element) {
  return element.toInt() ?? 0;
}

List<dynamic> ListFormat(dynamic element) {
  if (element == null) {
    return [];
  }
  return element.cast<String>();
}

//List<Map<String, dynamic>> ingredientsJson) {
List<IngredientModel> toIngredientList(dynamic element) {
  if (element == null) {
    return [];
  }

  List<IngredientModel> ingredientList = [];
  element.forEach((ingredient) =>
      {ingredientList.add(IngredientModel.fromJson(ingredient))});
  return ingredientList;
}

List<Map<String, dynamic>> formatSubs(dynamic subMap) {
  List<Map<String, dynamic>> result = [];
  for (var sub in subMap) {
    result.add({
      'added': sub.added,
      'removed': sub.removed,
      'instructions': sub.instructions,
      'rate': sub.rate,
      'ratesNum': sub.ratesNum,
    });
  }
  return result;
}

class SubModel {
  List<String> added = [], removed = [], instructions = [];
  int ratesNum = 0;
  double rate = 0;

  SubModel({added, removed, instructions, ratesNum, rate}) {
    this.added = added ?? [];
    this.removed = removed ?? [];
    this.instructions = instructions ?? [];
    this.ratesNum = ratesNum ?? 0;
    this.rate = rate ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['added'] = added;
    data['removed'] = removed;
    data['ratesNum'] = ratesNum;
    data['rate'] = rate;
    return data;
  }

  factory SubModel.fromJson(Map<String, dynamic> json) {
    // json = format(json);
    // addToFB(json);
    return SubModel(
      added: json['added'],
      removed: json['removed'],
      ratesNum: json['ratesNum'],
      rate: json['rate'],
    );
  }
  List<String> get getAdded {
    return added;
  }

  List<String> get getRemoved {
    return removed;
  }

  double get getRate {
    return rate;
  }

  int get getRatesNum {
    return ratesNum;
  }

  set setAdded(List<String> data) {
    added = data;
  }

  set setRemoved(List<String> data) {
    removed = data;
  }

  set setRate(double data) {
    rate = data;
  }

  set setRatesNum(int data) {
    ratesNum = data;
  }

  rateSub(int newRate, int id) {
    ratesNum++;
    rate = rate + (newRate) / ratesNum;
  }

  @override
  String toString() {
    String data = '''
    added: ${added.toString()}
    removed: ${removed.toString()}
    rate: $rate
    ratesNum: $ratesNum
    ''';
    return '{\n$data}';
  }
}

class SubView extends StatelessWidget {
  SubView({
    required this.subModel,
  });

  final SubModel subModel;
  List<Widget> added = [
        Text(
          'Added',
          style: kMainTextStyle,
        ),
      ],
      removed = [
        Text(
          'removed',
          style: kMainTextStyle,
        ),
      ],
      instructions = [
        Text(
          'instructions',
          style: kMainTextStyle,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    for (var e in subModel.added) {
      added.add(Text(
        e,
        style: kSmallTextStyle,
      ));
    }
    for (var e in subModel.removed) {
      added.add(Text(
        e,
        style: kSmallTextStyle,
      ));
    }
    for (var e in subModel.instructions) {
      added.add(Text(
        e,
        style: kSmallTextStyle,
      ));
    }
    return Row(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Container(
              height: 375.0,
              width: 300.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: HexColor("#f9af9c"),
              ),
            ),
            Column(children: <Widget>[
              Column(
                children: added,
              ),
              Column(
                children: removed,
              ),
              Column(
                children: instructions,
              ),
            ]),
            Positioned(
              left: 10,
              bottom: 130.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: added,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
