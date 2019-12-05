import 'dart:convert';
import 'dart:html';
import 'dart:io';
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

  final Storage _localStorage = html.window.localStorage;

  Widget displayWidget;

  void checkDiscord() async {
    if (_localStorage.containsKey("userID")) {
      print(_localStorage["userID"]);
      print("User is registered with google");
      if (!html.window.location.toString().contains("?token")) {
        print("TOKEN NOT PROVIDED");
        html.window.location.assign("http://localhost:8082/api/auth/discord/login");
      }
      else {
        String token = html.window.location.toString().split("?token=")[1];
        print(token);
        if (token != "NO_CODE_PROVIDED") {
          print("TOKEN PROVIDED");
          http.get("https://discordapp.com/api/users/@me", headers: {"Authorization": "Bearer $token"}).then((response) async {
            print(response.body);
            var discordJson = jsonDecode(response.body);
            setState(() {
              displayWidget = new Text("Successfully retrieved Discord information:\n\n${response.body}");
            });
            await http.get("$apiHost/api/users/${_localStorage["userID"]}").then((response) async {
              print(response.body);
              User currUser = User.fromJson(jsonDecode(response.body));
              print("TOKEN: " + token.toString());
              print("USER DISCORD ID: " + discordJson["id"].toString());
              currUser.discordAuthToken = token.toString();
              currUser.discordID = discordJson["id"].toString();
              await http.put("$apiHost/api/users/${_localStorage["userID"]}", body: jsonEncode(currUser), headers: {HttpHeaders.contentTypeHeader: "application/json"}).then((response) {
                print(response.body);
                if (response.statusCode == 200) {
                  print("SUCCESS");
                  router.navigateTo(context, '/', transition: TransitionType.fadeIn);
                }
                else {
                  print("UNKNOWN ERROR - SEE DB LOGS");
                  html.window.alert(response.body);
                }
              });
            });
          });
        }
        else {
          print("TOKEN NOT PROVIDED");
          setState(() {
            displayWidget = new Text("You must link your Discord account with myWB!\n\nSee a Systems person if you think this is an error.");
          });
          await Future.delayed(const Duration(seconds: 3));
          router.navigateTo(context, '/register/discord', transition: TransitionType.fadeIn);
        }
      }
    }
    else {
      await Future.delayed(const Duration(milliseconds: 100));
      router.navigateTo(context, '/login', transition: TransitionType.fadeIn);
    }
  }

  _RegisterDiscordPageState() {
    displayWidget = new HeartbeatProgressIndicator(
      child: new Image.asset(
        'images/wblogo.png',
        height: 25.0,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkDiscord();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Center(
        child: displayWidget
      ),
    );
  }
}
