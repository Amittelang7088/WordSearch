import 'package:flutter/material.dart';
import 'package:word/main.dart';
import 'package:word/screens/homescreen.dart';

class WordSearchPage extends StatefulWidget {
  final List<String> letters;

  WordSearchPage(this.letters);

  @override
  _WordSearchPageState createState() => _WordSearchPageState();
}

class _WordSearchPageState extends State<WordSearchPage> {
  List<Map<String, dynamic>> searchWordIndices = [];
  final TextEditingController searchController = TextEditingController();

  List<String> searchWords = [];

  void _searchWord() {
    final String searchWord = searchController.text.toLowerCase();

    // Clear previous search results
    searchWords.clear();
    searchWordIndices.clear();

    final int numRows = store.numRows;
    final int numCols = store.numCols;

    // Search horizontally
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col <= numCols - searchWord.length; col++) {
        String word = '';
        int startIndex = -1;
        int endIndex = -1;
        for (int i = 0; i < searchWord.length; i++) {
          final char = widget.letters[row * numCols + col + i];
          word += char;
        }
        if (word.toLowerCase() == searchWord) {
          startIndex = col;
          endIndex = col + searchWord.length - 1;
          searchWords.add(word);
          searchWordIndices.add({
            'startIndex': row * numCols + startIndex,
            'endIndex': row * numCols + endIndex,
          });
        }
      }
    }

    // Search vertically
    for (int col = 0; col < numCols; col++) {
      for (int row = 0; row <= numRows - searchWord.length; row++) {
        String word = '';
        int startIndex = -1;
        int endIndex = -1;
        for (int i = 0; i < searchWord.length; i++) {
          final char = widget.letters[(row + i) * numCols + col];
          word += char;
        }
        if (word.toLowerCase() == searchWord) {
          startIndex = row * numCols + col;
          endIndex = (row + searchWord.length - 1) * numCols + col;
          searchWords.add(word);
          searchWordIndices.add({
            'startIndex': startIndex,
            'endIndex': endIndex,
          });
        }
      }
    }

    // Search diagonally (top-left to bottom-right)
    for (int row = 0; row <= numRows - searchWord.length; row++) {
      for (int col = 0; col <= numCols - searchWord.length; col++) {
        String word = '';
        int startIndex = -1;
        int endIndex = -1;
        for (int i = 0; i < searchWord.length; i++) {
          final char = widget.letters[(row + i) * numCols + col + i];
          word += char;
        }
        if (word.toLowerCase() == searchWord) {
          startIndex = row * numCols + col;
          endIndex = (row + searchWord.length - 1) * numCols + col + searchWord.length - 1;
          searchWords.add(word);
          searchWordIndices.add({
            'startIndex': startIndex,
            'endIndex': endIndex,
          });
        }
      }
    }

    // Search diagonally (bottom-left to top-right)
    for (int row = searchWord.length - 1; row < numRows; row++) {
      for (int col = 0; col <= numCols - searchWord.length; col++) {
        String word = '';
        int startIndex = -1;
        int endIndex = -1;
        for (int i = 0; i < searchWord.length; i++) {
          final char = widget.letters[(row - i) * numCols + col + i];
          word += char;
        }
        if (word.toLowerCase() == searchWord) {
          startIndex = row * numCols + col;
          endIndex = (row - searchWord.length + 1) * numCols + col + searchWord.length - 1;
          searchWords.add(word);
          searchWordIndices.add({
            'startIndex': startIndex,
            'endIndex': endIndex,
          });
        }
      }
    }
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
    setState(() {}); // Trigger a rebuild after searching
    print((int.parse("${searchWordIndices[0]['startIndex']}") ~/ store.numCols));
    if(searchWordIndices[0]['startIndex'] % store.numCols == searchWordIndices[0]['endIndex'] % store.numCols){
      for(int i=searchWordIndices[0]['startIndex'];i<=searchWordIndices[0]['endIndex'];i+=store.numCols){
        searchWordIndices.add({
          'index' : i,
        });
      }
    }
    else if(searchWordIndices[0]['startIndex'] ~/ store.numCols == searchWordIndices[0]['endIndex'] ~/ store.numCols){
      for(int i=searchWordIndices[0]['startIndex'];i<=searchWordIndices[0]['endIndex'];i++){
        searchWordIndices.add({
          'index' : i,
        });
      }
    }else{
      for(int i=searchWordIndices[0]['startIndex'];i<=searchWordIndices[0]['endIndex'];i+=(store.numCols+1)){
        searchWordIndices.add({
          'index' : i,
        });
      }
    }
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Word',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder( // Apply border
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _searchWord,
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/25,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: store.numCols,
                    padding: EdgeInsets.all(8.0),
                    childAspectRatio: 1.0,
                    children: List.generate(store.numRows * store.numCols, (index) {
                      final row = index ~/ store.numCols;
                      final col = index % store.numCols;
                      final letter = widget.letters[index];

                      // Check if the letter is within the range of the searched word
                      final bool isMatch = searchWordIndices.any((wordIndex) =>
                      row * store.numCols + col == wordIndex['index']);

                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: isMatch ? Colors.red : Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 4,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(letter,style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Change the background color here
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}