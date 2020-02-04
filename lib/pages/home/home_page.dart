import 'dart:convert';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
            new Container(
              width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
              child: new SingleChildScrollView(
                child: new Column(
                  children: widgetList
                ),
              ),
            )
          ],
        ),
      );
    }
    else {
      return new Scaffold(
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              // TODO: App store download links
            ],
          ),
        ),
      );
    }
  }
}
