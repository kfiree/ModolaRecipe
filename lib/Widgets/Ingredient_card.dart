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
    // dropdownValue = widget.name;
    String dropdownValue = 'One';

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 10,
      ),
      child: Row(
        children: <Widget>[
          // DropdownButton(
          //   hint: Text("change ingredient: "),
          //   value: dropdownValue,
          //   onChanged: (newVal) {
          //     setState(() {
          //       dropdownValue = newVal.toString();
          //     });
          //   },
          //   items: subs.map((valueItem) {
          //     return DropdownMenuItem(
          //       value: valueItem,
          //       child: Text(valueItem),
          //     );
          //   }).toList(),
          // ),

          // Expanded(
          //   flex: 5,
          //   child: Text(
          //     widget.name,
          //     style: TextStyle(
          //       fontFamily: "Quicksand",
          //       fontWeight: FontWeight.w700,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          DropDownList(),
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

class DropDownList extends StatelessWidget {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        print("value is now $newValue");
        // setState(() {
        //   dropdownValue = newValue!;
        // });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
