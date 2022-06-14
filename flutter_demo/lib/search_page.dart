import 'package:flutter/material.dart';
import 'constants.dart';

class MySearchDelegate extends SearchDelegate {
  List<String> getItems() {
    List<String> searchResults = [
      'Book',
      'Pen',
      'Paper',
      'Calculator',
      'Chair',
      'Table'
    ];
    return searchResults;
  }

  //Returns a list in alphabetic order
  //Depends on the query
  List<String> getSearchResults() {
    //List all matches
    List<String> searchResults = getItems().where((searchResults) {
      final result = searchResults.toLowerCase().trim();
      final input = query.toLowerCase().trim();

      return result.contains(input);
    }).toList();

    //Sort in alphabetic order
    searchResults.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    return searchResults;
  }

  //Clear the query or exit search
  void clear(BuildContext context) {
    if (query.isEmpty) {
      close(context, null);
    } else {
      query = '';
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          clear(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> searchResults = getSearchResults();

    var thisItem =
        searchResults.contains(query.trim()) ? query : 'Item does not exist';
    final itemDescription = searchResults.contains(query.trim())
        ? 'This is the item description'
        : '';
    final itemLocation =
        searchResults.contains(query.trim()) ? 'This is the item location' : '';

    if (query.trim() == '') thisItem = '';

    return Center(
      child: Column(
        children: [
          const SizedBox(height: firstBoxHeight),
          Text(
            thisItem,
            style: const TextStyle(fontSize: firstFontSize),
          ),
          const SizedBox(height: secondBoxHeight),
          Text(
            itemDescription,
            style: const TextStyle(fontSize: secondFontSize),
          ),
          const SizedBox(height: thirdBoxHeight),
          Text(
            itemLocation,
            style: const TextStyle(fontSize: secondFontSize),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    List<String> searchResults = getSearchResults();

    return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: ((context, index) {
          final suggestion = searchResults[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        }));
  }
}
