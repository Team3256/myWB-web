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

  void login() async {
    setState(() {
      loginWidget = new Container();
    });
    try {
      await fb.auth().setPersistence("local");
      await fb.auth().signInWithEmailAndPassword(_email, _password);
      print("Signed in! ${fb.auth().currentUser.uid}");
      Navigator.pushNamed(context, '/');
    } catch (error) {
      print("Error: ${error.toString()}");
      accountErrorDialog(error.toString());
    }
    setState(() {
      loginWidget = new RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        onPressed: login,
        child: new Text("Login [DEPRECATED]"),
        elevation: 0.0,
        color: mainColor,
        textColor: Colors.white,
      );
    });
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
          http.get("$apiHost/api/users/${fb.auth().currentUser.uid}").then((response) {
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
              router.navigateTo(context, '/register', transition: TransitionType.fadeIn);
            }
          });
        } catch (error) {
          print(error);
        }
      }
    } catch (error) {
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
    loginWidget = new RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      onPressed: login,
      child: new Text("Login [DEPRECATED]"),
      elevation: 0.0,
      color: mainColor,
      textColor: Colors.white,
    );
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    if (fb.auth().currentUser == null) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Center(
          child: new Card(
            color: currCardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            elevation: 6.0,
            child: new Container(
              padding: EdgeInsets.all(32.0),
              height: 415.0,
              width: (MediaQuery.of(context).size.width > 500) ? 500.0 : MediaQuery.of(context).size.width - 25,
              child: new ListView(
                children: <Widget>[
                  new Text("Login", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  new Padding(padding: EdgeInsets.all(16.0),),
                  new Text("Login to your myWB Account below!", textAlign: TextAlign.center,),
                  new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.email),
                        labelText: "Email",
                        hintText: "Enter your email"
                    ),
                    onChanged: emailField,
                    onSubmitted: (input) {
                      login();
                    },
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                  new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.lock),
                        labelText: "Password",
                        hintText: "Enter your password"
                    ),
                    onChanged: passwordField,
                    onSubmitted: (input) {
                      login();
                    },
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    obscureText: true,
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  loginWidget,
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
