import 'dart:convert';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_drawer.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {

  final Storage _localStorage = html.window.localStorage;

  User currUser;

  List<Widget> widgetList = new List();

  Future<void> checkDiscord() async {
    if (_localStorage.containsKey("userID")) {
      await http.get("$dbHost/users/${_localStorage["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
        print(response.body);
        currUser = new User(jsonDecode(response.body));
        if (response.statusCode == 200) {
          var userJson = jsonDecode(response.body);
          if (userJson["discordID"] == "404" || userJson["discordAuthToken"] == "404") {
            // Need to setup discord integration
            print("NEED TO SETUP DISCORD");
//            router.navigateTo(context, '/register/discord', transition: TransitionType.fadeIn);
          }
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

  Future<void> populateHomePage() async {
    widgetList.clear();
    if (_localStorage.containsKey("userID")) {
      widgetList.add(new Padding(padding: EdgeInsets.all(16.0),));
      widgetList.add(new Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        color: currCardColor,
        child: new InkWell(
          onTap: () {
            router.navigateTo(context, '/purchase-request', transition: TransitionType.fadeIn);
          },
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Purchase Request", style: TextStyle(fontSize: 20.0)),
              ],
            ),
          ),
        ),
      ));
    }
    else {
      widgetList.add(new Padding(padding: EdgeInsets.all(16.0),));
      widgetList.add(new Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        color: currCardColor,
        child: new Padding(
          padding: EdgeInsets.only(top: 50, bottom: 25, right: 100, left: 100),
          child: Column(
            children: <Widget>[
              new Text("Coming Soon!", style: TextStyle(fontSize: 50.0, fontFamily: "BebasNeue")),
              new Image.asset('images/wblogo.png', height: 500.0, width: 500.0, fit: BoxFit.contain)
            ],
          ),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    checkDiscord();
    populateHomePage();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
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
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(16.0)),
                        new Text("Executive Team", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                        new Padding(padding: EdgeInsets.all(8.0)),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_martin.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Martin Liu", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("President", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_kashyap.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Kashyap Chaturvedula", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Vice President", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        new Padding(padding: EdgeInsets.all(8.0)),
                        new Text("Leadership Team", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                        new Padding(padding: EdgeInsets.all(8.0)),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_kashyap.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Kashyap Chaturvedula", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Design", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_martin.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Martin Liu", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("CAD", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_neel.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Neel Tripathi", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Prototyping", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Padding(padding: EdgeInsets.all(8.0)),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_chanel.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Chanel Lim", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Assembly", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_albert.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Albert Zhao", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Electrical", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_alex.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Alex Wan", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Fabrication", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Padding(padding: EdgeInsets.all(8.0)),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_nic.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Nic Pham", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Software Teleop", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_rohan.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Rohan Viswanathan", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Software Auto", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_sam.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Samuel Stephen", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Systems", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Padding(padding: EdgeInsets.all(8.0)),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_flaumbert.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Flaumbert Ruas", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Logistics", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_kayla.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Kayla Kelsall", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Business", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                            new Card(
                              color: currCardColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              elevation: 0.0,
                              child: new Container(
                                padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                                child: new Column(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(150)),
                                      child: new Image.network(
                                        "http://vcrobotics.net/images/frc2020/lead_parth.png",
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Parth Kasmalkar", style: TextStyle(fontSize: 25),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                    new Text("Scouting", style: TextStyle(fontSize: 20),),
                                    new Padding(padding: EdgeInsets.all(4.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Padding(padding: EdgeInsets.all(16.0)),
                      ]
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
        appBar: new AppBar(
          title: new Text("Team", style: TextStyle(fontFamily: "Oswald"),),
          elevation: 0.0,
          backgroundColor: mainColor,
        ),
        drawer: new HomeDrawer(),
        backgroundColor: currBackgroundColor,
        body: new Container(
          width: MediaQuery.of(context).size.width - 16,
          child: new SingleChildScrollView(
            child: new Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(16.0)),
                  new Text("Executive Team", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_martin.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Martin Liu", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("President", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_kashyap.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Kashyap Chaturvedula", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Vice President", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new Text("Leadership Team", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_kashyap.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Kashyap Chaturvedula", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Design", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_martin.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Martin Liu", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("CAD", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_neel.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Neel Tripathi", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Prototyping", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_chanel.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Chanel Lim", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Assembly", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_albert.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Albert Zhao", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Electrical", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_alex.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Alex Wan", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Fabrication", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_nic.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Nic Pham", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Software Teleop", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_rohan.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Rohan Viswanathan", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Software Auto", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_sam.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Samuel Stephen", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Systems", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_flaumbert.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Flaumbert Ruas", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Logistics", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_kayla.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Kayla Kelsall", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Business", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 32, left: 32),
                          child: new Column(
                            children: <Widget>[
                              new ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(150)),
                                child: new Image.network(
                                  "http://vcrobotics.net/images/frc2020/lead_parth.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Parth Kasmalkar", style: TextStyle(fontSize: 25),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Text("Scouting", style: TextStyle(fontSize: 20),),
                              new Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Padding(padding: EdgeInsets.all(16.0)),
                ]
            ),
          ),
        ),
      );
    }
  }
}
