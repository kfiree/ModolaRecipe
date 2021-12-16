class recipe_card {
  final String image;
  final String url;
  final String source;
  final String label;

  recipe_card(
      {required this.image,
      required this.url,
      required this.label,
      required this.source});

  factory recipe_card.fromMap(Map<String, dynamic> parsedJson) {
    return recipe_card(
        image: parsedJson["image"],
        url: parsedJson["url"],
        source: parsedJson["source"],
        label: parsedJson["label"]);
  }
}







// import 'package:flutter/material.dart';

// class RecipeCard extends StatelessWidget {
//   final String title;
//   final String rating;
//   final String cookTime;
//   final String thumbnailUrl;
//   RecipeCard({
//     required this.title,
//     required this.cookTime,
//     required this.rating,
//     required this.thumbnailUrl,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//       width: MediaQuery.of(context).size.width,
//       height: 180,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.6),
//             offset: Offset(
//               0.0,
//               10.0,
//             ),
//             blurRadius: 10.0,
//             spreadRadius: -6.0,
//           ),
//         ],
//         image: DecorationImage(
//           colorFilter: ColorFilter.mode(
//             Colors.black.withOpacity(0.35),
//             BlendMode.multiply,
//           ),
//           image: NetworkImage(thumbnailUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Align(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 5.0),
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 19,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             alignment: Alignment.center,
//           ),
//           Align(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(5),
//                   margin: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.4),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.star,
//                         color: Colors.yellow,
//                         size: 18,
//                       ),
//                       SizedBox(width: 7),
//                       Text(rating),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(5),
//                   margin: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.4),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.schedule,
//                         color: Colors.yellow,
//                         size: 18,
//                       ),
//                       SizedBox(width: 7),
//                       Text(cookTime),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             alignment: Alignment.bottomLeft,
//           ),
//         ],
//       ),
//     );
//   }
// }
