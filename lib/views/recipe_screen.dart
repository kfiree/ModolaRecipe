// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:modolar_recipe/Styles/constants.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:modolar_recipe/Views/main_screen.dart';
// import 'package:modolar_recipe/Styles/constants.dart';
// import 'package:flutter/foundation.dart';
import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/Widgets/ingredients.dart';
import 'package:modolar_recipe/Widgets/rating.dart';
import 'package:modolar_recipe/Widgets/recipes.dart';
import 'package:url_launcher/url_launcher.dart';

class FullViewScreen extends StatefulWidget {
  FullViewScreen({Key? key}) : super(key: key);
  List<String> added = [], removed = [];
  static const String idScreen = "detail_recipe";
  String applicationId = "41ca25af",
      applicationKey = "ab51bad1b862188631ce612a9b1787a9";
  @override
  _FullViewScreenState createState() => _FullViewScreenState();
}

class _FullViewScreenState extends State<FullViewScreen> {
  bool editView = false;
  int _selectedIndex = 0;
  String ApplicationID = '1e2b1681',
      ApplicationKey = '47e224016bc268ada433484688f019cf';
  SubModel sub = SubModel();
  List<String> added = [], removedInstructions = [], removedIngredients = [];
  // Map<String, dynamic> sub = {
  //   'added': [],
  //   'removed': [],
  //   'rate': [],
  //   'ratesNum': [],
  // };

  var url = '';
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<String> newIngredientNames = [], instructions = [];
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    RecipeModel model = routeArgs['Model'];
    final UID = routeArgs['UID'];
    List<ingrident> selected = [];

    url = model.url;
    TextEditingController txtController = TextEditingController();
    List<IngredientCard> ingredientsList = List.generate(
      model.ingredients.length,
      (int i) => IngredientCard(
          edit: editView,
          name: model.ingredients[i].name,
          quantity: model.ingredients[i].quantity.toString(),
          unit: model.ingredients[i].unit,
          removedList: removedIngredients),
    );
    List<ingrident> ingredientComp = [];
    // print('44444444444444444444444');
    // print('removed Ingrident ${removedIngredients.toString()}');
    // print('removed Instructions ${removedInstructions.toString()}');
    // print('instructions = ${instructions.toString()}');
    // print('added ${added.toString()}');
    // print('44444444444444444444444');

    List<SubView> recipeWidgets = [];

    for (var sub in model.subs) {
      print('UID is $UID');
      recipeWidgets.add(
        SubView(
          subModel: sub,
        ),
      );
    }
    return Scaffold(
      backgroundColor: HexColor('#998fb3'),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderCard(model: model),
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
                          model.name,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Quicksand",
                          ),
                        ),
                        if (model.cookingTime != 0.0)
                          Row(
                            children: <Widget>[
                              Text(
                                model.cookingTime.toInt().toString(),
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFBFBFBF),
                                ),
                              ),
                              Icon(Icons.timer,
                                  color: Color(0xFFBFBFBF), size: 30),
                            ],
                          )
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
                      height: 20,
                    ),
                    Column(
                      children: ingredientsList,
                    ),
                    if (editView)
                      Row(
                        children: <Widget>[
                          // search
                          Expanded(
                            child: TextField(
                              controller: txtController,
                              decoration: InputDecoration(
                                  hintText: "Start Typeing Ingrideint name",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  )),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () async {
                              if (txtController.text.isNotEmpty) {
                                await fetchIngredients(
                                  txtController.text,
                                  ingredientComp,
                                );
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: Text('Add Ingredient'),
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Form(
                                            child: Column(
                                              children: <Widget>[
                                                MultiSelectBottomSheetField(
                                                  initialChildSize: 0.4,
                                                  listType:
                                                      MultiSelectListType.CHIP,
                                                  searchable: true,
                                                  buttonText:
                                                      Text("Choose ingredient"),
                                                  title: Text("Ingredients"),
                                                  items: ingredientComp
                                                      .map((ingredient) =>
                                                          MultiSelectItem<
                                                                  ingrident>(
                                                              ingredient,
                                                              ingredient.name))
                                                      .toList(),
                                                  onConfirm: (values) {
                                                    ingredientComp.removeWhere(
                                                        (e) => !(values
                                                                .indexOf(e) >=
                                                            0));
                                                    for (ingrident element
                                                        in ingredientComp) {
                                                      newIngredientNames
                                                          .add(element.name);
                                                    }
                                                  },
                                                  chipDisplay:
                                                      MultiSelectChipDisplay(
                                                    onTap: (value) {
                                                      setState(() {
                                                        selected.remove(value);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          RaisedButton(
                                            child: Text("Add"),
                                            onPressed: () {
                                              Navigator.pop(
                                                  context, newIngredientNames);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  ).then(
                                    (val) {
                                      setState(
                                        () {
                                          if (val != null) added.addAll(val);
                                        },
                                      );
                                    },
                                  );
                                });
                              }
                            },
                            child: Icon(Icons.search, color: Colors.black),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    if (model.instructions.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Additional Instructions',
                            style: TextStyle(
                              color: Color(0xff909090),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Quicksand",
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              for (String s in model.instructions)
                                StepEntry(
                                  text: s,
                                  edit: editView,
                                  removedList: removedInstructions,
                                ),
                              if (editView)
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  tooltip: 'add instruction',
                                  onPressed: () {
                                    setState(
                                      () {
                                        int instructionLen =
                                            model.instructions.length;
                                        showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AddInstruction(
                                                    model: model,
                                                    instrucion: instructions,
                                                  );
                                                })
                                            //     .then(
                                            //   (val) {
                                            //     setState(
                                            //       () {
                                            //         print(val);
                                            //         if (val != null) {
                                            //           instructions.add(val);
                                            //         }
                                            //       },
                                            //     );
                                            //   },
                                            // )
                                            ;
                                        if (instructionLen !=
                                            model.instructions.length) {
                                          setState(() {});
                                        }
                                      },
                                    );
                                  },
                                ),
                            ],
                          )
                        ],
                      ),
                    if (editView)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Additional Instructions',
                            style: TextStyle(
                              color: Color(0xff909090),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Quicksand",
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: 'add instruction',
                            onPressed: () {
                              setState(
                                () {
                                  showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AddInstruction(
                                              model: model,
                                              instrucion: instructions,
                                            );
                                          })
                                      //     .then(
                                      //   (val) {
                                      //     setState(
                                      //       () {
                                      //         if (val != null) {
                                      //           instructions.add(val);
                                      //         }
                                      //       },
                                      //     );
                                      //   },
                                      // )
                                      ;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    SizedBox(
                      height:
                          20, //http://www.edamam.com/ontologies/edamam.owl#recipe_0b0103f67d752e4681d3c3458aa96f5a
                    ),
                    Text(
                      'Versions',
                      style: TextStyle(
                        color: Color(0xff909090),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Quicksand",
                      ),
                    ),
                    if (model.subs.isNotEmpty)
                      SubsScrooll(
                        recipeWidgets: recipeWidgets,
                      ),
                    //scroll view here!!
                    if (editView)
                      TextButton.icon(
                        onPressed: () {
                          print('model.subs -  ${model.subs}');
                          model.addSub(added, removedIngredients, instructions);
                          model.addToFB({});
                          setState(() {
                            added = [];
                            removedIngredients = [];
                            instructions = [];
                            editView = false;
                          });
                        },
                        icon: Icon(Icons.save, size: 30),
                        label: Text("SUBMIT"),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            label: 'Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Faivorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            _selectedIndex == 1 ? Colors.red : Colors.purple, //amber[800],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              _launchURL(url);
              // print('0 $index');
              break;
            case 1:
              if (UID == "0") {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Denied!'),
                    content: const Text('you need to register to do this..'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
              // print('1 $index');
              break;
            case 2:
              // print('2 $index');
              if (UID == "0") {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Denied!'),
                    content: const Text('you need to register to do this..'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                setState(
                  () {
                    editView = !editView;
                    sub = SubModel();
                  },
                );
              }
              break;
          }
        },
      ),
    );
  }

  Future<List<ingrident>> fetchIngredients(
      String query, List<ingrident> ingredientComp) async {
    String applicationId = "2051cf6b",
        applicationKey = "23b5c49d42ef07d39fb68e1b6e04bf42";
    String queryUrl =
        "https://api.edamam.com/auto-complete?app_id=1e2b1681&app_key=47e224016bc268ada433484688f019cf&q=$query";
    // 'https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey';
    final response = await http.get(Uri.parse(queryUrl));

    if (response.statusCode == 200) {
      List<String> jsonData = jsonDecode(response.body).cast<String>();
      int i = 0;
      jsonData.forEach(
        (ingredient) {
          ingredientComp.add(ingrident(
            id: ++i,
            name: ingredient,
          ));
        },
      );

      return ingredientComp;
    } else {
      throw Exception(
          'Failed to load ingredients. response statusCode = ${response.statusCode}');
    }
  }
}

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final RecipeModel model;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final UID = routeArgs['UID'];
    return Expanded(
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
                      builder: (BuildContext context) => RateRecipe(),
                    );
                  },
                ),
                CircleButton(
                  color: HexColor('##785ac7'),
                  icon: Icons.keyboard_arrow_left,
                  callback: () => {
                    Navigator.of(context).pushNamed(
                      MainScreen.idScreen,
                      arguments: {'UID': UID},
                    ),
                  },
                ),
              ],
            ),
          ),
          //TODO Need to figure out how to do overlapping oversized photos so we can follow the design
          Stack(
            //            overflow: Overflow.clip,
            // children: <Widget>[
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  right: 25.0,
                ),
                child: Center(
                  child: CircleNetworkImage(
                    imageURL: model.image,
                    radius: 250.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ingrident {
  final int id;
  final String name;

  ingrident({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    String data = '''
    id: $id,
    name: $name,
    ''';
    return '{\n$data}';
  }
}

class AddIngredient extends StatefulWidget {
  AddIngredient({
    Key? key,
    required this.model,
    required this.options,
  }) : super(key: key);
  final RecipeModel model;
  List<ingrident> options;

  @override
  State<AddIngredient> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  TextEditingController txtController = TextEditingController();
  bool autoComplete = true;
  List<ingrident> selected = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Add Ingredient'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              MultiSelectBottomSheetField(
                initialChildSize: 0.4,
                listType: MultiSelectListType.CHIP,
                searchable: true,
                buttonText: Text("Choose ingredient"),
                title: Text("Ingredients"),
                items: widget.options
                    .map((ingredient) =>
                        MultiSelectItem<ingrident>(ingredient, ingredient.name))
                    .toList(),
                onConfirm: (values) {
                  widget.options.removeWhere((e) => !(values.indexOf(e) >= 0));
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      selected.remove(value);
                    });
                  },
                ),
              ),
              (selected == null || selected.isEmpty)
                  ? Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "None selected",
                        style: TextStyle(color: Colors.black54),
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
      actions: [
        RaisedButton(
            child: Text("Add"),
            onPressed: () {
              List<String> ingredientNames = [];
              for (ingrident element in selected) {
                ingredientNames.add(element.name);
              }
              // widget.model.addSubs(ingredientNames);
              for (var e in selected) {
                print(e.name); //
                // if (!(widget.options.indexOf(e) >= 0)) {
                //   widget.options.remove(e);
                // }
              }
              widget.options = selected;
              Navigator.pop(context);
            })
      ],
    );
  }
}

class AddInstruction extends StatelessWidget {
  AddInstruction({Key? key, required this.model, required this.instrucion})
      : super(key: key);
  RecipeModel model;
  List<String> instrucion;
  TextEditingController txtController = TextEditingController();
  // final String name;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Add Instruction!'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: txtController,
                decoration: InputDecoration(
                  labelText: 'Instruction',
                  icon: Icon(Icons.account_box),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        RaisedButton(
          child: Text("Add"),
          onPressed: () {
            if (txtController.text.isNotEmpty) {
              instrucion.add(txtController.text);
            }
            Navigator.pop(context, txtController.text);
          },
        ),
      ],
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class StepEntry extends StatefulWidget {
  final String text;
  final bool initialStep;
  final bool edit;
  List<String> removedList = [];
  StepEntry(
      {required this.text,
      this.initialStep: false,
      required this.edit,
      required this.removedList});

  @override
  State<StepEntry> createState() => _StepEntryState();
}

class _StepEntryState extends State<StepEntry> {
  bool removed = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 25,
        left: 10.0,
        top: 0.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     width: 5.0,
              //     height: initialStep ? 0 : 40,
              //     decoration: BoxDecoration(
              //       color: HexColor('#F9AF9C'),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 69,
                child: SizedBox(
                  height: 10.0,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              widget.edit
                  ? IconButton(
                      icon: removed
                          ? const Icon(Icons.add)
                          : const Icon(Icons.cancel),
                      tooltip: 'delete instruction',
                      onPressed: () {
                        setState(() {
                          removed = !removed;
                          if (removed) {
                            widget.removedList.add(widget.text);
                          } else {
                            widget.removedList.remove(widget.text);
                          }
                        });
                      },
                    )
                  : Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: BoxDecoration(
                        color: HexColor('##785ac7'),
                        shape: BoxShape.rectangle,
                      ),
                    ),
              SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: Text(
                  widget.text,
                  style: removed ? deletedStyle : kIngredientsNameStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SubsScrooll extends StatelessWidget {
  SubsScrooll({Key? key, required this.recipeWidgets}) : super(key: key);
  final List<SubView> recipeWidgets;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: recipeWidgets,
      ),
    );
  }
}
