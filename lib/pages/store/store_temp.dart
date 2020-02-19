import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/utils/config.dart';
import 'dart:html' as html;
import 'package:mywb_web/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreTempPage extends StatefulWidget {
  @override
  _StoreTempPageState createState() => _StoreTempPageState();
}

class _StoreTempPageState extends State<StoreTempPage> {

  final Storage _localStorage = html.window.localStorage;

  User currUser;

  bool wbPolo = false;
  bool wbHoodie = false;
  bool shooterHoodie = false;
  bool shooterShirt = false;
  bool wbShirt = false;
  bool wbJoggers = false;
  bool snapback = false;
  bool beanie = false;
  bool flaumpack = false;
  bool drawstring = false;
  bool mug = false;
  bool whileSticker = false;
  bool blueSticker = false;
  bool lilSticker = false;

  Future<void> getUser() async {
    if (_localStorage.containsKey("userID")) {
      await http.get("$dbHost/users/${_localStorage["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
        print(response.body);
        if (response.statusCode == 200) {
          setState(() {
            currUser = new User(jsonDecode(response.body));
          });
        }
        else if (response.statusCode == 404) {
          print("USER NOT IN DB");
          _localStorage.remove("userID");
          await fb.auth().signOut();
          router.navigateTo(context, '/login', transition: TransitionType.fadeIn);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (true) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Column(
          children: <Widget>[
            new HomeNavbar(),
            new Expanded(
              child: new Container(
                width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                child: new SingleChildScrollView(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(16.0),),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new FlatButton(
                            child: new Text("", style: TextStyle(color: mainColor),),
                          ),
                          new FlatButton(
                            child: new Text("My Cart", style: TextStyle(color: mainColor),),
                            onPressed: () {
                              router.navigateTo(context, '/store/cart', transition: TransitionType.fadeIn);
                            },
                          ),
                        ],
                      ),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.all(32.0),
                          width: double.infinity,
                          child: new Column(
                            children: [
                              new Text("Merch Store", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                              new Padding(padding: EdgeInsets.all(16.0),),
                              new Text(
                                "All items ordered will be delivered to the robotics room (G137) in 7-10 business days. [debug]",
                                style: new TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(color: mainColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)), elevation: 0.0, child: new Container(padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0), width: double.infinity, child: new Text("Uniforms", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.start))),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new InkWell(
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () {
//                                router.navigateTo(context, '/store/view?id=2020polo', transition: TransitionType.fadeIn);
                              },
//                              onHover: (val) {
//                                setState(() {
//                                  wbPolo = val;
//                                });
//                              },
                              child: new Card(
                                color: currCardColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                elevation: 0.0,
                                child: new Container(
                                  height: 430,
                                  padding: EdgeInsets.all(32.0),
                                  child: new Column(
                                    children: [
                                      new Text("2020 Polo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                                      new Padding(padding: EdgeInsets.all(8.0),),
                                      new Image.network(
                                        "http://vcrobotics.net/images/2020polo_front.png",
                                        height: 255,
                                      ),
                                      new Padding(padding: EdgeInsets.all(8.0),),
                                      new Text(
                                        "Official WarriorBorgs Polo shirt for the 2020 season.",
                                        style: new TextStyle(color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new Padding(padding: EdgeInsets.all(4.0),),
                          new Expanded(
                            child: new InkWell(
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () {router.navigateTo(context, '/store/view?id=2020hoodie', transition: TransitionType.fadeIn);

                              },
                              onHover: (val) {
                                setState(() {
                                  wbHoodie = val;
                                });
                              },
                              child: new Card(
                                color: currCardColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                elevation: 0.0,
                                child: new Stack(
                                  children: <Widget>[
                                    new Container(
                                      height: 430,
                                      padding: EdgeInsets.all(32.0),
                                      child: new Column(
                                        children: [
                                          new Text("2020 Hoodie", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                                          new Padding(padding: EdgeInsets.all(8.0),),
                                          new Image.network(
                                            "https://files.cdn.printful.com/files/5a4/5a49881236c6b62b1850e7295060e338_preview.png",
                                          ),
                                          new Padding(padding: EdgeInsets.all(8.0),),
                                          new Text(
                                            "Official WarriorBorgs Hoodie for the 2020 season.",
                                            style: new TextStyle(color: Colors.black),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        height: wbHoodie ? 430 : 0,
                                        color: Colors.black54,
                                        padding: EdgeInsets.all(32.0),
                                        child: Center(child: new Text("\$34.50", style: TextStyle(color: Colors.white, fontSize: 40)))
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          new Padding(padding: EdgeInsets.all(4.0),),
                          new Expanded(
                            child: new Card(
                              color: currBackgroundColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                height: 430,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    else {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Column(
          children: <Widget>[
            new HomeNavbar(),
            new Padding(padding: EdgeInsets.all(16.0)),
            new Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              child: new Padding(
                padding: EdgeInsets.only(top: 50, bottom: 25, right: 100, left: 100),
                child: Column(
                  children: <Widget>[
                    new Text("Merch Store", style: TextStyle(fontSize: 50.0, fontFamily: "BebasNeue")),
                    new Text("\nComing Soon!", style: TextStyle(fontSize: 70.0, fontFamily: "BebasNeue")),
                    new Image.asset('images/wblogo.png', height: 500.0, width: 500.0, fit: BoxFit.contain)
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}