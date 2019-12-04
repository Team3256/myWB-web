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
              "myWB",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                child: new Text("HOME"),
                onPressed: () {
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
                visible: (fb.auth().currentUser == null),
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
                visible: (fb.auth().currentUser != null),
                child: new RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: new Text("SIGN OUT"),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      fb.auth().signOut();
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
