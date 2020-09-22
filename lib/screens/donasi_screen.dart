import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/dummyrelawan.dart';
import 'package:nabung_beramal/screens/detail_donasi.dart';
import 'package:nabung_beramal/widgets/relawan.dart';
import 'package:nabung_beramal/widgets/search_delegete.dart';

class DonasiScreen extends StatefulWidget {
  @override
  _DonasiScreenState createState() => _DonasiScreenState();
}

class _DonasiScreenState extends State<DonasiScreen> {
  DummyRelawanModel dummyRelawanModel;
  List<String> nama = [];
  Future<void> getListRelwanDummy() async {
    var url = "https://reqres.in/api/users?page=2";
    var res = await http.get(url);
    var decodeJson = jsonDecode(res.body);
    dummyRelawanModel = DummyRelawanModel.fromJson(decodeJson);
    for (int i = 0; i < dummyRelawanModel.data.length; i++) {
      nama.add(dummyRelawanModel.data[i].email);
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void donasiAllret(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      contentPadding: EdgeInsets.all(24),
      backgroundColor: Colors.white,
      content: Text(
        "Ayo beramal, agar allah memudahkan semua keinginan kita, semua relawan penyalur sudah melalui tahap seleksi dari tim YukMangan",
        style: TextStyle(
            height: 1.5,
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w400),
      ),
      actionsPadding: EdgeInsets.only(right: 8),
      actions: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: ColorsSchema().primaryColors,
          onPressed: () {
            Navigator.pop(context, "saved");
          },
          child: Text("Tutup"),
        ),
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      donasiAllret(context);
    });
    getListRelwanDummy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Donasi",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch(email: nama));
              })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: dummyRelawanModel == null
              ? Colors.grey
              : ColorsSchema().primaryColors,
          onPressed: () {
            if (dummyRelawanModel == null) {
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailDonasi()));
            }
          },
          label: Text("Donasi")),
      body: dummyRelawanModel == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            child: Container(
                              height: 170,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorsSchema()
                                            .accentColors1
                                            .withOpacity(.06),
                                        blurRadius: 5,
                                        offset: Offset(0, 10))
                                  ],
                                  color: ColorsSchema().accentColors1,
                                  borderRadius: BorderRadius.circular(16)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16)),
                                child: Image.asset(
                                  "images/donation.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                        Flexible(
                            child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(16),
                                  topRight: Radius.circular(16))),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Terkumpul",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Rp ",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              symbol: "",
                                              decimalDigits: 0)
                                          .format(100000000)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Tersalurkan",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Rp ",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              symbol: "",
                                              decimalDigits: 0)
                                          .format(70000000)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Daftar Relawan Penyalur",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(child: Relawan(dummyRelawanModel))
                ],
              ),
            ),
    );
  }
}
