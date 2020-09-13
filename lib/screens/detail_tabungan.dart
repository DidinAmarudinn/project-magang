import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/data/menu_content.dart';
import 'package:nabung_beramal/data/tabungan_harian_model.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/helper/db_harian.dart';
import 'package:nabung_beramal/main.dart';
import 'package:nabung_beramal/screens/home_page.dart';
import 'package:nabung_beramal/screens/tambah_tabungan.dart';
import 'package:nabung_beramal/widgets/list_riwayat_tabungan.dart';
import 'package:nabung_beramal/widgets/statistik.dart';

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
  Future<List<int>> _futurelistData;
  DbCelengan dbCelengan = DbCelengan();
  List<CelenganModel> list;
  List<double> statistik = [];
  List<int> coba = [];
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
  }

  void getListNominal(int id) async {
    setState(() {
      _futurelistData = db.getAllNominalHarian(id);
    });
  }

  void loadDataStat() async {
    await _futurelistData.then((value) {
      setState(() {
        coba = value;
        print(coba.toString() + "ccccccccccc");
      });
    });
    setState(() {
      List<double> _list = coba.map((e) => e.toDouble()).toList();
      _list.insert(0, 0.0);
      statistik = _list;
      print(statistik);
    });
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
      _futurelistData = db.getAllNominalHarian(widget.id);
      loadDataStat();
      loadData();
    });
    print(dateNowTgl);
  }

  Future updatePengingat() async {
    var db = DbCelengan();
    var dbCelengan = CelenganModel(
        widget.celenganModel.namaTarget,
        int.parse(widget.celenganModel.nominalTarget.toString()),
        widget.celenganModel.deskrpsi,
        widget.celenganModel.lamaTarget,
        widget.celenganModel.createDate,
        widget.celenganModel.namaKategori,
        widget.celenganModel.progress,
        widget.celenganModel.indexKategori,
        widget.celenganModel.pengingat,
        _alarmTime.toString());
    dbCelengan.setId(widget.celenganModel.id);

    await db.upadteData(dbCelengan);
    print("updated pengingat");
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

  DateTime _alarmTime;
  String _alarmTimeString;
  void aturPengingat() async {
    _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
    showModalBottomSheet(
        useRootNavigator: true,
        clipBehavior: Clip.antiAlias,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                height: 180,
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    FlatButton(
                      onPressed: () async {
                        var selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          final now = DateTime.now();
                          var selectedDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          _alarmTime = selectedDateTime;
                          setModalState(
                            () {
                              _alarmTimeString = DateFormat('dd-MM HH:mm')
                                  .format(selectedDateTime);
                            },
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          _alarmTimeString,
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: ColorsSchema().primaryColors,
                      onPressed: () async {
                        DateTime scheduleAlarmDateTime = _alarmTime;
                        if (_alarmTime.isAfter(DateTime.now()))
                          scheduleAlarmDateTime =
                              _alarmTime.add(Duration(seconds: 10));
                        else
                          scheduleAlarmDateTime =
                              _alarmTime.add(Duration(days: 1));
                        print(scheduleAlarmDateTime);
                        updatePengingat();
                        scheduleAlarm(
                            widget.celenganModel.namaTarget,
                            widget.celenganModel.progress.toString() +
                                " dari " +
                                widget.celenganModel.nominalTarget.toString(),
                            scheduleAlarmDateTime);
                      },
                      label: Text("save"),
                      icon: Icon(Icons.alarm),
                    )
                  ],
                ),
              );
            },
          );
        });
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
        widget.celenganModel.pengingat,
        DateTime.parse(widget.celenganModel.alarmDateTime)
            .add(Duration(days: 1))
            .toString());
    dbCelengan.setId(widget.celenganModel.id);
    await db.upadteData(dbCelengan);
    addRecordData();
  }

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
                context, MaterialPageRoute(builder: (context) => Home()));
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
                scheduleAlarm(
                    widget.celenganModel.namaTarget,
                    widget.celenganModel.progress.toString() +
                        " dari " +
                        widget.celenganModel.nominalTarget.toString(),
                    DateTime.parse(widget.celenganModel.alarmDateTime));
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
    _alarmTime = DateTime.now();
    loadNabung();
    getListById(widget.id);
    _calcTotal();
    getListNominal(widget.id);
    loadDataStat();
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
                  } else {
                    aturPengingat();
                  }
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
                  list != null && statistik != null && coba.length != null
                      ? Statistik(
                          list.length > 0 ? list[0].progress : 0,
                          list.length > 0 ? list[0].nominalTarget : 0,
                          coba.length == 0 ? null : statistik)
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

  void scheduleAlarm(String title, String body, DateTime dateTime) async {
    var scheduleNotificationDateTime = dateTime.add(Duration(seconds: 10));

    var androidPlatformChanelSpesific = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for alarm notif',
      icon: 'app_icon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var iosPlatfromChanelSpesifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platfromChannelSpesific = NotificationDetails(
        androidPlatformChanelSpesific, iosPlatfromChanelSpesifics);
    await flutterLocalNotificationsPlugin.schedule(
        0, title, body, scheduleNotificationDateTime, platfromChannelSpesific);
  }
}
