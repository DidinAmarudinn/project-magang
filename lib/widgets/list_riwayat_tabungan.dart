import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/tabungan_harian_model.dart';
import 'package:nabung_beramal/helper/db_harian.dart';
import 'package:nabung_beramal/screens/all_riwayat_tab_harian.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineTabungan extends StatefulWidget {
  final Future<List<TabunganHarainModel>> future;
  final int id;
  TimeLineTabungan(this.future, this.id);
  @override
  _TimeLineTabunganState createState() => _TimeLineTabunganState();
}

class _TimeLineTabunganState extends State<TimeLineTabungan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Riwayat Nabung",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllRiwayatHarian(widget.id)));
              },
              child: Text(
                "Lihat semua",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            )
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Expanded(
          child: Container(
            child: FutureBuilder<List<TabunganHarainModel>>(
              future: widget.future,
              builder: (context, snapshot) {
                if (snapshot.hasError) print("error");
                if (snapshot.connectionState != ConnectionState.done) {
                  return Text("Loading..");
                }
                var data = snapshot.data;
                return snapshot.hasData && data.length > 0
                    ? ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    : Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/mulainabung.png",
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.width * 0.4,
                                colorBlendMode: BlendMode.color,
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
                        ),
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
