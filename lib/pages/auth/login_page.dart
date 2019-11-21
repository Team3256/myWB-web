import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/utils/theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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

  void checkAuth() async {
    if (fb.auth().currentUser != null) {
      print(fb.auth().currentUser.uid);
      await Future.delayed(const Duration(milliseconds: 100));
      Navigator.pushNamed(context, '/');
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
              height: 400.0,
              width: 500.0,
              child: new ListView(
                children: <Widget>[
                  new Text("Login", style: TextStyle(fontFamily: "Product Sans", fontSize: 35, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  new Padding(padding: EdgeInsets.all(16.0),),
                  new Text("Login to your myWB Account below!", style: TextStyle(fontFamily: "Product Sans"), textAlign: TextAlign.center,),
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
