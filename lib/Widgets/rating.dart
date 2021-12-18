import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

class RateRecipe extends StatefulWidget {
  const RateRecipe({Key? key}) : super(key: key);

  @override
  _RateRecipeState createState() => _RateRecipeState();
}

class _RateRecipeState extends State<RateRecipe> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      RatingDialog(
        title: Text('Rate this recipe 😍'),
        onSubmitted: (response) {
          print('rating: ${response.rating}, ');
          print('comment: ${response.comment}');
        },
        submitButtonText: 'Submit',
        onCancelled: () => print('cancelled'),
        starColor: Colors.amber,
        enableComment: true,
      ),
    ]);
  }
}
