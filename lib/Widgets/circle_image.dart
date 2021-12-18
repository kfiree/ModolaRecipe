import 'package:flutter/material.dart';

class CircleNetworkImage extends StatelessWidget {
  final double radius;
  final String imageURL;

  CircleNetworkImage({required this.radius, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
            imageURL,
          ),
        ),
      ),
    );
  }
}

class CircleAvatarImage extends StatelessWidget {
  final double radius;
  final String imageURL;

  CircleAvatarImage({required this.radius, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
            imageURL,
          ),
        ),
      ),
    );
  }
}
// CircleAvatar(
//   backgroundImage: AssetImage(
//     'assets/shaniProfile.png',
//     // "https://www.trendrr.net/wp-content/uploads/2017/06/Deepika-Padukone-1.jpg",
//   ),
//   radius: 50.0,
// ),