import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:mywb_web/navbar/home_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new HomeNavbar()
          ],
        ),
      ),
    );
  }
}
