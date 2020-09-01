import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/data/data_nominal_donasi.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';

class DetailDonasi extends StatefulWidget {
  @override
  _DetailDonasiState createState() => _DetailDonasiState();
}

class _DetailDonasiState extends State<DetailDonasi> {
  DbCelengan dbCelengan = DbCelengan();
  Future<List<CelenganModel>> _future;
  final cNominalDonasi = TextEditingController();
  var namaTabungan;
  bool show = false;
  var _valta = 0;

  void updateList() {
    setState(() {
      _future = dbCelengan.getList();
    });
  }

  bool loading = true;

  List<CelenganModel> list;

  getList() async {
    await _future.then((value) => list = value);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    updateList();
    getList();
  }

  var _value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Center(
                  child: Text(
                    "Ayo Beramal\nBantu Orang Disekitar Kita",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                "Nominal",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 12,
              ),
              Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 0,
                  children:
                      List<Widget>.generate(listDonasi.length, (int index) {
                    String chip = NumberFormat.currency(
                            locale: 'id', symbol: "", decimalDigits: 0)
                        .format(int.parse(listDonasi[index].nominal))
                        .toString();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        label: Text(
                          int.parse(listDonasi[index].nominal) == 0
                              ? "  Lainnya  "
                              : "Rp " + chip,
                          style: TextStyle(
                              color: _value == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selectedColor: ColorsSchema().primaryColors,
                        backgroundColor: Colors.white,
                        selected: _value == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = index;
                            cNominalDonasi.text =
                                int.parse(chip) == 0 ? "" : chip;
                            if (_value == 9) {
                              setState(() {
                                show = true;
                              });
                            } else {
                              setState(() {
                                show = false;
                              });
                            }
                          });
                        },
                      ),
                    );
                  })),
              show
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: TextField(
                          autofocus: true,
                          controller: cNominalDonasi,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "nominal donasi",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 12,
              ),
              Text(
                "Pilih Tabungan",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 12,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Wrap(
                      spacing: 0,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: List<Widget>.generate(
                        list.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              label: Text(
                                list[index].namaTarget,
                                style: TextStyle(
                                    color: _valta == index
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              selectedColor: ColorsSchema().primaryColors,
                              backgroundColor: Colors.white,
                              selected: _valta == index,
                              onSelected: (bool selected) {
                                setState(() {
                                  namaTabungan = list[index].namaTarget;
                                  _valta = index;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorsSchema().primaryColors,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () {
          setState(() {
            print("namaTabunga" + namaTabungan);
            print("nominal" + cNominalDonasi.text);
          });
        },
        label: Text(
          "Donasi",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
