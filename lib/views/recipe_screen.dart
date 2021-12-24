// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';

import 'package:modolar_recipe/Views/main_screen.dart';
// import 'package:modolar_recipe/Styles/constants.dart';
// import 'package:flutter/foundation.dart';
import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/Widgets/ingredients.dart';
import 'package:modolar_recipe/Widgets/rating.dart';
import 'package:modolar_recipe/Widgets/recipes.dart';
import 'package:url_launcher/url_launcher.dart';

class FullViewScreen extends StatefulWidget {
  FullViewScreen({Key? key}) : super(key: key);

  static const String idScreen = "detail_recipe";
  String applicationId = "41ca25af",
      applicationKey = "ab51bad1b862188631ce612a9b1787a9";
  @override
  _FullViewScreenState createState() => _FullViewScreenState();
}

class _FullViewScreenState extends State<FullViewScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final model = routeArgs['Model'];

    return Scaffold(
        backgroundColor: HexColor('#998fb3'),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              DetailHeaderCard(model: model),
              DetailInfoCard(model: model),
            ],
          ),
        ));
  }
}

class DetailHeaderCard extends StatelessWidget {
  const DetailHeaderCard({Key? key, required this.model}) : super(key: key);
  final RecipeModel model;
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final UID = routeArgs['UID'];
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 25.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleButton(
                  color: HexColor('##785ac7'),
                  icon: Icons.star,
                  callback: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => RateRecipe(),
                    );
                  },
                ),
                CircleButton(
                  color: HexColor('##785ac7'),
                  icon: Icons.keyboard_arrow_left,
                  callback: () => {
                    Navigator.of(context).pushNamed(
                      MainScreen.idScreen,
                      arguments: {'UID': UID},
                    ),
                  },
                ),
              ],
            ),
          ),
          //TODO Need to figure out how to do overlapping oversized photos so we can follow the design
          Stack(
            //            overflow: Overflow.clip,
            // children: <Widget>[
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  right: 25.0,
                ),
                child: Center(
                  child: CircleNetworkImage(
                    imageURL: model.image,
                    radius: 250.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailInfoCard extends StatelessWidget {
  // TODO check why this line is for
  const DetailInfoCard({Key? key, required this.model}) : super(key: key);
  final RecipeModel model;
  @override
  Widget build(BuildContext context) {
    List<IngredientCard> ingredientsList = List.generate(
      model.ingredients.length,
      (int i) => IngredientCard(
        name: model.ingredients[i].name,
        quantity: model.ingredients[i].quantity.toString(),
        unit: model.ingredients[i].unit,
      ),
    );
    //     IngredientCard(
    //   name: 'All Purpose Flour',
    //   quantity: '2',
    //   unit: 'cups',
    // ),
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          top: 30.0,
        ),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  model.label,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quicksand",
                  ),
                ),
                Icon(Icons.no_food, color: Colors.green, size: 20),
                Icon(Icons.local_drink, color: Colors.green, size: 20),
                if (model.cookingTime != 0.0)
                  Text(
                    model.cookingTime.toInt().toString(),
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFBFBFBF),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Ingredients',
              style: TextStyle(
                color: Color(0xff909090),
                fontWeight: FontWeight.w700,
                fontFamily: "Quicksand",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: ingredientsList,
              // IngredientCard(
              //   name: 'All Purpose Flour',
              //   quantity: '2',
              //   unit: 'cups',
              // ),
              // IngredientCard(
              //   name: 'Milk',
              //   quantity: '2',
              //   unit: 'cups',
              // ),
              // IngredientCard(
              //   name: 'Eggs',
              //   quantity: '2',
              //   unit: 'cups',
              // ),
              // IngredientCard(
              //   name: 'Blueberries',
              //   quantity: '2',
              //   unit: 'cups',
              // ),
            ),
            SizedBox(
              height: 20,
            ),
            // Text('Steps',
            //     style: TextStyle(
            //       color: Color(0xff909090),
            //       fontWeight: FontWeight.w700,
            //       fontFamily: "Quicksand",
            //     )),
            Column(
                // children: const <Widget>[
                //   StepEntry(
                //     text: 'Preheat the oven to 450 degrees',
                //     initialStep: true,
                //   ),
                //   StepEntry(
                //       text:
                //           'Add the basil leaves (but keep some for the presentation) and blend to a green paste.'),
                //   StepEntry(text: 'Preheat the oven to 450 degrees'),
                // ],
                ),
            ElevatedButton(
              onPressed: () {
                _launchURL(model.recipeURL);
              },
              child: const Text('go to recipe website'),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
