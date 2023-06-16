import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word/main.dart';
import 'package:word/screens/wordsearchpage.dart';

class HomePage extends StatelessWidget {
  final TextEditingController rowsController = TextEditingController();
  final TextEditingController colsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _createGrid(BuildContext context) {
    final int numRows = int.tryParse(rowsController.text) ?? 0;
    final int numCols = int.tryParse(colsController.text) ?? 0;

    store.setNumRows(numRows);
    store.setNumCols(numCols);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MatrixPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          title: const Text('Create Grid')),
      body: Container(
        color: Colors.grey[200],
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height/20,
                    ),
                    TextFormField(
                      controller: rowsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Number of rows',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp(r'^[3-7]$')),
                      // ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter no of rows';
                        }

                        int? rows = int.tryParse(value);
                        if (rows == null || rows < 3 || rows > 7) {
                          return 'Please enter a number between 3 and 7';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/25,
                    ),
                    TextFormField(
                      controller: colsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Number of Columns',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp(r'^[3-7]$')),
                      // ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter no of columns';
                        }
                        int? rows = int.tryParse(value);
                        if (rows == null || rows < 3 || rows > 7) {
                          return 'Please enter a number between 3 and 7';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/20,
                    ),
                    ElevatedButton(
                      onPressed: () {

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _createGrid(context);
                        }
                      },
                      child: Text('Create Grid'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey, // Change the background color here
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MatrixPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<List<TextEditingController>> controllers =
    List.generate(store.numRows, (_) => List.generate(store.numCols, (_) => TextEditingController()));

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          title: const Text('Matrix Grid')),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: store.numCols,
                    padding: EdgeInsets.all(8.0),
                    childAspectRatio: 1.0,
                    children: List.generate(store.numRows * store.numCols, (index) {
                      final row = index ~/ store.numCols;
                      final col = index % store.numCols;
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.yellow,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 4,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),

                          child: TextFormField(
                            controller: controllers[row][col],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none, // Remove the underline
                                borderRadius: BorderRadius.zero,
                              ),
                              counterText: '',
                            ),
                          ),

                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage(controllers)),
                      );
                    },
                    child: Text('Go to Search Page',),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Change the background color here
                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  final List<List<TextEditingController>> controllers;

  SearchPage(this.controllers);

  void _searchWord(BuildContext context) {
    final List<String> letters = [];

    for (final row in controllers) {
      for (final controller in row) {
        letters.add(controller.text);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WordSearchPage(letters)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          title: const Text('Word Search')),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: store.numCols,
                    padding: EdgeInsets.all(8.0),
                    children: List.generate(store.numRows * store.numCols, (index) {
                      final row = index ~/ store.numCols;
                      final col = index % store.numCols;
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.yellow,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 4,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: controllers[row][col],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none, // Remove the underline
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _searchWord(context);
                    },
                    child: Text('Search Word',),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey, // Change the background color here
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}