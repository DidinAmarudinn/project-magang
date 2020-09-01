import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:nabung_beramal/data/data_kategori.dart';
import 'package:nabung_beramal/helper/db_celengan.dart';
import 'package:nabung_beramal/screens/homepage.dart';

class TambahTabungan extends StatefulWidget {
  final CelenganModel celenganModel;
  final bool isNew;
  TambahTabungan(this.celenganModel, this.isNew);
  @override
  _TambahTabunganState createState() => _TambahTabunganState();
}

class _TambahTabunganState extends State<TambahTabungan> {
  int _value = 0;
  String textButton = "Simpan";
  String title = "Buat Tabungan";
  String valueChip = "Tabungan Haji";
  bool peningat;
  var now = DateTime.now();
  final cNamaTarget = TextEditingController();
  final cNominalTarget = TextEditingController();
  final cDeskrpsi = TextEditingController();
  final cLamaTarget = TextEditingController();
  String _createDate;
  CelenganModel cele;

  int getLamaTarget() {
    var lamaTarget = int.parse(cLamaTarget.text) * 30;
    print(lamaTarget);
    return lamaTarget;
  }

  void saveData() async {
    if (widget.isNew) {
      addRecordData();
    } else {
      updateRecord();
    }
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  int progress = 0;
  Future addRecordData() async {
    var db = DbCelengan();
    String dateNow =
        "${now.day}-${now.month}-${now.year}, ${now.hour} : ${now.minute}";
    var dbCelengan = CelenganModel(
        cNamaTarget.text,
        int.parse(cNominalTarget.text),
        cDeskrpsi.text,
        getLamaTarget(),
        dateNow,
        valueChip,
        progress,
        _value,
        0);
    await db.saveData(dbCelengan);
    print("Saved");
  }

  Future updateRecord() async {
    var db = DbCelengan();
    String dateNow =
        "${now.day}-${now.month}-${now.year}, ${now.hour} : ${now.minute}";
    var dbCelengan = CelenganModel(
        cNamaTarget.text,
        int.parse(cNominalTarget.text),
        cDeskrpsi.text,
        getLamaTarget(),
        dateNow,
        valueChip,
        widget.celenganModel.progress,
        _value,
        1);
    dbCelengan.setId(this.cele.id);
    await db.upadteData(dbCelengan);
    setState(() {});
    print("updated");
  }

  @override
  void initState() {
    super.initState();
    if (widget.celenganModel != null) {
      cele = widget.celenganModel;
      cNamaTarget.text = cele.namaTarget;
      cNominalTarget.text = cele.nominalTarget.toString();
      cDeskrpsi.text = cele.deskrpsi;
      int result = (cele.lamaTarget / 30).toInt();
      cLamaTarget.text = result.toString();
      _value = cele.indexKategori;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0,
        backgroundColor: ColorsSchema().backgroundColors,
      ),
      floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            saveData();
          },
          backgroundColor: ColorsSchema().primaryColors,
          label: Text(widget.isNew ? textButton : "Update")),
      body: ListView(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isNew ? title : "Ubah Tabungan",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "buat target untuk mencapai impian-mu",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 25,
              ),
              buildColumn(
                  context, "Nama Target", TextInputType.text, cNamaTarget),
              SizedBox(
                height: 12,
              ),
              Text(
                "Kategori",
                style:
                    TextStyle(color: ColorsSchema().secondColors, fontSize: 16),
              ),
              Wrap(
                children: List<Widget>.generate(
                  list.length,
                  (int index) {
                    String chip = list[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        backgroundColor: Colors.white,
                        selectedColor: ColorsSchema().primaryColors,
                        label: Text(
                          chip,
                          style: TextStyle(
                              color: _value == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          setState(() {
                            valueChip = chip;
                            _value = index;
                            print(_value);
                          });
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
              SizedBox(
                height: 12,
              ),
              buildColumn(
                  context, "Nominal", TextInputType.number, cNominalTarget),
              SizedBox(
                height: 12,
              ),
              buildColumn(
                  context, "Durasi bulan", TextInputType.number, cLamaTarget),
              SizedBox(
                height: 12,
              ),
              buildColumn(context, "Deskripsi", TextInputType.text, cDeskrpsi),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildColumn(BuildContext context, String namaForm,
      TextInputType inputType, TextEditingController cControler) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          namaForm,
          style: TextStyle(color: ColorsSchema().secondColors, fontSize: 16),
        ),
        SizedBox(
          height: 8,
        ),
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
              controller: cControler,
              keyboardType: inputType,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: namaForm,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
