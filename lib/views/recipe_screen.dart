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
import 'package:modolar_recipe/Widgets/ingredient_card.dart';
import 'package:modolar_recipe/Widgets/rating.dart';
import 'package:modolar_recipe/Widgets/recipes.dart';

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
    final UID = routeArgs['UID'];
    // final URI = routeArgs['URI'];
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

  // fetchRecipeAndNavigateToRecipeView(String recipe_id) async {
  //   FullRecipe recipe;
  //   var queryUrl =
  //       'https://api.edamam.com/search?r=http%3A%2F%2Fwww.edamam.com%2Fontologies%2Fedamam.owl%23$recipe_id&app_id=${widget.applicationId}&app_key=${widget.applicationKey}';

  //   final response = await http.get(Uri.parse(queryUrl));
  //   if (response.statusCode == 200) {
  //     recipe = FullRecipe.fromJson(jsonDecode(response.body));
  //     Navigator.pushNamed(context, FullViewScreen.idScreen);
  //   }
  // }
}

class DetailHeaderCard extends StatelessWidget {
  const DetailHeaderCard({Key? key, required this.model}) : super(key: key);
  final RecipeModel model;
  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushNamedAndRemoveUntil(
                        context, MainScreen.idScreen, (route) => false)
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
              children: <Widget>[
                IngredientCard(
                  name: 'All Purpose Flour',
                  quantity: '2',
                  unit: 'cups',
                ),
                IngredientCard(
                  name: 'Milk',
                  quantity: '2',
                  unit: 'cups',
                ),
                IngredientCard(
                  name: 'Eggs',
                  quantity: '2',
                  unit: 'cups',
                ),
                IngredientCard(
                  name: 'Blueberries',
                  quantity: '2',
                  unit: 'cups',
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('Steps',
                style: TextStyle(
                  color: Color(0xff909090),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Quicksand",
                )),
            Column(
              children: const <Widget>[
                StepEntry(
                  text: 'Preheat the oven to 450 degrees',
                  initialStep: true,
                ),
                StepEntry(
                    text:
                        'Add the basil leaves (but keep some for the presentation) and blend to a green paste.'),
                StepEntry(text: 'Preheat the oven to 450 degrees'),
              ],
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
