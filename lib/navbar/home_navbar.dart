import 'dart:html';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/utils/config.dart';
import 'dart:html' as html;

import 'package:mywb_web/utils/theme.dart';

class HomeNavbar extends StatefulWidget {
  @override
  _HomeNavbarState createState() => _HomeNavbarState();
}

class _HomeNavbarState extends State<HomeNavbar> {

  final Storage _localStorage = html.window.localStorage;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 85.0,
      color: currCardColor,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 50,
            width: 300,
            child: new Text(
              "WarriorBorgs 3256",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontFamily: "Oswald"),
              textAlign: TextAlign.center,
            )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                child: new Text("HOME"),
                onPressed: () {
                  router.navigateTo(context, '/', transition: TransitionType.fadeIn);
                },
              ),
              new FlatButton(
                child: new Text("ABOUT"),
                onPressed: () {
                },
              ),
              new FlatButton(
                child: new Text("TEAM"),
                onPressed: () {
                },
              ),
              new FlatButton(
                child: new Text("STORE"),
                onPressed: () {
                },
              ),
              new Padding(padding: EdgeInsets.all(4.0),),
              new Visibility(
                visible: (!_localStorage.containsKey("userID")),
                child: new RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: new Text("LOGIN"),
                  textColor: Colors.white,
                  color: mainColor,
                  onPressed: () {
                    router.navigateTo(context, '/login', transition: TransitionType.materialFullScreenDialog);
                  },
                ),
              ),
              new Visibility(
                visible: (_localStorage.containsKey("userID")),
                child: new RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: new Text("SIGN OUT"),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      fb.auth().signOut();
                      _localStorage.remove("userID");
                      html.window.location.reload();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
