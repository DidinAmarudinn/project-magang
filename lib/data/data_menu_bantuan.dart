class DataBantuan {
  String title;
  String desk;

  DataBantuan(this.title, this.desk);
}

List<DataBantuan> listMenuHelp = [
  DataBantuan("Cara Membuat Target Tabungan Baru",
      "1. Klik area tambah tabungan maka akan beralih ke halaman tambah tabungan\n2. Isi semua form di halaman tambah tabungan\n3. Klik simpan untuk menyimpan tabungan"),
  DataBantuan("Cara Menyimpan Uang Harian",
      "1. Klik target tabungan mana yang akan kita isi\n2. Klik tombol nabung di pojok kanan bawah\n3. Isi nominal dan deskripsi\n4.Klik simpan"),
  DataBantuan("Merubah Detail Target Tabungan",
      "1. Klik target tabungan mana yang akan kita ubah\n2. Klik menu dipjok kanan atas\n3. Klik update\n4. Maka akan diarahkan ke halaman untuk merubah target tabungan\n5. Isi form mana yang akan kita rubah\n6. Klik simpan untuk menyimpan perubahan"),
  DataBantuan("Menghapus Target Tabungan",
      "1. Klik target tabungan mana yang akan kita hapus\n2. Klik menu dipojok kanan atas\n3. Klik delete untuk mengapus target tabungan"),
  DataBantuan("Mengatur Pengingat",
      "1. Klik target tabungan mana yang akan kita atur pengingat.\n2. Klik menu dipojok kanan atas\n3. Klik atur pengingat\4. Maka akan diarahkan ke halaman untuk mengatur pengingat")
];
