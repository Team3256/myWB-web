import 'dart:convert';
import 'dart:html';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/src/interop/database_interop.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

class NewPurchaseRequestPage extends StatefulWidget {
  @override
  _NewPurchaseRequestPageState createState() => _NewPurchaseRequestPageState();
}

class _NewPurchaseRequestPageState extends State<NewPurchaseRequestPage> {

  final Storage _localStorage = html.window.localStorage;

  User currUser = new User.plain();

  List<Widget> widgetList = new List();

  fb.UploadTask _uploadTask;
  double uploadProgress = 0;

  String prID = "";
  bool isSheet = false;
  String partName = "";
  int partQuantity = 0;
  String vendor = "";
  DateTime needBy = DateTime.now();
  String partNumber = "";
  double cost = 0;
  String justification = "";

  String partUrl = "";

  Future<void> getUser() async {
    if (_localStorage.containsKey("userID")) {
      await http.get("$dbHost/users/${_localStorage["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
        print(response.body);
        if (response.statusCode == 200) {
          setState(() {
            currUser = new User(jsonDecode(response.body));
          });
        }
        else if (response.statusCode == 404) {
          print("USER NOT IN DB");
          _localStorage.remove("userID");
          await fb.auth().signOut();
          router.navigateTo(context, '/login', transition: TransitionType.fadeIn);
        }
      });
    }
  }

  _startFilePicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        final reader = new FileReader();
        reader.onLoadEnd.listen((e) {
          _uploadTask = fb.storage().ref("purchase-requests/$prID.pdf").put(file);
          _uploadTask.jsObject.on('state_changed', (snapshot) async {
            setState(() {
              uploadProgress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            });
            print(uploadProgress.toString());
            if (uploadProgress == 100) {
              await Future.delayed(const Duration(seconds: 2));
              var downUrl = await _uploadTask.snapshot.ref.getDownloadURL();
              setState(() {
                partUrl = downUrl.toString();
              });
              print(partUrl);
            }
          });
        });
        reader.readAsDataUrl(file);
      }
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: needBy,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2020, 12));
    if (picked != null && picked != needBy)
      setState(() {
        needBy = picked;
      });
  }

  _NewPurchaseRequestPageState() {
    currUser.email = "";
    getUser();
    prID = fb.database().ref("pushID").push().key;
  }

  @override
  Widget build(BuildContext context) {
    if (_localStorage.containsKey("userID")) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Column(
          children: <Widget>[
            new HomeNavbar(),
            new Expanded(
              child: new Container(
                width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                child: new SingleChildScrollView(
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(16.0),),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.all(32.0),
                          width: double.infinity,
                          child: new Column(
                            children: <Widget>[
                              new Text("Purchase Request", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                              new Padding(padding: EdgeInsets.all(16.0),),
                              new RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: "The name, username and photo associated with your myWB account will be recorded when you upload files and submit this form. Not ${currUser.email}? ",
                                      style: new TextStyle(color: Colors.black),
                                    ),
                                    new TextSpan(
                                      text: 'Switch account',
                                      style: new TextStyle(color: Colors.blue),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                        fb.auth().signOut();
                                        fb.auth().signOut();
                                        _localStorage.remove("userID");
                                        html.window.location.reload();
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.all(32.0),
                          width: double.infinity,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text("Upload PR Sheet?", style: TextStyle(fontSize: 20.0)),
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: 'Make a COPY (File > Make a Copy) of this ',
                                      style: new TextStyle(color: Colors.black),
                                    ),
                                    new TextSpan(
                                      text: 'PR Template',
                                      style: new TextStyle(color: Colors.blue),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () { launch('https://www.google.com/url?q=https://docs.google.com/spreadsheets/d/1rmxSd8tdBhkWLGsT3RRovyf5NRBTFJHqC7DtSg76Wlc/edit?usp%3Dsharing&sa=D&ust=1580609974720000&usg=AFQjCNG0eiY235xQejY4xFcGPztbD4ilqw');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              new RadioListTile(
                                title: new Text("Yes"),
                                value: 1,
                                groupValue: isSheet ? 1 : 2,
                                onChanged: (value) {
                                  setState(() {
                                    isSheet = true;
                                  });
                                },
                              ),
                              new RadioListTile(
                                title: new Text("No"),
                                value: 2,
                                groupValue: isSheet ? 1 : 2,
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    isSheet = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
                      new Card(
                        color: currCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        elevation: 0.0,
                        child: new Container(
                          padding: EdgeInsets.all(32.0),
                          width: double.infinity,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text("What is the PR Sheet?", style: TextStyle(fontSize: 20.0)),
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: "A purchase request sheet allows you to make a large, bulk order easily rather than making multiple manual Google Form entries. This is useful for large purchase requests! Duplicate the template ",
                                      style: new TextStyle(color: Colors.black),
                                    ),
                                    new TextSpan(
                                      text: 'here',
                                      style: new TextStyle(color: Colors.blue),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () { launch('https://www.google.com/url?q=https://docs.google.com/spreadsheets/d/1rmxSd8tdBhkWLGsT3RRovyf5NRBTFJHqC7DtSg76Wlc/edit?usp%3Dsharing&sa=D&ust=1580609974721000&usg=AFQjCNGWIBSJIH1eOeYK3iINIXcJu1ib2A');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
                      new Visibility(
                        visible: isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Upload", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new RichText(
                                  text: new TextSpan(
                                    children: [
                                      new TextSpan(
                                        text: "Convert your Google Sheet to a PDF ",
                                        style: new TextStyle(color: Colors.black),
                                      ),
                                      new TextSpan(
                                        text: '(HOW TO)',
                                        style: new TextStyle(color: Colors.blue),
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () { launch('https://www.youtube.com/watch?v=xqvyKxHZDgA&feature=youtu.be&t=16');
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.all(4.0)),
                                new Visibility(
                                  visible: uploadProgress != 100 && uploadProgress != 0,
                                  child: new Container(
                                    height: 50,
                                    width: 50,
                                    padding: EdgeInsets.all(8.0),
                                    child: new HeartbeatProgressIndicator(
                                      child: new Image.asset(
                                        'images/wblogo.png',
                                        height: 20.0,
                                      ),
                                    )
                                  ),
                                ),
                                new Visibility(
                                  visible: uploadProgress == 100,
                                  child: new Text("File uploaded successfully!", style: TextStyle(color: Colors.green),),
                                ),
                                new OutlineButton(
                                  onPressed: () {
                                    setState(() {
                                      uploadProgress = 0;
                                    });
                                    _startFilePicker();
                                  },
                                  child: Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        new Icon(Icons.file_upload),
                                        new Text("Upload"),
                                      ],
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Part Name", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new TextField(
                                  decoration: InputDecoration(
                                    labelText: "Part Name",
                                    hintText: "Enter the part name"
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      partName = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Part Number / SKU", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Part Number",
                                      hintText: "Enter the part number"
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      partNumber = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Part Quantity", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Part Quantity",
                                      hintText: "Enter the part quantity"
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    partQuantity = int.tryParse(value);
                                    if (partQuantity != null) {
                                      setState(() {
                                        partQuantity = int.tryParse(value);
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Part URL", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Part URL",
                                      hintText: "Enter the part url"
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      partUrl = value;
                                    });
                                  },
                                  keyboardType: TextInputType.url,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Vendor", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new RadioListTile(
                                  title: new Text("McMaster"),
                                  value: 1,
                                  groupValue: vendor == "McMaster" ? 1 : 2,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "McMaster";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("WCP"),
                                  value: 2,
                                  groupValue: vendor == "WCP" ? 2 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "WCP";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("Amazon"),
                                  value: 3,
                                  groupValue: vendor == "Amazon" ? 3 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "Amazon";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("VEX"),
                                  value: 4,
                                  groupValue: vendor == "VEX" ? 4 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "VEX";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("REV"),
                                  value: 5,
                                  groupValue: vendor == "REV" ? 5 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "REV";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("AndyMark"),
                                  value: 6,
                                  groupValue: vendor == "AndyMark" ? 6 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "AndyMark";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("DigiKey"),
                                  value: 7,
                                  groupValue: vendor == "DigiKey" ? 7 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "DigiKey";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("Powerwerx"),
                                  value: 8,
                                  groupValue: vendor == "Powerwerx" ? 8 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "Powerwerx";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("HansenHobbies"),
                                  value: 9,
                                  groupValue: vendor == "HansenHobbies" ? 9 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "HansenHobbies";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("WDL Systems"),
                                  value: 10,
                                  groupValue: vendor == "WDL Systems" ? 10 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "WDL Systems";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("The Home Depot"),
                                  value: 11,
                                  groupValue: vendor == "The Home Depot" ? 11 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "The Home Depot";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("Lowes"),
                                  value: 12,
                                  groupValue: vendor == "Lowes" ? 12 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "Lowes";
                                    });
                                  },
                                ),
                                new RadioListTile(
                                  title: new Text("CTR Electronics"),
                                  value: 13,
                                  groupValue: vendor == "CTR Electronics" ? 13 : 1,
                                  onChanged: (value) {
                                    setState(() {
                                      vendor = "CTR Electronics";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Need By", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new Text("Next Day for ASAP"),
                                new RaisedButton(
                                  elevation: 0.0,
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                  child: new Text(DateFormat.yMd().format(needBy)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Cost Per Item", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Cost",
                                      hintText: "Enter the part cost"
                                  ),
                                  onChanged: (value) {
                                    cost = double.tryParse(value);
                                    if (cost != null) {
                                      setState(() {
                                        cost = double.tryParse(value);
                                      });
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Total Cost", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new Text("EXCLUDING shipping, taxes, etc."),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new Text("\$${(cost * partQuantity).toStringAsFixed(2)}", style: TextStyle(fontSize: 17.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Justification for Purchase?", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Justification",
                                      hintText: "Explain yo self"
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      justification = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(visible: !isSheet, child: new Padding(padding: EdgeInsets.all(8.0),)),
                      new Visibility(
                        visible: !isSheet && partName != "" && partNumber != "" && partQuantity != null && partUrl != "" && cost != null && justification != "" && vendor != "",
//                        visible: true,
                        child: new RaisedButton(
                          child: new Text("Submit Purchase Request", style: TextStyle(fontSize: 20.0)),
                          elevation: 0.0,
                          color: mainColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          onPressed: () async {
                            await http.post("$dbHost/purchase-requests", headers: {"Authentication": "Bearer $apiKey"}, body: jsonEncode({
                              "id": prID,
                              "isSheet": false,
                              "userID": currUser.id,
                              "partName": partName,
                              "partQuantity": partQuantity,
                              "partUrl": partUrl,
                              "vendor": vendor,
                              "needBy": DateFormat("yyyy-MM-dd").format(needBy),
                              "submittedOn": DateFormat.yMd().format(DateTime.now()).toString(),
                              "partNumber": partNumber,
                              "cost": cost,
                              "totalCost": double.tryParse((cost * partQuantity).toStringAsFixed(2)),
                              "justification": justification
                            })).then((response) async {
                              print(response.body);
                              if (response.statusCode != 200) {
                                html.window.alert(response.body);
                              }
                              else {
                                router.navigateTo(context, '/purchase-request/view?id=$prID', transition: TransitionType.fadeIn);
                              }
                            });
                          },
                        ),
                      ),
                      new Visibility(
                      visible: isSheet && partUrl != "",
//                        visible: true,
                        child: new RaisedButton(
                          child: new Text("Submit PR Sheet", style: TextStyle(fontSize: 20.0)),
                          elevation: 0.0,
                          color: mainColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          onPressed: () async {
                            await http.post("$dbHost/purchase-requests", headers: {"Authentication": "Bearer $apiKey"}, body: jsonEncode({
                              "id": prID,
                              "isSheet": true,
                              "userID": currUser.id,
                              "partName": "404",
                              "partQuantity": 404,
                              "partUrl": partUrl,
                              "vendor": "404",
                              "needBy": "2020-04-04",
                              "submittedOn": DateFormat.yMd().format(DateTime.now()).toString(),
                              "partNumber": "404",
                              "cost": 404,
                              "totalCost": 404,
                              "justification": "404"
                            })).then((response) async {
                              print(response.body);
                              if (response.statusCode != 200) {
                                html.window.alert(response.body);
                              }
                              else {
                                router.navigateTo(context, '/purchase-request/view?id=$prID', transition: TransitionType.fadeIn);
                              }
                            });
                          },
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(16.0),),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    else {
      return new LoginPage();
    }
  }
}
