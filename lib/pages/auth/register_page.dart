import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/services.dart';
import 'package:mywb_web/main.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_web/utils/phone_number_formatter.dart';
import 'package:mywb_web/utils/theme.dart';
import 'dart:html' as html;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final Storage _localStorage = html.window.localStorage;

  Color vBtnColor = mainColor;
  Color vBtnTxtBtnColor = Colors.white;

  Color jvBtnColor = null;
  Color jvBtnTxtBtnColor = Colors.black;

  String firstName = "";
  TextEditingController firstNameController = new TextEditingController();

  String lastName = "";
  TextEditingController lastNameController = new TextEditingController();

  String email = "";
  TextEditingController emailController = new TextEditingController();

  String phone = "";
  TextEditingController phoneController = new TextEditingController();

  String grade = "";
  TextEditingController gradeController = new TextEditingController();

  String shirtSize = "M";
  String jacketSize = "M";

  List<String> rolesList = new List();
  List<String> permsList = new List();

  bool varsity = true;

  void checkAuth() async {
    if (_localStorage.containsKey("userID")) {
      print(_localStorage["userID"]);
      print("User is registered with google");
    }
    else {
      await Future.delayed(const Duration(milliseconds: 100));
      router.navigateTo(context, '/login', transition: TransitionType.fadeIn);
    }
  }

  _RegisterPageState() {
    checkAuth();
    firstNameController.text = fb.auth().currentUser.displayName.split(" ")[0];
    firstName = fb.auth().currentUser.displayName.split(" ")[0];
    lastNameController.text = fb.auth().currentUser.displayName.split(" ")[1];
    lastName = fb.auth().currentUser.displayName.split(" ")[1];
    emailController.text = fb.auth().currentUser.email;
    email = fb.auth().currentUser.email;
    phoneController.text = fb.auth().currentUser.phoneNumber;
    phone = fb.auth().currentUser.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Center(
        child: new Card(
          color: currCardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 6.0,
          child: new Container(
            padding: EdgeInsets.all(32.0),
            height: 710.0,
            width: (MediaQuery.of(context).size.width > 500) ? 500.0 : MediaQuery.of(context).size.width - 25,
            child: new ListView(
              children: <Widget>[
                new Text("Register", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center,),
                new Padding(padding: EdgeInsets.all(16.0),),
                new Text("Finish creating your myWB Account below!", textAlign: TextAlign.center,),
                new TextField(
                  decoration: InputDecoration(
                      icon: new Icon(Icons.email),
                      labelText: "First Name",
                      hintText: "Enter your first name"
                  ),
                  controller: firstNameController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    setState(() {
                      firstName = value;
                    });
                  },
                ),
                new TextField(
                  decoration: InputDecoration(
                      icon: new Icon(Icons.lock),
                      labelText: "Last Name",
                      hintText: "Enter your last name"
                  ),
                  controller: lastNameController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    setState(() {
                      lastName = value;
                    });
                  },
                ),
                new TextField(
                  decoration: InputDecoration(
                      icon: new Icon(Icons.email),
                      labelText: "Email",
                      hintText: "Enter your email"
                  ),
                  controller: emailController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                new TextField(
                  decoration: InputDecoration(
                      icon: new Icon(Icons.lock),
                      labelText: "Phone",
                      hintText: "Enter your phone number"
                  ),
                  controller: phoneController,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {
                      phone = value;
                    });
                  },
                ),
                new TextField(
                  decoration: InputDecoration(
                      icon: new Icon(Icons.email),
                      labelText: "Grade",
                      hintText: "Enter your grade"
                  ),
                  controller: gradeController,
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {
                      grade = value;
                    });
                  },
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        child: new Text("Varsity"),
                        textColor: vBtnTxtBtnColor,
                        color: vBtnColor,
                        onPressed: () {
                          setState(() {
                            varsity = true;
                            vBtnColor = mainColor;
                            vBtnTxtBtnColor = Colors.white;
                            jvBtnColor = null;
                            jvBtnTxtBtnColor = Colors.black;
                          });
                        },
                      ),
                    ),
                    new Expanded(
                      child: new FlatButton(
                        child: new Text("Junior Varsity"),
                        textColor: jvBtnTxtBtnColor,
                        color: jvBtnColor,
                        onPressed: () {
                          setState(() {
                            varsity = false;
                            jvBtnColor = mainColor;
                            jvBtnTxtBtnColor = Colors.white;
                            vBtnColor = null;
                            vBtnTxtBtnColor = Colors.black;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "Shirt Size",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
                      ),
                    ),
                    new DropdownButton(
                      value: shirtSize,
                      items: [
                        DropdownMenuItem(child: new Text("S"), value: "S"),
                        DropdownMenuItem(child: new Text("M"), value: "M"),
                        DropdownMenuItem(child: new Text("L"), value: "L"),
                        DropdownMenuItem(child: new Text("XL"), value: "XL"),
                      ],
                      onChanged: (value) {
                        setState(() {
                          shirtSize = value;
                        });
                      },
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "Jacket Size",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
                      ),
                    ),
                    new DropdownButton(
                      value: jacketSize,
                      items: [
                        DropdownMenuItem(child: new Text("S"), value: "S"),
                        DropdownMenuItem(child: new Text("M"), value: "M"),
                        DropdownMenuItem(child: new Text("L"), value: "L"),
                        DropdownMenuItem(child: new Text("XL"), value: "XL"),
                      ],
                      onChanged: (value) {
                        setState(() {
                          jacketSize = value;
                        });
                      },
                    ),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new FlatButton(
                  onPressed: () async {
                    if (firstName == "" || lastName == "" || email == "" || phone == "" || grade == "") {
                      html.window.alert("Please make sure that all fields are filled out!");
                    }
                    else {
                      try {
                        User registerUser = new User.plain();
                        registerUser.id = fb.auth().currentUser.uid;
                        registerUser.firstName = firstName;
                        registerUser.lastName = lastName;
                        registerUser.email = email;
                        registerUser.phone = phone;
                        registerUser.grade = int.parse(grade);
                        registerUser.role = "";
                        registerUser.varsity = varsity;
                        registerUser.shirtSize = shirtSize;
                        registerUser.jacketSize = jacketSize;
                        registerUser.discordID = "404";
                        registerUser.discordAuthToken = "404";
                        await cycleApiKey().then((value) async {
                          await http.post("$dbHost/users", body: jsonEncode(registerUser), headers: {HttpHeaders.contentTypeHeader: "application/json", "Authentication": "Bearer $apiKey"}).then((response) {
                            print(response.body);
                            if (response.statusCode == 200) {
                              print("SUCCESS");
                              router.navigateTo(context, '/register/discord', transition: TransitionType.fadeIn);
                            }
                            else if (response.statusCode == 409) {
                              print("USER ALREADY IN DB");
                              html.window.alert(response.body);
                            }
                            else {
                              print("UNKNOWN ERROR - SEE DB LOGS");
                              html.window.alert(response.body);
                            }
                          });
                        });
                      } catch (error) {
                        print(error);
                        html.window.alert(error);
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  highlightColor: Colors.white,
                  color: Color(0xFF7289DA),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(image: AssetImage("images/discord.png"), height: 25.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Link with Discord',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
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
}
