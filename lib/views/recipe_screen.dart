// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_be_immutable, deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:modolar_recipe/Styles/constants.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:modolar_recipe/Views/main_screen.dart';
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
      ApplicationKey = '47e224016bc268ada433484688f019cf',
      url = '';
  SubModel sub = SubModel();
  List<String> added = [],
      removedInstructions = [],
      removedIngredients = [],
      newIngredientNames = [],
      instructions = [];

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    RecipeModel model = routeArgs['Model'];
    final UID = routeArgs['UID'];
    List<Ingrident> selected = [];
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
    List<Ingrident> ingredientComp = [];
    List<SubView> recipeWidgets = [];

    for (var sub in model.subs) {
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
                                                                  Ingrident>(
                                                              ingredient,
                                                              ingredient.name))
                                                      .toList(),
                                                  onConfirm: (values) {
                                                    ingredientComp.removeWhere(
                                                        (e) => !(values
                                                            .contains(e)));
                                                    for (Ingrident element
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
                                            builder: (BuildContext context) {
                                              return AddInstruction(
                                                model: model,
                                                instrucion: instructions,
                                              );
                                            });
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
                                      });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
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
        selectedItemColor: _selectedIndex == 1 ? Colors.red : Colors.purple,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              _launchURL(url);
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
              break;
            case 2:
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

  Future<List<Ingrident>> fetchIngredients(
      String query, List<Ingrident> ingredientComp) async {
    String applicationId = "1e2b1681",
        applicationKey = "47e224016bc268ada433484688f019cf";
    String queryUrl =
        "https://api.edamam.com/auto-complete?app_id=$applicationId&app_key=$applicationKey&q=$query";
    final response = await http.get(Uri.parse(queryUrl));

    if (response.statusCode == 200) {
      List<String> jsonData = jsonDecode(response.body).cast<String>();
      int i = 0;
      for (var ingredient in jsonData) {
        ingredientComp.add(Ingrident(
          id: ++i,
          name: ingredient,
        ));
      }

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
          Stack(
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

class Ingrident {
  final int id;
  final String name;

  Ingrident({
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
  List<Ingrident> options;

  @override
  State<AddIngredient> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  TextEditingController txtController = TextEditingController();
  bool autoComplete = true;
  List<Ingrident> selected = [];
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
                        MultiSelectItem<Ingrident>(ingredient, ingredient.name))
                    .toList(),
                onConfirm: (values) {
                  widget.options.removeWhere((e) => !(values.contains(e)));
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      selected.remove(value);
                    });
                  },
                ),
              ),
              (selected.isEmpty)
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
              for (Ingrident element in selected) {
                ingredientNames.add(element.name);
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
      {Key? key,
      required this.text,
      this.initialStep = false,
      required this.edit,
      required this.removedList})
      : super(key: key);

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
  const SubsScrooll({Key? key, required this.recipeWidgets}) : super(key: key);
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
