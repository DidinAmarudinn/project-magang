import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/data/menu_content.dart';
import 'package:nabung_beramal/data/tabungan_harian_model.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/helper/db_harian.dart';
import 'package:nabung_beramal/screens/homepage.dart';
import 'package:nabung_beramal/screens/tambah_tabungan.dart';
import 'package:nabung_beramal/widgets/list_riwayat_tabungan.dart';
import 'package:nabung_beramal/widgets/statistik.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailTabungan extends StatefulWidget {
  final CelenganModel celenganModel;
  final int id;
  DetailTabungan(this.celenganModel, this.id);
  @override
  _DetailTabunganState createState() => _DetailTabunganState();
}

class _DetailTabunganState extends State<DetailTabungan> {
  TextEditingController cNominalHarian = TextEditingController();
  Future<List<TabunganHarainModel>> _future;
  Future<List<CelenganModel>> _futureCelengan;
  DbCelengan dbCelengan = DbCelengan();
  List<CelenganModel> list;
  CelenganModel cele;
  int progress;
  int validator;

  var boolDisable = false;

  var db = DbTabHarain();
  int random() {
    Random rnd;
    int min = 0;
    int max = 5;
    rnd = new Random();
    var d = min + rnd.nextInt(max - min);
    print(d);
    return d;
  }

  void loadNabung() {
    if (mounted)
      setState(() {
        _future = db.getList(widget.celenganModel.id);
      });
  }

  void getListById(int id) {
    setState(() {
      _futureCelengan = dbCelengan.getListById(id);
    });
  }

  void loadData() async {
    await _futureCelengan.then((value) => list = value);
    print(list[0].namaTarget);
  }

  int _totalProgress = 0;
  var now = DateTime.now();
  void saveData() async {
    await updateRecord();
    Navigator.pop(context);
  }

  void _calcTotal() async {
    var result = (await db
            .calculateTotalPerCelengan(widget.celenganModel.id))[0]['total'] ??
        0;
    setState(() {
      if (result >= widget.celenganModel.nominalTarget) {
        _totalProgress = widget.celenganModel.nominalTarget;
        print("total progress" + result.toString());
      } else {
        _totalProgress = result;
      }
    });
  }

  Future addRecordData() async {
    var db = DbTabHarain();
    String dateNow =
        "${now.day}-${now.month}-${now.year}, ${now.hour} : ${now.minute}";
    String dateNowTgl = "${now.day}-${now.month}-${now.year}";
    var dbtabHar = TabunganHarainModel(
        int.parse(cNominalHarian.text),
        cDeskHarian.text,
        dateNow,
        random(),
        widget.celenganModel.id,
        dateNowTgl);
    await db.saveData(dbtabHar);
    setState(() {
      _future = db.getList(widget.celenganModel.id);
      _futureCelengan = dbCelengan.getListById(widget.id);
      loadData();
    });
    print(dateNowTgl);
  }

  void updateList() async {
    setState(() {
      _future = db.getList(widget.celenganModel.id);
      print("d");
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    cDeskHarian.dispose();
    cNominalHarian.dispose();
    super.dispose();
  }

  void _delete(CelenganModel myNote) {
    var db = DbCelengan();
    db.deleteData(myNote);
  }

  void _deleteHarian() {
    var db = DbTabHarain();
    db.deleteHarain(widget.celenganModel.id);
  }

  void showFlushbar(BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(10),
      borderRadius: 8,
      backgroundColor: ColorsSchema().primaryColors,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 3),
      title: "form tidak boleh kosong",
      message: "mohon isi nominal dan deskripsi",
    )..show(context);
  }

  void showFlushbarDelete(BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(10),
      borderRadius: 8,
      backgroundColor: ColorsSchema().primaryColors,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 3),
      title: "Celengan dan Tabungan",
      message: "berhasil dihapus",
    )..show(context);
  }

  Future updateRecord() async {
    var db = DbCelengan();
    var dbCelengan = CelenganModel(
        widget.celenganModel.namaTarget,
        int.parse(widget.celenganModel.nominalTarget.toString()),
        widget.celenganModel.deskrpsi,
        widget.celenganModel.lamaTarget,
        widget.celenganModel.createDate,
        widget.celenganModel.namaKategori,
        _totalProgress == null
            ? int.parse(cNominalHarian.text) >= progres
                ? progres
                : int.parse(cNominalHarian.text)
            : _totalProgress + int.parse(cNominalHarian.text) >= progres
                ? progres
                : _totalProgress + int.parse(cNominalHarian.text),
        widget.celenganModel.indexKategori,
        widget.celenganModel.pengingat);
    dbCelengan.setId(widget.celenganModel.id);
    await db.upadteData(dbCelengan);
    addRecordData();
  }

  void aturPeningat() {}

  void _confirmDelete() {
    AlertDialog alertDialog = AlertDialog(
      contentPadding: EdgeInsets.all(24),
      backgroundColor: Colors.white,
      content: Text(
        "Apakah anda yakin ?",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.grey,
          onPressed: () async {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
            _delete(widget.celenganModel);
            _deleteHarian();
            showFlushbarDelete(context);
          },
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
        RaisedButton(
          color: ColorsSchema().primaryColors,
          onPressed: () {
            Navigator.pop(context, "saved");
          },
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  void _allret() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      insetPadding: EdgeInsets.all(0),
      backgroundColor: ColorsSchema().backgroundColors,
      content: Builder(
        builder: (context) {
          return Container(
            height: 120,
            child: Center(
              child: Column(
                children: [
                  Text("Mohon isi semua form"),
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                    color: ColorsSchema().primaryColors,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "tutup",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
    showDialog(context: context, child: alertDialog);
  }

  void _addTabunga() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: ColorsSchema().backgroundColors,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nominal"),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: TextField(
                  controller: cNominalHarian,
                  onChanged: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Masukan Nominal",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text("Deskripsi"),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: TextField(
                  controller: cDeskHarian,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Masukan Deskripsi",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: ColorsSchema().primaryColors,
          onPressed: () async {
            if (cNominalHarian.text.length == 0 &&
                cDeskHarian.text.length == 0) {
              setState(() {
                showFlushbar(context);
              });
            } else {
              setState(() {
                saveData();
                _future = db.getList(widget.celenganModel.id);
                _futureCelengan = dbCelengan.getList();
              });
            }
          },
          child: Text(
            "Simpan",
            style: TextStyle(color: Colors.white),
          ),
        ),
        RaisedButton(
          color: Colors.grey,
          onPressed: () async {
            setState(() {
              cNominalHarian.text = "";
              cDeskHarian.text = "";
            });
            Navigator.pop(context, "true");
          },
          child: Text(
            "Tutup",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  @override
  void initState() {
    super.initState();
    updateList();
    _calcTotal();

    loadNabung();
    getListById(widget.id);
    loadData();
    progres = widget.celenganModel.nominalTarget;
    print(widget.celenganModel.lamaTarget);
  }

  TextEditingController cDeskHarian = TextEditingController();

  int target;
  int progres;
  double getPercent() {
    return progres / target * 100;
  }

  String choice;
  void choiceAction(String choice) {
    print("worrk");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, "back");
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context, "back");
              }),
          elevation: 0,
          actions: [
            PopupMenuButton(
                onSelected: (String val) {
                  print(val);
                  if (val == "Update") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TambahTabungan(widget.celenganModel, false)));
                  } else if (val == "Delete") {
                    _confirmDelete();
                  } else {}
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (BuildContext context) {
                  return Contents.choices.map(
                    (String choice) {
                      return PopupMenuItem(child: Text(choice), value: choice);
                    },
                  ).toList();
                })
          ],
          backgroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton.extended(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: ColorsSchema().primaryColors,
            onPressed: () {
              _addTabunga();
              print("ss" + cNominalHarian.text.length.toString());
            },
            label: Text("Nabung")),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.celenganModel.namaTarget,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.celenganModel.deskrpsi,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  list != null
                      ? Statistik(list.length > 0 ? list[0].progress : 0,
                          list.length > 0 ? list[0].nominalTarget : 0)
                      : Center(child: CircularProgressIndicator())
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: Container(
                          child: TimeLineTabungan(
                              _future, widget.celenganModel.id)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
