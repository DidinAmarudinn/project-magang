import 'package:flutter/material.dart';
import 'package:nabung_beramal/screens/search_result.dart';

class DataSearch extends SearchDelegate<String> {
  DataSearch({String hintText = "Cari berdasarkan alamat", this.email})
      : super(
            searchFieldLabel: hintText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search);
  final List email;

  final recentCities = [
    "jakarta",
    "bandung",
  ];
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.grey[50],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for appbar
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            if (query == "") {
              close(context, null);
            } else {
              query = "";
            }
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //icon leading on appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
          color: Colors.black,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //search result
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searchs for something
    final suggestionList = query.isEmpty
        ? recentCities
        : email.where((element) => element.contains(query)).toList();
    return suggestionList.length == 0
        ? Container(
            height: 70,
            padding: EdgeInsets.all(12),
            child: Center(child: Text("alamat tidak ditemukan")))
        : ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResult(suggestionList[index]),
                  ),
                );
              },
              child: ListTile(
                title: RichText(
                    text: TextSpan(
                        children:
                            highlightOccurrences(suggestionList[index], query),
                        style: TextStyle(color: Colors.black54, fontSize: 16))),
              ),
            ),
          );
  }
}

List<TextSpan> highlightOccurrences(String source, String query) {
  if (query == null || query.isEmpty) {
    return [TextSpan(text: source)];
  }

  var matches = <Match>[];
  for (final token in query.trim().toLowerCase().split(' ')) {
    matches.addAll(token.allMatches(source.toLowerCase()));
  }

  if (matches.isEmpty) {
    return [TextSpan(text: source, style: TextStyle(color: Colors.black))];
  }
  matches.sort((a, b) => a.start.compareTo(b.start));

  int lastMatchEnd = 0;
  final List<TextSpan> children = [];
  for (final match in matches) {
    if (match.end <= lastMatchEnd) {
      // already matched -> ignore
    } else if (match.start <= lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.end),
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
      ));
    } else if (match.start > lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.start),
      ));

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
      ));
    }

    if (lastMatchEnd < match.end) {
      lastMatchEnd = match.end;
    }
  }

  if (lastMatchEnd < source.length) {
    children.add(TextSpan(
      text: source.substring(lastMatchEnd, source.length),
    ));
  }

  return children;
}
