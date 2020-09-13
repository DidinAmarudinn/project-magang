import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
          "Tentang Aplikasi",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(
              "Aplikasi ini dibuat menggunakan flutter, untuk memudahkan anda dalam mencatat tabungan atau target tabungan yang ingin anda capai, lebih mudah dengan adanya prediksi berapa yang harus anda simpan perhari dari lama target yang anda buat, dan dapat membantu anda untuk berdonasi membantu orang-orang yang membutuhkan dan disalurkan oleh relawan yang telah di seleksi oleh tim Dsantren It",
              style: TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  "Kritik dan Saran dapat anda kirim melalui email berikut",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "didinamarudin4@gmail.com",
                  style: TextStyle(
                      color: ColorsSchema().primaryColors,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
