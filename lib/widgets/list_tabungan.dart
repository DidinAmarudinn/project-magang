import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/screens/all_celengan.dart';
import 'package:nabung_beramal/widgets/list_celengan.dart';

class ListTabungan extends StatefulWidget {
  final Function route;
  final Future<List<CelenganModel>> future;

  ListTabungan(this.route, this.future);

  @override
  _ListTabunganState createState() => _ListTabunganState();
}

class _ListTabunganState extends State<ListTabungan> {
  Future<List<CelenganModel>> future;
  var db = DbCelengan();
  updateList() {
    setState(() {
      future = db.getList();
      print('dcsd');
    });
  }

  @override
  void initState() {
    super.initState();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Daftar Tabungan",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListAllCelengan()));
            },
            child: Text(
              "Lihat Semua",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 16,
      ),
      DottedBorder(
        strokeWidth: 2,
        dashPattern: [5, 4],
        color: ColorsSchema().secondColors,
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FlatButton(
            splashColor: ColorsSchema().primaryColors,
            padding: EdgeInsets.symmetric(vertical: 10),
            onPressed: widget.route,
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    "images/add_walet.png",
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Buat Tabungan",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      ListCelengan()
    ]);
  }
}
