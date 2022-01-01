// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:modolar_recipe/Widgets/recipes.dart';

Future<Map<String, dynamic>> getRecipes(String query) async {
  String applicationId = "2051cf6b",
      applicationKey = "23b5c49d42ef07d39fb68e1b6e04bf42",
      queryUrl =
          'https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey';
  final response = await http.get(Uri.parse(queryUrl));

  Map<String, dynamic> jsonData = {};

  if (response.statusCode == 200) {
    jsonData = jsonDecode(response.body);
  }
  return jsonData;
}

addRecipes(Map<String, dynamic> recipe) {
  CollectionReference collection =
      FirebaseFirestore.instance.collection("recipes");

  var formatRecipe = format(recipe);
  String recID = recipe['uri'].split("#")[1];
  collection.firestore.collection('wow').add(formatRecipe);

  collection
      .doc(recID)
      .set(recipe)
      .then((value) => print('recipe $recID Added'))
      .catchError((error) => print('Add failed: $error'));
}

dynamic format(dynamic doc) {
  doc['uri'] = stringFormat(doc['uri']);
  doc['label'] = stringFormat(doc['label']);
  doc['image'] = stringFormat(doc['image']);
  doc['source'] = stringFormat(doc['source']);
  doc['url'] = stringFormat(doc['url']);
  doc['calories'] = numFormat(doc['calories']);
  doc['totalTime'] = numFormat(doc['totalTime']);
  doc['dietLabels'] = ListFormat(doc['dietLabels']);
  doc['healthLabels'] = ListFormat(doc['healthLabels']);
  doc['cautions'] = ListFormat(doc['cautions']);
  doc['cuisineType'] = ListFormat(doc['cuisineType']);
  doc['mealType'] = ListFormat(doc['mealType']);
  doc['dishType'] = ListFormat(doc['dishType']);
  doc['instructions'] = ListFormat(doc['instructions']);
  return doc;
}
