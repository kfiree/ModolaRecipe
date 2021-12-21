// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Styles/constants.dart';
import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/Widgets/ingredient_card.dart';
import 'package:flutter/foundation.dart';
import 'package:modolar_recipe/Views/main_screen.dart';
import 'package:modolar_recipe/Widgets/loading.dart';
import 'package:modolar_recipe/Widgets/rating.dart';
import 'package:modolar_recipe/Widgets/recipe_views.dart';

class FullViewScreen extends StatefulWidget {
  const FullViewScreen({Key? key}) : super(key: key);

  static const String idScreen = "detail_recipe";

  @override
  _FullViewScreenState createState() => _FullViewScreenState();
}

class _FullViewScreenState extends State<FullViewScreen> {
  // late Future<FullRecipe> recipeToShow;
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final Map<String, dynamic> recipe = arguments['recipe'];

    return Scaffold(
        backgroundColor: HexColor('#998fb3'),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
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
                                  builder: (BuildContext context) =>
                                      RateRecipe(),
                                );
                              },
                            ),
                            CircleButton(
                              color: HexColor('##785ac7'),
                              icon: Icons.keyboard_arrow_left,
                              callback: () => {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    MainScreen.idScreen, (route) => false)
                              },
                            ),
                          ],
                        )),
                    Stack(
                      clipBehavior: Clip.hardEdge,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 25.0,
                          ),
                          child: Center(
                            child: CircleNetworkImage(
                              imageURL: recipe['image'],
                              radius: 250.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // DetailHeaderCard(image),
              Expanded(
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
                            recipe['label'],
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand",
                            ),
                          ),
                          Icon(Icons.no_food, color: Colors.green, size: 20),
                          Icon(Icons.local_drink, color: Colors.green, size: 20),
                          Text(
                            recipe['totalTime'].toString(),
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
                        children:
                          List.generate(recipe['ingredients'].length, (index) {
                            return IngredientCard(
                              name: recipe['ingredients'][index]['food'],
                              quantity: recipe['ingredients'][index]['quantity'].toString(),
                              unit: recipe['ingredients'][index]['measure'],
                            );
                          }),
                        //recipe['ingredients'][i]['text'/'quantity'/measure']
                        // children: <Widget>[
                        //   IngredientCard(
                        //     name: 'All Purpose Flour',
                        //     quantity: '2',
                        //     unit: 'cups',
                        //   ),
                        //   IngredientCard(
                        //     name: 'Milk',
                        //     quantity: '2',
                        //     unit: 'cups',
                        //   ),
                        //   IngredientCard(
                        //     name: 'Eggs',
                        //     quantity: '2',
                        //     unit: 'cups',
                        //   ),
                        //   IngredientCard(
                        //     name: 'Blueberries',
                        //     quantity: '2',
                        //     unit: 'cups',
                        //   ),
                        // ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('To the full recipe!',
                          style: TextStyle(
                            color: Color(0xff909090),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Quicksand",
                          )),
                      Row(
                        children: <Widget> [
                          IconButton(
                            icon: Icon(Icons.dining_outlined),
                            tooltip: 'Increase volume by 10',
                            onPressed: () {
                              
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              // DetailInfoCard(recipe),
            ],
          ),
        ));
  }
}

// class DetailHeaderCard extends StatelessWidget {
//   late String image;
//   DetailHeaderCard(String image) {
//     image = image;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: 1,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               vertical: 20.0,
//               horizontal: 25.0,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 CircleButton(
//                   color: HexColor('##785ac7'),
//                   icon: Icons.star,
//                   callback: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) => RateRecipe(),
//                     );
//                   },
//                 ),
//                 CircleButton(
//                   color: HexColor('##785ac7'),
//                   icon: Icons.keyboard_arrow_left,
//                   callback: () => {
//                     Navigator.pushNamedAndRemoveUntil(
//                         context, MainScreen.idScreen, (route) => false)
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Stack(
//             clipBehavior: Clip.hardEdge,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(
//                   right: 25.0,
//                 ),
//                 child: Center(
//                   child: CircleNetworkImage(
//                     imageURL: image,
//                     radius: 250.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DetailInfoCard extends StatelessWidget {
//   late Map<String, dynamic> recipe;
//   // TODO check why this line is for
//   DetailInfoCard(Map<String, dynamic> recipe) {
//     recipe = recipe;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final recipe = ModalRoute.of(context)!.settings.arguments as Map;
//     return Expanded(
//       flex: 2,
//       child: Container(
//         padding: EdgeInsets.only(
//           left: 25.0,
//           right: 25.0,
//           top: 30.0,
//         ),
//         margin: EdgeInsets.only(top: 20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(50.0),
//           ),
//         ),
//         child: ListView(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const <Widget>[
//                 Text(
//                   'Pancakes',
//                   style: TextStyle(
//                     fontSize: 35,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "Quicksand",
//                   ),
//                 ),
//                 Icon(Icons.no_food, color: Colors.green, size: 20),
//                 Icon(Icons.local_drink, color: Colors.green, size: 20),
//                 Text(
//                   '10 mins',
//                   style: TextStyle(
//                     fontFamily: "Quicksand",
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFBFBFBF),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               'Ingredients',
//               style: TextStyle(
//                 color: Color(0xff909090),
//                 fontWeight: FontWeight.w700,
//                 fontFamily: "Quicksand",
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Column(
//               children: <Widget>[
//                 IngredientCard(
//                   name: 'All Purpose Flour',
//                   quantity: '2',
//                   unit: 'cups',
//                 ),
//                 IngredientCard(
//                   name: 'Milk',
//                   quantity: '2',
//                   unit: 'cups',
//                 ),
//                 IngredientCard(
//                   name: 'Eggs',
//                   quantity: '2',
//                   unit: 'cups',
//                 ),
//                 IngredientCard(
//                   name: 'Blueberries',
//                   quantity: '2',
//                   unit: 'cups',
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text('Steps',
//                 style: TextStyle(
//                   color: Color(0xff909090),
//                   fontWeight: FontWeight.w700,
//                   fontFamily: "Quicksand",
//                 )),
//             Column(
//               children: const <Widget>[
//                 StepEntry(
//                   text: 'Preheat the oven to 450 degrees',
//                   initialStep: true,
//                 ),
//                 StepEntry(
//                     text:
//                         'Add the basil leaves (but keep some for the presentation) and blend to a green paste.'),
//                 StepEntry(text: 'Preheat the oven to 450 degrees'),
//               ],
//             ),
//             SizedBox(
//               height: 50,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
