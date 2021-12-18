// ignore_for_file: file_names

import 'package:flutter/material.dart';

class IngredientCard extends StatefulWidget {
  IngredientCard(
      {required this.name, required this.quantity, required this.unit});

  final String name;
  final String quantity;
  final String unit;

  @override
  State<IngredientCard> createState() => _Ingredient_cardState();
}

// String dropdownValue = "wow";
// List subs = ['sub1', 'sub2', 'sub3', 'sub4', 'sub5'];

class _Ingredient_cardState extends State<IngredientCard> {
  // TODO import list
  // List<String> subs = ['sub1', 'sub2', 'sub3', 'sub4', 'sub5'];

  @override
  Widget build(BuildContext context) {
    String dropdownValue = widget.name;
    List<String> subs = [widget.name, 'sub2', 'sub3', 'sub4', 'sub5'];
    // String dropdownValue = 'All Porpuse Flour';
    // subs[0] = widget.name;
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 10,
      ),
      child: Row(
        children: <Widget>[
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: //<String>['All Porpuse Flour', 'Two', 'three', 'Four']
                subs.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // DropDownList(),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.quantity,
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
