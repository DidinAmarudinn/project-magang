class CelenganModel {
  int id;
  String _namaTarget;
  int _nominalTarget;
  String _createDate;
  String _alarmDateTime;
  String _namaKategori;
  String _deskripsi;
  int _progreess;
  int _lamaTarget;
  int _pengingat;
  int _progressTerakhir;
  int _indexKategori;

  CelenganModel(
      this._namaTarget,
      this._nominalTarget,
      this._deskripsi,
      this._lamaTarget,
      this._createDate,
      this._namaKategori,
      this._progreess,
      this._indexKategori,
      this._pengingat,
      this._alarmDateTime,
      this._progressTerakhir);

  CelenganModel.map(dynamic object) {
    this._namaTarget = object['namaTarget'];
    this._nominalTarget = object['nominalTarget'];
    this._createDate = object['createDate'];
    this._namaKategori = object['namaKategori'];
    this._deskripsi = object['deskripsi'];
    this._progreess = object['progress'];
    this._lamaTarget = object['lamaTarget'];
    this._indexKategori = object['indexKategori'];
    this._pengingat = object['pengingat'];
    this._alarmDateTime = object['alarmDateTime'];
    this._progressTerakhir = object['progressTerakhir'];
  }

  String get namaTarget => _namaTarget;
  int get nominalTarget => _nominalTarget;
  String get createDate => _createDate;
  String get namaKategori => _namaKategori;
  int get progress => _progreess;
  String get deskrpsi => _deskripsi;
  int get lamaTarget => _lamaTarget;
  int get indexKategori => _indexKategori;
  int get pengingat => _pengingat;
  String get alarmDateTime => _alarmDateTime;
  int get progressTerakhir => _progressTerakhir;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['namaTarget'] = _namaTarget;
    map['nominalTarget'] = _nominalTarget;
    map['createDate'] = _createDate;
    map['namaKategori'] = _namaKategori;
    map['progress'] = _progreess;
    map['deskripsi'] = _deskripsi;
    map['lamaTarget'] = _lamaTarget;
    map['indexKategori'] = _indexKategori;
    map['pengingat'] = _pengingat;
    map['alarmDateTime'] = _alarmDateTime;
    map['progressTerakhir'] = _progressTerakhir;
    return map;
  }

  void setId(int id) {
    this.id = id;
  }
}
