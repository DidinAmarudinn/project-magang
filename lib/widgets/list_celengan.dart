import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/helper/db_harian.dart';
import 'package:nabung_beramal/screens/detail_tabungan.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ListCelengan extends StatefulWidget {
  @override
  _ListCelenganState createState() => _ListCelenganState();
}

class _ListCelenganState extends State<ListCelengan> {
  var val;
  double percent;
  Future<List<CelenganModel>> future;
  var now = DateTime.now();
  var db = DbCelengan();
  var dbH = DbTabHarain();
  void updateList() {
    setState(() {
      future = db.getList();
      print('dcsd');
    });
  }

  void _calcTotalAll() async {
    String dateNow = "${now.day}-${now.month}-${now.year}";
    var result = (await dbH.calculateTotal(dateNow)).length > 0
        ? (await dbH.calculateTotal(dateNow))[0]['total']
        : 0;
    print(result);
  }

  void _calcTotal() async {
    var result = (await dbH.calculateTotalAll()).length > 0
        ? (await dbH.calculateTotalAll())[0]['total']
        : 0;
    print(result);
  }

  @override
  void initState() {
    super.initState();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: FutureBuilder<List<CelenganModel>>(
        future: future,
        builder: (BuildContext context, snapshot) {
          var data = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done) {
            return Text('loading');
          }
          print(snapshot.hasData);
          return snapshot.hasData && snapshot.data.length > 0
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("lama target" + data[index].lamaTarget.toString());
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailTabungan(data[index]),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            updateList();
                            _calcTotal();
                            _calcTotalAll();
                          });
                        }
                        print(data[index].id);
                      },
                      child: Container(
                        margin: index == 0
                            ? EdgeInsets.only(left: 0)
                            : EdgeInsets.only(left: 12),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        height: 150,
                        width: MediaQuery.of(context).size.width * 0.55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.06),
                              offset: Offset(0, 4),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          data[index].namaTarget,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 2,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "dibuat ${data[index].createDate.substring(0, 9)}",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: ColorsSchema().primaryColors,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: Text(
                                            data[index].namaKategori,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Switch(
                                            activeColor:
                                                ColorsSchema().primaryColors,
                                            inactiveTrackColor: Colors.grey,
                                            value: val =
                                                data[index].pengingat == 1
                                                    ? true
                                                    : false,
                                            onChanged: (bool value) {
                                              setState(() {
                                                val = value == true ? 1 : 0;
                                              });
                                            }),
                                        Text(
                                          "Pengingat",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              "Rp. " +
                                  NumberFormat.currency(
                                          locale: 'id',
                                          symbol: '',
                                          decimalDigits: 0)
                                      .format(data[index].nominalTarget /
                                          data[index].lamaTarget)
                                      .toString() +
                                  "/hari",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: LinearPercentIndicator(
                                    linearGradient: LinearGradient(colors: [
                                      Color(0xFF6448FE),
                                      Color(0xFF5FC6FF),
                                    ]),
                                    alignment: MainAxisAlignment.center,
                                    lineHeight: 20.0,
                                    percent: data[index].progress != null
                                        ? (data[index].progress /
                                            data[index].nominalTarget)
                                        : 0.0,
                                    animationDuration: 2500,
                                    animation: true,
                                    center: data[index].progress != null
                                        ? Text(
                                            ((data[index].progress /
                                                            data[index]
                                                                .nominalTarget) *
                                                        100)
                                                    .toString()
                                                    .substring(
                                                        0,
                                                        data[index].progress !=
                                                                0
                                                            ? 3
                                                            : 0) +
                                                " %",
                                            style: new TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          )
                                        : Text(
                                            "0",
                                            style: new TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp ',
                                                  decimalDigits: 0)
                                              .format(data[index].progress) +
                                          " dari " +
                                          NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp',
                                                  decimalDigits: 0)
                                              .format(
                                                  data[index].nominalTarget),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/not_found_tbg.png",
                        width: 200,
                        height: 140,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Belum ada tabungan",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Ayo mulai menabung\ndan wujudkan keinginan-mu",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
