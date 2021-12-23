import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modolar_recipe/Widgets/ingredients.dart';

import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Styles/constants.dart';
import 'package:modolar_recipe/views/recipe_screen.dart';
import 'package:flutter/foundation.dart';

class StepEntry extends StatelessWidget {
  final String text;
  final bool initialStep;

  const StepEntry({Key? key, required this.text, this.initialStep = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 25,
        left: 10.0,
        top: 0.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: 5.0,
                  height: initialStep ? 0 : 40,
                  decoration: BoxDecoration(
                    color: HexColor('#998fb3'),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              Expanded(
                flex: 69,
                child: SizedBox(
                  height: 10.0,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                  color: HexColor('#998fb3'),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              Flexible(
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecipeMediumView extends StatelessWidget {
  RecipeMediumView({
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
                      recipeModel.label,
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
                      recipeModel.label,
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

class FullRecipe {
  final String label, image, source, url, uri, cuisineType;
  final double calories;
  final int cookingTime;
  final List<Map<String, dynamic>> ingredients;
  final List<String> cautions;

  FullRecipe(
      {required this.label,
      required this.image,
      required this.source,
      required this.url,
      required this.uri,
      required this.calories,
      required this.cookingTime,
      required this.ingredients,
      required this.cuisineType,
      required this.cautions});

  factory FullRecipe.fromJson(Map<String, dynamic> json) {
    return FullRecipe(
        label: json['label'],
        image: json['image'],
        source: json['source'],
        url: json['url'],
        uri: json['uri'],
        calories: json['calories'],
        cookingTime: json['cookingTime'],
        ingredients: json['ingredients'],
        cuisineType: json['cuisineType'],
        cautions: json['cautions']);
  }
}

class RecipeModel {
  final String label, image, source, url, uri, shareAs;
  final List<String> mealType,
      dishType,
      dietLabels,
      healthLabels,
      cuisineType,
      cautions;
  final int cookingTime;
  final double calories, yield, totalWeight;
  final List<IngredientModel> ingredients;

  RecipeModel({
    required this.uri,
    required this.label,
    required this.image,
    required this.source,
    required this.url,
    required this.shareAs,
    required this.yield,
    required this.dietLabels,
    required this.healthLabels,
    required this.cautions,
    required this.ingredients,
    required this.calories,
    required this.totalWeight,
    required this.cookingTime,
    required this.cuisineType,
    required this.mealType,
    required this.dishType,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    var uri = json['uri'] ?? '',
        label = json['label'] ?? '',
        image = json['image'] ?? '',
        source = json['source'] ?? '',
        url = json['url'] ?? '',
        shareAs = json['shareAs'] ?? '',
        yield = json['yield'] ?? '',
        dietLabels = json['dietLabels'].cast<String>() ?? [],
        healthLabels = json['healthLabels'].cast<String>() ?? [],
        cautions = json['cautions'].cast<String>() ?? [],
        calories = json['calories'] ?? '',
        totalWeight = json['totalWeight'] ?? '',
        cuisineType = json['cuisineType'].cast<String>() ?? '',
        mealType = json['mealType'].cast<String>() ?? '',
        cookingTime = json['totalTime'] != null ? json['totalTime'].toInt() : 0,
        dishType = json['dishType'].cast<String>() ?? '';

    List<IngredientModel> ingredients = [];
    json['ingredients'].forEach((ingredient) =>
        {ingredients.add(IngredientModel.fromJson(ingredient))});
    ingredients.cast<IngredientModel>();
    return RecipeModel(
      uri: uri,
      label: label,
      image: image,
      source: source,
      url: url,
      shareAs: shareAs,
      yield: yield,
      dietLabels: dietLabels,
      healthLabels: healthLabels,
      cautions: cautions,
      calories: calories,
      totalWeight: totalWeight,
      cookingTime: cookingTime,
      cuisineType: cuisineType,
      mealType: mealType,
      dishType: dishType,
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['uri'] = uri;
    data['label'] = label;
    data['image'] = image;
    data['source'] = source;
    data['url'] = url;
    data['shareAs'] = shareAs;
    data['yield'] = yield;
    data['dietLabels'] = dietLabels;
    data['healthLabels'] = healthLabels;
    data['cautions'] = cautions;
    data['ingredients'] = ingredients.map((v) => v.toJson()).toList();
    data['calories'] = calories;
    data['totalWeight'] = totalWeight;
    data['totalTime'] = cookingTime;
    data['cuisineType'] = cuisineType;
    data['mealType'] = mealType;
    data['dishType'] = dishType;
    return data;
  }

  List<IngredientModel> toIngredientList(
      List<Map<String, dynamic>> ingredientsJson) {
    List<IngredientModel> ingredientList = [];
    ingredientsJson.forEach((ingredient) =>
        {ingredientList.add(IngredientModel.fromJson(ingredient))});
    return ingredientList;
  }

  @override
  String toString() {
    String data = '''
    calories: $calories,
    cookingTime: $cookingTime,
    ingredients: $ingredients,
    cuisineType: $cuisineType,
    cautions: $cautions,
    url: $url,
    label: $label,
    source: $source,
    image: $image,
    uri: $uri
    ''';
    return '{\n$data}';
  }
}
