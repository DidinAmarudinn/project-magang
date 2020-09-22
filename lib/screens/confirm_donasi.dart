import 'dart:io';
import 'dart:math';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/data/tabungan_harian_model.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/helper/db_harian.dart';
import 'package:nabung_beramal/screens/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmDonasi extends StatefulWidget {
  final int pilihanDonasi;
  final int idCelengan;
  final String namaTabungan;

  final CelenganModel celenganModel;
  ConfirmDonasi(this.pilihanDonasi, this.idCelengan, this.celenganModel,
      this.namaTabungan);
  @override
  _ConfirmDonasiState createState() => _ConfirmDonasiState();
}

class _ConfirmDonasiState extends State<ConfirmDonasi> {
  String title = "";
  int random() {
    Random rnd;
    int min = 0;
    int max = 5;
    rnd = new Random();
    var d = min + rnd.nextInt(max - min);
    print(d);
    return d;
  }

  var now = DateTime.now();
  Future addRecordData() async {
    var db = DbTabHarain();
    String dateNow =
        "${now.day}-${now.month}-${now.year}, ${now.hour} : ${now.minute}";
    String dateNowTgl = "${now.day}-${now.month}-${now.year}";
    var dbtabHar = TabunganHarainModel(-widget.pilihanDonasi, "Donasi", dateNow,
        random(), widget.celenganModel.id, dateNowTgl);
    await db.saveData(dbtabHar);
    print(dateNowTgl);
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
        (widget.celenganModel.progress - widget.pilihanDonasi),
        widget.celenganModel.indexKategori,
        widget.celenganModel.pengingat,
        now.add(Duration(days: 1)).toString(),
        (-widget.pilihanDonasi));
    dbCelengan.setId(widget.celenganModel.id);

    await db.upadteData(dbCelengan);
    addRecordData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.idCelengan);
    print(widget.celenganModel.id);
  }

  void showFlushbar(BuildContext context) {
    Flushbar(
      forwardAnimationCurve: Curves.easeIn,
      reverseAnimationCurve: Curves.slowMiddle,
      margin: EdgeInsets.all(10),
      flushbarPosition: FlushbarPosition.TOP,
      padding: EdgeInsets.all(10),
      borderRadius: 8,
      backgroundColor: ColorsSchema().primaryColors,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 3),
      title: "Text Berhasil Disalin",
      message: "87299019283",
    )..show(context);
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
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
          "Konfirmasi Donasi" + title,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pilihan Donasi:",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        NumberFormat.currency(
                                locale: "id", decimalDigits: 0, symbol: "Rp")
                            .format(widget.pilihanDonasi)
                            .toString(),
                        style: TextStyle(
                            color: ColorsSchema().primaryColors,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                buildContainerNoRek(),
                buildContainerNoRek(),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 0,
            left: 0,
            child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      launchWhatsApp(
                          phone: "6287824549282", message: "konfirmasi donasi");
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: ColorsSchema().primaryColors,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          "Konfirmasi Donasi Lewat WA",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.namaTabungan == "Lainnya") {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      } else {
                        updateRecord();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          "Selesai",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildContainerNoRek() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "images/bca.png",
            fit: BoxFit.cover,
            width: 70,
            height: 50,
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bank BCA",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 12,
                ),
                Text("No. Rekening"),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText(
                      "87299019283",
                      style: TextStyle(
                          color: ColorsSchema().primaryColors, fontSize: 22),
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "87299019283"));
                        showFlushbar(context);
                      },
                      child: Icon(
                        Icons.content_copy,
                        color: ColorsSchema().primaryColors,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "a/n Didin Amarudin",
                  style: TextStyle(color: Colors.black54),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
