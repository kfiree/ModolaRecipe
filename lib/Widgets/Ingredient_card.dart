import 'package:flutter/material.dart';

class Ingredient_card extends StatefulWidget {
  Ingredient_card(
      {required this.name, required this.quantity, required this.unit});

  final String name;
  final String quantity;
  final String unit;

  @override
  State<Ingredient_card> createState() => _Ingredient_cardState();
}

class _Ingredient_cardState extends State<Ingredient_card> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 10,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Text(
              widget.name,
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${widget.quantity}',
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBFBFBF),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.unit,
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBFBFBF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
