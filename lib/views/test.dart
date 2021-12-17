import 'dart:core';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new test(),
    );
  }
}

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  final String title = "fd";
  static const String idScreen = "test";

  @override
  _testState createState() => new _testState();
}

class _testState extends State<test> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> children =
        new List.generate(count, (int i) => new InputWidget(i));

    return new Scaffold(
        appBar: new AppBar(title: new Text(widget.title)),
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () {
            setState(() {
              count = count + 1;
            });
          },
        ));
  }
}

class InputWidget extends StatelessWidget {
  final int index;

  InputWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return new Text("InputWidget: " + index.toString());
  }
}
