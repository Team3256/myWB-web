import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class RegisterDiscordPage extends StatefulWidget {
  @override
  _RegisterDiscordPageState createState() => _RegisterDiscordPageState();
}

class _RegisterDiscordPageState extends State<RegisterDiscordPage> {

  void checkDiscord() async {
//    if (fb.auth().currentUser != null) {
//      print(fb.auth().currentUser.uid);
//      print("User is registered with google");
      if (!html.window.location.toString().contains("?token")) {
        print("TOKEN NOT PROVIDED");
        html.window.location.assign("http://localhost:8082/api/auth/discord/login");
      }
      else {
        await http.get("$apiHost/api/users/${fb.auth().currentUser.uid}").then((response) {
          var currUser = User.fromJson(jsonDecode(response.body));
          String token = html.window.location.toString().split("?token=")[1];
          if (token != "NO_CODE_PROVIDED") {
            print("TOKEN PROVIDED");
            http.get("https://discordapp.com/api/users/@me", headers: {"Authorization": "Bearer $token"}).then((response) {
              print(response.body);
            });
          }
          else {
            print("TOKEN NOT PROVIDED");
//            html.window.alert("You must link your discord account with your myWB account!");
            router.navigateTo(context, '/register/discord', transition: TransitionType.fadeIn);
          }
        });
      }
//    }
//    else {
//      await Future.delayed(const Duration(milliseconds: 100));
//      router.navigateTo(context, '/login', transition: TransitionType.fadeIn);
//    }
  }

  _RegisterDiscordPageState() {
    checkDiscord();
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
