import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/dummyrelawan.dart';
import 'package:nabung_beramal/screens/detail_donasi.dart';

class Relawan extends StatefulWidget {
  final DummyRelawanModel list;
  Relawan(this.list);
  @override
  _RelawanState createState() => _RelawanState();
}

class _RelawanState extends State<Relawan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.list.data.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.list.data[index].firstName +
                                    " " +
                                    widget.list.data[index].lastName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.list.data[index].email,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Rek." + "033333333312",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailDonasi()));
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                                border: Border.all(
                                    color: ColorsSchema().primaryColors,
                                    width: 0.8)),
                            child: Center(
                              child: Text(
                                "Donasi",
                                style: TextStyle(
                                    color: ColorsSchema().primaryColors),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      color: Colors.black38,
                      height: 1,
                      thickness: 0.5,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
