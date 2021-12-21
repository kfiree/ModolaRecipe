import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Styles/constants.dart';
import 'package:modolar_recipe/views/main_screen.dart';
import 'package:modolar_recipe/views/recipe_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:modolar_recipe/Widgets/loading.dart';

class StepEntry extends StatelessWidget {
  final String text;
  final bool initialStep;
  final bool loading = false, searchView = false;
  

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
    required this.recipeImageURL,
    required this.name,
    required this.cookTime,
    required this.energy,
  });

  final String recipeImageURL;
  final String name;
  final int cookTime;
  final int energy;
  // final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => {
            Navigator.of(context).pushNamed(FullViewScreen.idScreen)
            // Navigator.pushNamedAndRemoveUntil(
            //     context, ShowScreen.idScreen, (route) => false)
          },
          child: Stack(
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
                  imageURL: recipeImageURL,
                ),
              ),
              Positioned(
                left: 10,
                bottom: 130.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: kMainTextStyle,
                    ),
                    Text(
                      "$cookTime min",
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
                      "$energy",
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
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}

class RecipeTile extends StatelessWidget {
  const RecipeTile({
    Key? key,
    required this.title,
    required this.desc,
    required this.imgUrl,
    required this.url,
    required this.uri,
    required this.recipeJson,
  }) : super(key: key);

  final String title, desc, imgUrl, url, uri;
  final Map<String, dynamic> recipeJson;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, FullViewScreen.idScreen, arguments: {'recipe': recipeJson});
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.network(
              imgUrl,
              height: 2000,
              width: 200,
              fit: BoxFit.fill,
            ),
          ),
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(30.0),
        //   child: Image.network(
        //     imgUrl,
        //     height: 2000,
        //     width: 200,
        //     fit: BoxFit.fill,
        //   ),
        // ),
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: Flexible(
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
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
                        color: Colors.black,
                        fontFamily: 'Overpass',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                        overflow: TextOverflow.ellipsis,
                        // fontFamily: 'OverpassRegular'
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FullRecipe {
  final String label;
  final String image;
  final String source;
  final String url;
  final String uri;
  final double calories;
  final double cookingTime;
  final List<Map<String, dynamic>> ingredients;
  final String cuisineType;
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
  final String label;
  final String image;
  final String source;
  final String url;
  final String uri;
  final recipeJson;
  // String cookTime;

  RecipeModel(
      {required this.url,
      required this.label,
      required this.source,
      required this.image,
      required this.uri,
      required this.recipeJson, /**, this.cookTime*/});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
        url: parsedJson['url'],
        image: parsedJson['image'],
        source: parsedJson['source'],
        label: parsedJson['label'],
        uri: (parsedJson['uri']).split('#')[1], 
        recipeJson: parsedJson
    );
        
  }
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
        label: json['label'],
        uri: json['uri'].split('#')[1],
        image: json['image'],
        source: json['source'],
        url: json['url'], 
        recipeJson: json);
  }

  factory RecipeModel.fromRecipeMap(Map<String, dynamic> json) {
    return RecipeModel(
        label: json['label'],
        uri: json['uri'].split('#')[1],
        image: json['image'],
        source: json['source'],
        url: json['url'], 
        recipeJson: json);
  }
}
