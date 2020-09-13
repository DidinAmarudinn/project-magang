import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/helper/db_harian.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  DbCelengan dbCelengan = DbCelengan();
  DbTabHarain dbHarian = DbTabHarain();
  void showFlushbarDelete(BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(10),
      borderRadius: 8,
      backgroundColor: ColorsSchema().primaryColors,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 3),
      title: "Celengan dan Tabungan",
      message: "berhasil dihapus",
    )..show(context);
  }

  void _confirmDelete() {
    AlertDialog alertDialog = AlertDialog(
      contentPadding: EdgeInsets.all(24),
      backgroundColor: Colors.white,
      content: Text(
        "Apakah anda yakin ?",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.grey,
          onPressed: () async {
            await dbCelengan.deleteAllData();
            await dbHarian.deleteAll();
            Navigator.pop(context);
            showFlushbarDelete(context);
          },
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
        RaisedButton(
          color: ColorsSchema().primaryColors,
          onPressed: () {
            Navigator.pop(context, "saved");
          },
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

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
        centerTitle: true,
        title: Text(
          "Pengaturan",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Center(
          child: Column(
            children: [
              Text(
                "Hapus semua celengan atau tabungan target yang telah anda buat",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  _confirmDelete();
                },
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                      color: ColorsSchema().primaryColors,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "Hapus",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
