// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modolar_recipe/Widgets/circle_button.dart';
import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Widgets/ingredient_card.dart';
import 'package:flutter/foundation.dart';

class DetailRecipe extends StatefulWidget {
  const DetailRecipe({Key? key}) : super(key: key);

  static const String idScreen = "detail_recipe";

  @override
  _DetailRecipeState createState() => _DetailRecipeState();
}

class _DetailRecipeState extends State<DetailRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#FFECD9'),
        body: SafeArea(
          child: Column(
            children: const <Widget>[
              DetailHeaderCard(),
              DetailInfoCard(),
            ],
          ),
        ));
  }
}

class DetailHeaderCard extends StatelessWidget {
  const DetailHeaderCard({Key? key}) : super(key: key);

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
                  icon: Icons.keyboard_arrow_left,
                ),
                CircleButton(
                  icon: Icons.share,
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
                padding: const EdgeInsets.only(
                  right: 25.0,
                ),
                child: Center(
                  child: CircleNetworkImage(
                    imageURL:
                        "https://res.cloudinary.com/norgesgruppen/images/c_scale,dpr_auto,f_auto,q_auto:eco,w_1600/a9ezar46fbxjvuyd8r2z/hjemmelaget-italiensk-pizza-med-bacon",
                    radius: 225.0,
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
  const DetailInfoCard({Key? key}) : super(key: key);

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
              children: const <Widget>[
                Text(
                  'Pancakes !',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quicksand",
                  ),
                ),
                Text(
                  '10 mins',
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

class StepEntry extends StatelessWidget {
  final String text;
  final bool initialStep;

  //TODO check original
  //StepEntry({required this.text, this.initialStep = false});
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
                    color: HexColor('#F9AF9C'),
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
                  color: HexColor('#F9AF9C'),
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

class SmallRecipeView extends StatefulWidget {
  final String postUrl;

  SmallRecipeView({required this.postUrl});

  @override
  _SmallRecipeViewState createState() => _SmallRecipeViewState();
}

class _SmallRecipeViewState extends State<SmallRecipeView> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget> [
        Container(
          width: MediaQuery.of(context).size.width,
          child:Row(
                mainAxisAlignment: kIsWeb
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "AppGuy",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Overpass'),
                  ),
                  Text(
                    "Recipes",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontFamily: 'Overpass'),
                  )
                ],
              )
        )

        ],),
    );
  }
}
