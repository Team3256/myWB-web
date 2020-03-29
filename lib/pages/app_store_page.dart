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

class AppStorePage extends StatefulWidget {
  @override
  _AppStorePageState createState() => _AppStorePageState();
}

class _AppStorePageState extends State<AppStorePage> {

  final Storage _localStorage = html.window.localStorage;

  User currUser;

  List<Widget> widgetList = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: new Image.asset(
                "images/wblogo_blue.png",
                width: 200,
                height: 200,
              ),
            ),
            new Padding(padding: EdgeInsets.all(4)),
            new Text("myWB", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            new Padding(padding: EdgeInsets.all(32)),
            new GestureDetector(
              onTap: () {
                html.window.location.assign("https://onelink.to/3affq5");
              },
              child: new Image.network(
                "https://i.dlpng.com/static/png/6921247_preview.png",
                width: 250,
                height: 250,
              ),
            )
          ],
        ),
      ),
    );
  }
}
