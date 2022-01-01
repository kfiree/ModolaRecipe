// ignore_for_file: non_constant_identifier_names, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:modolar_recipe/Widgets/ingredients.dart';
import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Styles/constants.dart';
import 'package:modolar_recipe/views/recipe_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeMediumView extends StatelessWidget {
  const RecipeMediumView({
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
                      colors: const [Colors.white30, Colors.white],
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

class RecipeModel {
  final String name, image, source, url, uri;
  final List<dynamic> mealType,
      dishType,
      dietLabels,
      healthLabels,
      cuisineType,
      cautions,
      instructions;

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
      instructions: ListFormat(json['instructions']),
      subs: getSubs(json['subs']),
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
    return doc;
  }

  addSub(
      List<String> _added, List<String> _removed, List<String> _instructions) {
    var newSub =
        SubModel(added: _added, removed: _removed, instructions: _instructions);

    subs.add(newSub);
  }

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
    result.add(
      {
        'added': sub.added,
        'removed': sub.removed,
        'instructions': sub.instructions,
        'rate': sub.rate,
        'ratesNum': sub.ratesNum,
      },
    );
  }
  return result;
}

List<SubModel> getSubs(dynamic subList) {
  List<SubModel> result = [];
  int len = subList == null ? 0 : subList.length;
  for (int i = 0; i < len; i++) {
    result.add(
      SubModel(
        added: ListFormat(subList[i]['added']),
        removed: ListFormat(subList[i]['removed']),
        instructions: ListFormat(subList[i]['instructions']),
        rate: subList[i]['rate'],
        ratesNum: subList[i]['ratesNum'],
      ),
    );
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
    Key? key,
    required this.subModel,
  }) : super(key: key);

  final SubModel subModel;
  List<Widget> added = [
        Text(
          'Add:',
          style: kMainTextStyle,
        ),
      ],
      removed = [
        Text(
          'remove:',
          style: kMainTextStyle,
        ),
      ],
      instructions = [
        Text(
          'Notes:',
          style: kMainTextStyle,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    for (var e in subModel.added) {
      added.add(Text(
        '+ $e',
        style: kSmallTextStyle,
      ));
    }
    for (var e in subModel.removed) {
      removed.add(Text(
        '- $e',
        style: kSmallTextStyle,
      ));
    }
    for (var e in subModel.instructions) {
      instructions.add(Text(
        '* $e',
        style: kSmallTextStyle,
      ));
    }
    return Row(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 375.0,
              width: 300.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: HexColor("#d1cae3"),
              ),
            ),
            Positioned(
              left: 80,
              bottom: 130.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Column(
                        children: added,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: removed,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: instructions,
                      ),
                    ],
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
    );
  }
}
