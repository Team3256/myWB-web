import 'dart:html';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/utils/config.dart';
import 'dart:html' as html;

import 'package:mywb_web/utils/theme.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  final Storage _localStorage = html.window.localStorage;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width * 4/5,
      padding: EdgeInsets.all(16),
      color: mainColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Image.asset('images/WB_Website_Logo.png'),
          new Padding(padding: EdgeInsets.all(64)),
          new FlatButton(
            child: new Text("HOME", style: TextStyle(color: Colors.white)),
            onPressed: () {
              router.navigateTo(context, '/', transition: TransitionType.fadeIn);
            },
          ),
          new FlatButton(
            child: new Text("ABOUT", style: TextStyle(color: Colors.white)),
            onPressed: () {
              router.navigateTo(context, '/team', transition: TransitionType.fadeIn);
            },
          ),
          new FlatButton(
            child: new Text("TEAM", style: TextStyle(color: Colors.white)),
            onPressed: () {
              router.navigateTo(context, '/team', transition: TransitionType.fadeIn);
            },
          ),
          new FlatButton(
            child: new Text("STORE", style: TextStyle(color: Colors.white)),
            onPressed: () {
              router.navigateTo(context, '/store', transition: TransitionType.fadeIn);
            },
          ),
          new Padding(padding: EdgeInsets.all(4.0),),
          new Visibility(
            visible: (!_localStorage.containsKey("userID")),
            child: new OutlineButton(
              highlightElevation: 6.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              borderSide: BorderSide(color: Colors.grey),
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
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
