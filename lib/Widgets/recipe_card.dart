import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Utils/constants.dart';
// class recipe_card {
//   final String image;
//   final String url;
//   final String source;
//   final String label;

//   recipe_card(
//       {required this.image,
//       required this.url,
//       required this.label,
//       required this.source});

//   factory recipe_card.fromMap(Map<String, dynamic> parsedJson) {
//     return recipe_card(
//         image: parsedJson["image"],
//         url: parsedJson["url"],
//         source: parsedJson["source"],
//         label: parsedJson["label"]);
//   }
// }

class RecipeBigView extends StatelessWidget {
  RecipeBigView({
    required this.recipeImageURL,
    required this.name,
    required this.cookTime,
    required this.timeUnit,
    required this.energy,
    required this.energyUnit,
  });

  final String recipeImageURL;
  final String name;
  final int cookTime;
  final String timeUnit;
  final int energy;
  final String energyUnit;
  // final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                "$cookTime $timeUnit",
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
                energyUnit,
                style: kSubHeaderTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
