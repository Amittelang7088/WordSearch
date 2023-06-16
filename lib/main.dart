import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:word/screens/homescreen.dart';

void main() {
  runApp(MyApp());
}

class GridStore {
  @observable
  int numRows = 0;

  @observable
  int numCols = 0;

  @action
  void setNumRows(int value) {
    numRows = value;
  }

  @action
  void setNumCols(int value) {
    numCols = value;
  }
}

final GridStore store = GridStore();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grid App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}









