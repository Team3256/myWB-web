import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:ui';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'dart:js' as js;

class StoreSuccessPage extends StatefulWidget {
  @override
  _StoreSuccessPageState createState() => _StoreSuccessPageState();
}

class _StoreSuccessPageState extends State<StoreSuccessPage> {

  final Storage _localStorage = html.window.localStorage;

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 3)).then((value) {
      html.window.location.assign("http://vcrobotics.net/#/store");
    });
  }

  @override
  void initState() {
    super.initState();
    if (!html.window.location.toString().contains("?session_id=")) {
      html.window.location.assign("http://vcrobotics.net/#/store");
    }
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Center(
        child: new Container(
          height: 500,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Image.asset(
                'images/wblogo.png',
                height: 100,
              ),
              new Padding(padding: EdgeInsets.all(4.0)),
              new Text("Success!", style: TextStyle(fontSize: 30, fontFamily: "Oswlad", fontWeight: FontWeight.bold, color: Colors.green),),
              new Text("You order has been successfully placed. Confirmation ID: ${html.window.location.toString().split("?session_id=")[1]}", style: TextStyle(fontSize: 17))
            ],
          ),
        )
      ),
    );
  }
}
