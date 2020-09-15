import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/widgets/circle_progres.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Statistik extends StatefulWidget {
  final List<double> statistik;
  final int progress;
  final int target;
  Statistik(this.progress, this.target, this.statistik);
  @override
  _StatistikState createState() => _StatistikState();
}

class _StatistikState extends State<Statistik> {
  var data;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Text(
                      "Statistik",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.timeline,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              widget.statistik == null
                  ? Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Text("Belum ada chart")))
                  : Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Sparkline(
                        data: widget.statistik,
                        lineColor: ColorsSchema().primaryColors,
                        pointsMode: PointsMode.none,
                        lineWidth: 2,
                        fillMode: FillMode.below,
                        fillGradient: LinearGradient(
                            colors: [
                              ColorsSchema().accentColors1,
                              Colors.white
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                    ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 16),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            height: 80,
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
                  blurRadius: 6,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rp. " + widget.progress.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "dari Rp. ${widget.target}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                CustomPaint(
                  foregroundPainter:
                      CircleProgress(widget.target, widget.progress),
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Center(
                      child: Text(
                        widget.progress == 0
                            ? "0 %"
                            : ((widget.progress / widget.target) * 100)
                                    .toString()
                                    .substring(
                                        0, widget.progress != 0 ? 3 : 0) +
                                "%",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
