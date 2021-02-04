import 'dart:convert';
import 'dart:html';
import 'dart:ui';
import 'package:fluro/fluro.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'dart:html' as html;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final Storage _localStorage = html.window.localStorage;

  Widget loginWidget = new Container();

  String _email = "";
  String _password = "";

  void accountErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Login Error"),
          content: new Text(
            "There was an error logging you in: $error",
            style: TextStyle(fontFamily: "Product Sans", fontSize: 14.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("GOT IT"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void googleLogin() async {
    try {
      fb.auth().setPersistence("local");
      await fb.auth().signInWithPopup(fb.GoogleAuthProvider());
      if (fb.auth().currentUser != null) {
        print(fb.auth().currentUser.uid);
        print(fb.auth().currentUser.displayName);
        print(fb.auth().currentUser.email);
        _localStorage["userID"] = fb.auth().currentUser.uid;
        try {
          cycleApiKey();
          http.get("$dbHost/users/${fb.auth().currentUser.uid}", headers: {"Authorization": "Basic $apiKey"}).then((response) {
            print(response.body);
            if (response.statusCode == 200) {
              print("USER EXISTS IN DB");
              var userJson = jsonDecode(response.body);
              if (userJson["discordID"] == "404" || userJson["discordAuthToken"] == "404") {
                // Need to setup discord integration
                router.navigateTo(context, '/register/discord', transition: TransitionType.fadeIn);
              }
              else {
                router.navigateTo(context, '/', transition: TransitionType.fadeIn);
              }
            }
            else if (response.statusCode == 404) {
              print("USER NOT IN DB");
              if (fb.auth().currentUser.email.contains("warriorlife.net")) {
                router.navigateTo(context, '/register', transition: TransitionType.fadeIn);
              }
              else {
                html.window.alert("You must use your warriorlife email to create a myWB Account!");
                fb.auth().signOut();
              }
            }
          });
        } catch (error) {
          fb.auth().signOut();
          print(error);
        }
      }
    } catch (error) {
      fb.auth().signOut();
      print(error);
    }
  }

  void checkAuth() async {
    if (_localStorage.containsKey("userID")) {
      print("USER ALREADY LOGGED: ${_localStorage["userID"]}");
      await Future.delayed(const Duration(milliseconds: 100));
      router.navigateTo(context, '/', transition: TransitionType.fadeIn);
    }
    else {
      print("User not logged");
    }
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  _LoginPageState() {
    print(html.window.location.toString());
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    if (!_localStorage.containsKey("userID")) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Center(
          child: new Card(
            color: currCardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            elevation: 6.0,
            child: new Container(
              padding: EdgeInsets.all(32.0),
              height: 420.0,
              width: (MediaQuery.of(context).size.width > 500) ? 500.0 : MediaQuery.of(context).size.width - 25,
              child: new ListView(
                children: <Widget>[
                  new Text("Login", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                  new Padding(padding: EdgeInsets.all(16.0),),
                  new Text("Login to your myWB Account below!", textAlign: TextAlign.center,),
                  // new TextField(
                  //   decoration: InputDecoration(
                  //       icon: new Icon(Icons.email),
                  //       labelText: "Email",
                  //       hintText: "Enter your email"
                  //   ),
                  //   onChanged: emailField,
                  //   autocorrect: false,
                  //   keyboardType: TextInputType.emailAddress,
                  //   textCapitalization: TextCapitalization.none,
                  // ),
                  // new TextField(
                  //   decoration: InputDecoration(
                  //       icon: new Icon(Icons.lock),
                  //       labelText: "Password",
                  //       hintText: "Enter your password"
                  //   ),
                  //   onChanged: passwordField,
                  //   autocorrect: false,
                  //   keyboardType: TextInputType.text,
                  //   textCapitalization: TextCapitalization.none,
                  //   obscureText: true,
                  // ),
                  // new Padding(padding: EdgeInsets.all(8.0)),
                  // loginWidget,
                  new Padding(padding: EdgeInsets.all(8.0)),
                  OutlineButton(
                    onPressed: () {
                      googleLogin();
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0.0,
                    borderSide: BorderSide(color: Colors.grey),
                    highlightedBorderColor: mainColor,
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(image: AssetImage("images/google_logo.png"), height: 25.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else {
      print(fb.auth().currentUser.uid);
      return new Material(
        child: Center(
          child: new Text("Already signed in!"),
        ),
      );
    }
  }
}
