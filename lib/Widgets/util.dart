import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modolar_recipe/Widgets/ingredients.dart';
import 'dart:math';

import 'package:modolar_recipe/Widgets/loading.dart';
import 'package:modolar_recipe/views/profile_screen.dart';
import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/views/login.dart';
import 'package:modolar_recipe/views/add_recipe.dart';
import 'package:modolar_recipe/Widgets/recipes.dart';
import 'package:modolar_recipe/Widgets/headers.dart';

addRecipe(Map<String, dynamic> recipe) {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("recipes");
    // DocumentReference doc = collection.document();
    var formatRecipe = format(recipe);
    String recID = recipe['uri'].split("#")[1];
    collection.firestore.collection('wow').add(formatRecipe);

    collection
        .doc(recID)
        .set(recipe)
        .then((value) => print('recipe $recID Added'))
        .catchError((error) => print('Add failed: $error'));
    // recipe['ingredients'] = toIngredientList(recipe['ingredients']);
    // .add({recID: recipe});
    // collection.add({recID: recID});
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
    // doc['ingredients'] = toIngredientList(doc['ingredients']);
    return doc;
  }