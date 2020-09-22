import 'package:flutter/material.dart';
import 'package:nabung_beramal/widgets/relawan.dart';

class SearchResult extends StatefulWidget {
  final String result;
  SearchResult(this.result);
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                widget.result,
                style: TextStyle(color: Colors.black, fontSize: 18),
              )
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ));
  }
}
