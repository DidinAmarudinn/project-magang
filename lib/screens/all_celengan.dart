import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/screens/detail_tabungan.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ListAllCelengan extends StatefulWidget {
  @override
  _ListAllCelenganState createState() => _ListAllCelenganState();
}

class _ListAllCelenganState extends State<ListAllCelengan> {
  bool val = false;
  Future<List<CelenganModel>> future;
  var db = DbCelengan();
  void updateList() {
    setState(() {
      future = db.getList();
      print('d');
    });
  }

  @override
  void initState() {
    super.initState();
    updateList();
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
          "Semua Tabungan",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<CelenganModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) print("error");
          var data = snapshot.data;
          return snapshot.hasData && data.length > 0
              ? ListView.builder(
                  itemCount: data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailTabungan(data[index]),
                          ),
                        );
                        print(data[index].id);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        padding: EdgeInsets.all(16),
                        height: 180,
                        width: MediaQuery.of(context).size.width,
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
                              flex: 1,
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
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 2,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "dibuat ${data[index].createDate.substring(0, 9)}",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
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
                                            value: val,
                                            onChanged: (bool value) {
                                              setState(() {
                                                val = value;
                                              });
                                            }),
                                        Flexible(
                                          child: Container(
                                            child: Text(
                                              "Pengingat",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
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
                                  fontSize: 14,
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
                                                    .toString() +
                                                " %",
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white),
                                          )
                                        : Text(
                                            "0",
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white),
                                          ),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  NumberFormat.currency(
                                              locale: "id",
                                              symbol: "Rp",
                                              decimalDigits: 0)
                                          .format(data[index].progress)
                                          .toString() +
                                      " dari " +
                                      NumberFormat.currency(
                                              locale: "id",
                                              symbol: "Rp",
                                              decimalDigits: 0)
                                          .format(data[index].nominalTarget)
                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/not_found_tbg.png",
                          width: 240,
                          height: 200,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
