import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/tabungan_harian_model.dart';
import 'package:nabung_beramal/helper/db_harian.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AllRiwayatHarian extends StatefulWidget {
  final int id;
  AllRiwayatHarian(this.id);
  @override
  _AllRiwayatHarianState createState() => _AllRiwayatHarianState();
}

class _AllRiwayatHarianState extends State<AllRiwayatHarian> {
  Future<List<TabunganHarainModel>> future;

  var db = DbTabHarain();
  void updateList() {
    setState(() {
      future = db.getList(widget.id);
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
          "Riwayat Tabungan Harian",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<TabunganHarainModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) print("error");
          var data = snapshot.data;
          return snapshot.hasData && data.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TimelineTile(
                      alignment: TimelineAlign.left,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 15,
                        color: listColors[data[index].color],
                        indicatorY: 0.1,
                      ),
                      topLineStyle: LineStyle(
                        color: Colors.white,
                      ),
                      bottomLineStyle: LineStyle(
                        color: Colors.white,
                      ),
                      rightChild: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                data[index].desk,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data[index].nominal}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${data[index].dateTime}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/mulainabung.png",
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Ayo mulai sisihkan uang",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Agar impianmu cepat terwujud",
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
