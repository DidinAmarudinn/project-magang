import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/helper/db_harian.dart';
import 'package:nabung_beramal/screens/beli_celengan.dart';
import 'package:nabung_beramal/screens/tambah_tabungan.dart';
import 'package:nabung_beramal/widgets/donasi_container.dart';
import 'package:nabung_beramal/widgets/list_tabungan.dart';
import 'package:nabung_beramal/widgets/today_saved.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db = DbTabHarain();
  var dbc = DbCelengan();

  Future<List<CelenganModel>> future;
  int _total = 0;
  List priceList;
  var now = DateTime.now();
  void _calcTotal() async {
    var result = (await db.calculateTotalAll()).length > 0
        ? (await db.calculateTotalAll())[0]['total']
        : 0;
    print(result);
    setState(() {
      _total = result;
    });
  }

  void change() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _calcTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 50),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BeliCelengan()));
                    },
                    child: Image.asset(
                      "images/outline_shop.png",
                      scale: 1,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Rp",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        _total != null
                            ? NumberFormat.currency(
                                    locale: 'id', symbol: '', decimalDigits: 0)
                                .format(_total)
                                .toString()
                            : "0",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Total uang tabungan",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              TodaySaved(),
              SizedBox(
                height: 20,
              ),
              ListTabungan(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TambahTabungan(null, true)));
              }, future),
              SizedBox(
                height: 16,
              ),
              DonasiContaniner()
            ],
          )
        ],
      ),
    );
  }
}
