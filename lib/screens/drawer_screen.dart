import 'package:flutter/material.dart';
import 'package:nabung_beramal/colors/colors_schema.dart';
import 'package:nabung_beramal/data/nav_model.dart';
import 'package:nabung_beramal/screens/about_screen.dart';
import 'package:nabung_beramal/screens/help_screen.dart';
import 'package:nabung_beramal/screens/setting_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: ColorsSchema().primaryColors,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: drawerItems
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          if (e['title'] == "Tentang") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutScreen()));
                          } else if (e['title'] == "Bantuan") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpScreen()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingScreen()));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  e['icon'],
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  e['title'],
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Copyright",
                    style: TextStyle(color: Colors.white60),
                  ),
                  Icon(
                    Icons.copyright,
                    size: 10,
                    color: Colors.white60,
                  ),
                  Text(
                    "2020",
                    style: TextStyle(color: Colors.white60),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
