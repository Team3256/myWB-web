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

class StoreRedirectPage extends StatefulWidget {
  @override
  _StoreRedirectPageState createState() => _StoreRedirectPageState();
}

class _StoreRedirectPageState extends State<StoreRedirectPage> {

  final Storage _localStorage = html.window.localStorage;

  @override
  void initState() {
    super.initState();
    if (html.window.location.toString().contains("?session_id=")) {
      js.context.callMethod("checkout", [html.window.location.toString().split("?session_id=")[1]]);
    }
    else {
      router.navigateTo(context, '/store', transition: TransitionType.fadeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Center(
          child: new Image.asset(
            'images/wblogo.png',
            height: 25.0,
          ),
      ),
    );
  }
}
