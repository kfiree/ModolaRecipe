import 'package:flutter/material.dart';

import 'package:modolar_recipe/Styles/constants.dart';

class IngredientCard extends StatefulWidget {
  IngredientCard({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.edit,
    required this.removedList,
    this.removed = false,
  });
  final String name;
  final String quantity;
  final String unit;
  final bool edit;
  bool removed;
  List<String> removedList;
  @override
  _IngredientCardState createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
        left: 10,
      ),
      child: Row(
        children: <Widget>[
          if (widget.edit)
            IconButton(
              icon: widget.removed
                  ? const Icon(Icons.add)
                  : const Icon(Icons.cancel),
              tooltip: 'delete ingredient',
              onPressed: () {
                setState(() {
                  widget.removed = !widget.removed;
                  if (widget.removed) {
                    widget.removedList.add(widget.name);
                  } else {
                    widget.removedList.remove(widget.name);
                  }
                  // widget.removedList.add('value');
                });
              },
            ),
          Expanded(
            flex: 5,
            child: Text(
              widget.name,
              style: widget.removed ? deletedStyle : kIngredientsNameStyle,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.quantity,
                style: widget.removed ? deletedStyle : kSecondaryTextStyle,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.unit,
                style: widget.removed ? deletedStyle : kSecondaryTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   String dropdownValue = widget.name;
  //   List<String> subs = [widget.name, 'sub2', 'sub3', 'sub4', 'sub5'];
  //   // String dropdownValue = 'All Porpuse Flour';
  //   // subs[0] = widget.name;
  //   return Padding(
  //     padding: const EdgeInsets.only(
  //       bottom: 10,
  //       left: 10,
  //     ),
  //     child: Row(
  //       children: <Widget>[
  //         DropdownButton<String>(
  //           value: dropdownValue,
  //           icon: const Icon(Icons.arrow_drop_down),
  //           elevation: 16,
  //           style: const TextStyle(
  //             fontFamily: "Quicksand",
  //             fontWeight: FontWeight.w700,
  //             color: Colors.black,
  //           ),
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               dropdownValue = newValue!;
  //             });
  //           },
  //           items: //<String>['All Porpuse Flour', 'Two', 'three', 'Four']
  //               subs.map<DropdownMenuItem<String>>((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value),
  //             );
  //           }).toList(),
  //         ),
  //         // DropDownList(),
  //         Expanded(
  //           child: Align(
  //             alignment: Alignment.centerRight,
  //             child: Text(
  //               widget.quantity,
  //               style: TextStyle(
  //                 fontFamily: "Quicksand",
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xFFBFBFBF),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Align(
  //             alignment: Alignment.centerRight,
  //             child: Text(
  //               widget.unit,
  //               style: TextStyle(
  //                 fontFamily: "Quicksand",
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xFFBFBFBF),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

/*
     ========= JSON EXAMPLE =========

        {
          "text": "2 1/2 cups grappa or unflavored vodka",
          "quantity": 2.5,
          "measure": "cup",
          "food": "vodka",
          "weight": 556.0000000000001,
          "foodCategory": "liquors and cocktails",
          "foodId": "food_aqnx4i8aieyph2athk58cb3cr69w",
          "image": "https://www.edamam.com/food-img/e1a/e1a4708099e89fdadeb81c2d95deaa34.jpg"
        },
 */
class IngredientModel {
  final String text, unit, category, image, id, name;
  final double quantity;

  IngredientModel({
    required this.text,
    required this.quantity,
    required this.unit,
    required this.name,
    required this.category,
    required this.image,
    required this.id,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    String name = json['food'] ?? 'No Name',
        category = json['foodCategory'] ?? 'No category',
        id = json['foodId'] ?? 'No Id',
        image = json['image'] ?? 'No Image',
        text = json['text'] ?? 'No text',
        unit = (json['measure'] == null || json['measure'] == '<unit>')
            ? ''
            : json['measure'];
    double quantity =
        json['quantity'] == null ? 0 : json['quantity'].toInt().toDouble();

    return IngredientModel(
      name: name,
      category: category,
      id: id,
      image: image,
      quantity: quantity,
      text: text,
      unit: unit,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['quantity'] = quantity;
    data['measure'] = unit;
    data['food'] = name;
    data['foodCategory'] = category;
    data['image'] = image;
    data['food'] = name;
    return data;
  }

  @override
  String toString() {
    String data = '''
    text: $text
    name: $name
    quantity: $quantity
    unit: $unit
    foodCategory: $category
    image: $image
    foodId: $id
    ''';
    return '{\n$data}';
  }
}
