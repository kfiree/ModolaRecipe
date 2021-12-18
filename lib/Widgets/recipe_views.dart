import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
  const RecipeTile(
      {Key? key,
      required this.title,
      required this.desc,
      required this.imgUrl,
      required this.url})
      : super(key: key);

  final String title, desc, imgUrl, url;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.network(
            imgUrl,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
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
                    title,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontFamily: 'Overpass'),
                  ),
                  Text(
                    desc,
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
    );
  }
}

class RecipeModel {
  final String label;
  final String image;
  final String source;
  final String url;
  // String cookTime;

  RecipeModel(
      {required this.url,
      required this.label,
      required this.source,
      required this.image /**, this.cookTime*/});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
        url: parsedJson['url'],
        image: parsedJson['image'],
        source: parsedJson['source'],
        label: parsedJson['label']);
  }
}
