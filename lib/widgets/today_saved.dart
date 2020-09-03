import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/helper/db_harian.dart';

class TodaySaved extends StatefulWidget {
  @override
  _TodaySavedState createState() => _TodaySavedState();
}

class _TodaySavedState extends State<TodaySaved> {
  var db = DbTabHarain();
  int _total = 0;
  List priceList;
  var now = DateTime.now();
  void _calcTotal() async {
    String dateNow = "${now.day}-${now.month}-${now.year}";
    var result = (await db.calculateTotal(dateNow)).length > 0
        ? (await db.calculateTotal(dateNow))[0]['total']
        : 0;
    print(result);
    setState(() {
      _total = result;
    });
  }

  Future<List<CelenganModel>> future;
  var dbc = DbCelengan();
  updateList() {
    setState(() {
      future = dbc.getList();
      print('dcsd');
    });
  }

  @override
  void initState() {
    super.initState();
    _calcTotal();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      height: 90,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorsSchema().primaryColors.withOpacity(.25),
            blurRadius: 12,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Rp.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(width: 6),
                      Text(
                        _total != null
                            ? NumberFormat.currency(
                                    locale: 'id', decimalDigits: 0, symbol: "")
                                .format(_total)
                                .toString()
                            : "0",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    "tersimpan hari ini",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
