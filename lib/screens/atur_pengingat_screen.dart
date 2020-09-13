import 'package:flutter/material.dart';

class AturPengingat extends StatefulWidget {
  @override
  _AturPengingatState createState() => _AturPengingatState();
}

class _AturPengingatState extends State<AturPengingat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
