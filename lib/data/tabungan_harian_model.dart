class TabunganHarainModel {
  int id;
  int _nominal;
  String _dateTime;
  String _desk;
  int _color;
  String _tgl;
  int forignKey;

  TabunganHarainModel(this._nominal, this._desk, this._dateTime, this._color,
      this.forignKey, this._tgl);

  TabunganHarainModel.map(dynamic object) {
    this._nominal = object['nominal'];
    this._dateTime = object['dateTime'];
    this._desk = object['desk'];
    this._color = object['color'];
    this.forignKey = object['foriegnCelengan'];
    this._tgl = object['tgl'];
  }

  int get nominal => _nominal;
  String get dateTime => _dateTime;
  String get desk => _desk;
  int get color => _color;
  String get tgl => _tgl;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['nominal'] = _nominal;
    map['dateTime'] = _dateTime;
    map['desk'] = _desk;
    map['color'] = _color;
    map['foriegnCelengan'] = forignKey;
    map['tgl'] = tgl;

    return map;
  }

  void setId(int id) {
    this.id = id;
  }
}
