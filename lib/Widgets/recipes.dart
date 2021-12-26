import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modolar_recipe/Widgets/ingredients.dart';

import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Styles/constants.dart';
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

  final int cookingTime, calories;
  final List<IngredientModel> ingredients;

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
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
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
      instructions: [],
    );
  }

  factory RecipeModel.fromDocument(DocumentSnapshot doc) {
    int a = 1;
    return RecipeModel(
      uri: stringFormat(doc['uri']),
      name: stringFormat(doc['name']),
      image: stringFormat(doc['image']),
      source: stringFormat(doc['source']),
      url: stringFormat(doc['url']),
      calories: numFormat(doc['cal']),
      cookingTime: numFormat(doc['timeInMinutes']),
      dietLabels: ListFormat(doc['dietLabels']),
      healthLabels: ListFormat(doc['healthLabels']),
      cautions: ListFormat(doc['cautions']),
      cuisineType: ListFormat(doc['cuisineType']),
      mealType: ListFormat(doc['mealType']),
      dishType: ListFormat(doc['dishType']),
      instructions: ListFormat(doc['instructions']),
      ingredients: toIngredientList(doc['ingredients']),
    );
  }
  //  String name = json['label'] ?? 'NULL',
  //       image = json['image'] ?? 'NULL',
  //       source = json['source'] ?? 'NULL',
  //       url = json['url'] ?? 'NULL',
  //       uri = json['uri'] ?? 'NULL';
  //   double calories = json['calories'] ?? 0.0;
  //   List<dynamic> mealType =
  //           json['mealType'] != null ? json['mealType'].cast<String>() : [],
  //       dishType =
  //           json['dishType'] != null ? json['mealType'].cast<String>() : [],
  //       dietLabels =
  //           json['dietLabels'] != null ? json['mealType'].cast<String>() : [],
  //       healthLabels =
  //           json['healthLabels'] != null ? json['mealType'].cast<String>() : [],
  //       cuisineType =
  //           json['cuisineType'] != null ? json['mealType'].cast<String>() : [],
  //       cautions =
  //           json['cautions'] != null ? json['mealType'].cast<String>() : [];
  //   int cookingTime = json['totalTime'] != null ? json['totalTime'].toInt() : 0;
  //   List<IngredientModel> ingredients = [];
  //   json['ingredients'].forEach((ingredient) =>
  //       {ingredients.add(IngredientModel.fromJson(ingredient))});
  //   ingredients.cast<IngredientModel>();
  Map<String, dynamic> toJson() {
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

String stringFormat(dynamic element) {
  return element ?? 'NULL';
}

int numFormat(dynamic element) {
  return element.toInt() ?? 0;
}

List<dynamic> ListFormat(dynamic element) {
  element ?? [];
  return element.cast<String>();
}

//List<Map<String, dynamic>> ingredientsJson) {
List<IngredientModel> toIngredientList(dynamic element) {
  if (element == null) {
    return [];
  }

  List<IngredientModel> ingredientList = [];
  element.forEach((ingredient) =>
      {ingredientList.add(IngredientModel.fromDocument(ingredient))});
  return ingredientList;
}
