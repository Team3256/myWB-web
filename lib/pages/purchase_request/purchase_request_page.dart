import 'dart:convert';
import 'dart:html' as html;
import 'dart:html';
import 'package:fluro/fluro.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';

class PurchaseRequestPage extends StatefulWidget {
  @override
  _PurchaseRequestPageState createState() => _PurchaseRequestPageState();
}

class _PurchaseRequestPageState extends State<PurchaseRequestPage> {

  final Storage _localStorage = html.window.localStorage;

  List<DataRow> pendingList = new List();
  List<DataRow> approvedList = new List();
  List<DataRow> deniedList = new List();

  User currUser;

  Future<void> getUser() async {
    if (_localStorage.containsKey("userID")) {
      await http.get("$dbHost/users/${_localStorage["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
        print(response.body);
        if (response.statusCode == 200) {
          currUser = new User(jsonDecode(response.body));
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

  Future<void> getPR() async {
    await http.get("$dbHost/purchase-requests", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var prJson = jsonDecode(response.body);
      for (int i = 0; i < prJson.length; i++) {
        await http.get("$dbHost/users/${prJson[i]["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          var userJson = jsonDecode(response.body);
          setState(() {
            if (!prJson[i]["approved"]) {
              if (!prJson[i]["isSheet"]) {
                pendingList.add(new DataRow(
                  onSelectChanged: (val) {
                    router.navigateTo(context, '/purchase-request/view?id=${prJson[i]["id"]}', transition: TransitionType.fadeIn);
                  },
                  cells: [
                    new DataCell(new Text(prJson[i]["submittedOn"].toString())),
                    new DataCell(new Text(userJson["firstName"] + " " + userJson["lastName"])),
                    new DataCell(new Text(prJson[i]["partName"].toString())),
                    new DataCell(new Text(prJson[i]["partNumber"].toString())),
                    new DataCell(new Text(prJson[i]["partQuantity"].toString())),
                    new DataCell(new Text(prJson[i]["vendor"].toString())),
                    new DataCell(new Text(prJson[i]["needBy"].toString())),
                    new DataCell(new Text("\$" + prJson[i]["cost"].toString())),
                    new DataCell(new Text("\$" + prJson[i]["totalCost"].toString())),
                  ],
                ));
              }
              else {
                pendingList.add(new DataRow(
                  onSelectChanged: (val) {
                    router.navigateTo(context, '/purchase-request/view?id=${prJson[i]["id"]}', transition: TransitionType.fadeIn);
                  },
                  cells: [
                    new DataCell(new Text(prJson[i]["submittedOn"].toString())),
                    new DataCell(new Text(userJson["firstName"] + " " + userJson["lastName"])),
                    new DataCell(new Text("PR Sheet")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                  ],
                ));
              }
            }
            else {
              if (!prJson[i]["isSheet"]) {
                approvedList.add(new DataRow(
                  onSelectChanged: (val) {
                    router.navigateTo(context, '/purchase-request/view?id=${prJson[i]["id"]}', transition: TransitionType.fadeIn);
                  },
                  cells: [
                    new DataCell(new Text(prJson[i]["submittedOn"].toString())),
                    new DataCell(new Text(userJson["firstName"] + " " + userJson["lastName"])),
                    new DataCell(new Text(prJson[i]["partName"].toString())),
                    new DataCell(new Text(prJson[i]["partNumber"].toString())),
                    new DataCell(new Text(prJson[i]["partQuantity"].toString())),
                    new DataCell(new Text(prJson[i]["vendor"].toString())),
                    new DataCell(new Text(prJson[i]["needBy"].toString())),
                    new DataCell(new Text("\$" + prJson[i]["cost"].toString())),
                    new DataCell(new Text("\$" + prJson[i]["totalCost"].toString())),
                  ],
                ));
              }
              else {
                approvedList.add(new DataRow(
                  onSelectChanged: (val) {
                    router.navigateTo(context, '/purchase-request/view?id=${prJson[i]["id"]}', transition: TransitionType.fadeIn);
                  },
                  cells: [
                    new DataCell(new Text(prJson[i]["submittedOn"].toString())),
                    new DataCell(new Text(userJson["firstName"] + " " + userJson["lastName"])),
                    new DataCell(new Text("PR Sheet")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                    new DataCell(new Text("")),
                  ],
                ));
              }
            }
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getPR();
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
                            children: [
                              new Text("Purchase Requests", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                              new Padding(padding: EdgeInsets.all(16.0),),
                              new RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: "View pending and approved purchase requests below, or ",
                                      style: new TextStyle(color: Colors.black),
                                    ),
                                    new TextSpan(
                                      text: 'create a new one',
                                      style: new TextStyle(color: Colors.blue),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                        router.navigateTo(context, '/purchase-request/new', transition: TransitionType.fadeIn);
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
                            children: [
                              new Text("Pending Approval", style: TextStyle(fontSize: 20.0)),
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new Scrollbar(
                                child: new SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: new DataTable(
                                    columns: [
                                      new DataColumn(label: new Text("Submitted On", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Author", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Part Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Part #", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                                      new DataColumn(label: new Text("Vendor", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Need By", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Cost", style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                                      new DataColumn(label: new Text("Total Cost", style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                                    ],
                                    rows: pendingList
                                  ),
                                ),
                              )
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
                            children: [
                              new Text("Approved", style: TextStyle(fontSize: 20.0)),
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new Scrollbar(
                                child: new SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: new DataTable(
                                    columns: [
                                      new DataColumn(label: new Text("Submitted On", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Author", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Part Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Part #", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Vendor", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Need By", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Cost", style: TextStyle(fontWeight: FontWeight.bold))),
                                      new DataColumn(label: new Text("Total Cost", style: TextStyle(fontWeight: FontWeight.bold))),
                                    ],
                                    rows: approvedList
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
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
