import 'package:flutter/material.dart';

class CircleNetworkImage extends StatelessWidget {
  final double radius;
  final String imageURL;

  const CircleNetworkImage(
      {Key? key, required this.radius, required this.imageURL})
      : super(key: key);

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

  const CircleAvatarImage(
      {Key? key, required this.radius, required this.imageURL})
      : super(key: key);

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
