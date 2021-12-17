// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:modolar_recipe/Utils/constants.dart';
// import 'package:modolar_recipe/Widgets/buttons.dart';
// import 'package:modolar_recipe/Widgets/circle_image.dart';
// import 'package:modolar_recipe/Widgets/detail_entries.dart';
// import 'package:share/share.dart';

// import 'package:modolar_recipe/views/search.dart';

// class RecipeScreen extends StatefulWidget {
//   static String idScreen = 'recipe_screen';

//   const RecipeScreen({Key? key}) : super(key: key);
//   @override
//   _RecipeScreenState createState() => _RecipeScreenState();
// }

// class _RecipeScreenState extends State<RecipeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: HexColor('#FFECD9'),
//         body: SafeArea(
//           child: Column(
//             children: const <Widget>[
//               DetailHeaderCard(),
//               DetailInfoCard(),
//             ],
//           ),
//         ));
//   }
// }

// class DetailHeaderCard extends StatelessWidget {
//   const DetailHeaderCard({Key? key}) : super(key: key);

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
//                 IconButton(
//                   onPressed: () => Navigator.pushNamedAndRemoveUntil(
//                       context, SearchScreen.idScreen, (route) => false),
//                   icon: Icon(Icons.keyboard_arrow_left, color: Colors.blue),
//                 ),
//                 CircleButton(
//                   icon: Icons.share,
//                 ),
//               ],
//             ),
//           ),
//           //TODO Need to figure out how to do overlapping oversized photos so we can follow the design
//           Stack(
//             // overflow: Overflow.clip,
//             // children: <Widget>[
//             clipBehavior: Clip.hardEdge,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(
//                   right: 25.0,
//                 ),
//                 child: Center(
//                   child: CircleNetworkImage(
//                     imageURL:
//                         "https://res.cloudinary.com/norgesgruppen/images/c_scale,dpr_auto,f_auto,q_auto:eco,w_1600/a9ezar46fbxjvuyd8r2z/hjemmelaget-italiensk-pizza-med-bacon",
//                     radius: 225.0,
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
//   const DetailInfoCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
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
//               //TODO check if const needed
//               children: const <Widget>[
//                 Text(
//                   'Pancakes',
//                   style: kHeaderTextStyle,
//                 ),
//                 Text(
//                   '10 mins',
//                   style: kSecondaryTextStyle,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               'Ingredients',
//               style: kSubHeaderTextStyle,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Column(
//               children: <Widget>[
//                 IngredientsEntry(
//                   name: 'All Purpose Flour',
//                   quantity: '2',
//                   unit: 'cups',
//                 ),
//                 IngredientsEntry(
//                   name: 'Milk',
//                   quantity: '2',
//                   unit: 'cups',
//                 ),
//                 IngredientsEntry(
//                   name: 'Eggs',
//                   quantity: '2',
//                   unit: 'cups',
//                 ),
//                 IngredientsEntry(
//                   name: 'Blueberries',
//                   quantity: '2',
//                   unit: 'cups',
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text('Steps', style: kSubHeaderTextStyle),
//             Column(
//               children: <Widget>[
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
