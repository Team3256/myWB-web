import 'dart:convert';
import 'dart:html';

import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:mywb_web/utils/config.dart';
import 'dart:html' as html;
import 'package:mywb_web/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPurchaseRequest extends StatefulWidget {
  @override
  _ViewPurchaseRequestState createState() => _ViewPurchaseRequestState();
}

class _ViewPurchaseRequestState extends State<ViewPurchaseRequest> {

  final Storage _localStorage = html.window.localStorage;

  User currUser = new User.plain();

  List<Widget> widgetList = new List();

  User prUser = new User.plain();

  bool isSheet = false;
  String partName = "";
  int partQuantity = 0;
  String vendor = "";
  DateTime needBy;
  DateTime submittedOn;
  String partNumber = "";
  double cost = 0;
  double totalCost = 0;
  String justification = "";
  bool approved = false;

  String partUrl = "";


  Future<void> getPR(String id) async {
    await http.get("$dbHost/purchase-requests/${id}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      if (response.statusCode == 200) {
        var prJson = jsonDecode(response.body);
        await http.get("$dbHost/users/${prJson["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
          print(response.body);
          setState(() {
            prUser = new User(jsonDecode(response.body));
            isSheet = prJson["isSheet"];
            partName = prJson["partName"];
            partNumber = prJson["partNumber"];
            partQuantity = prJson["partQuantity"];
            vendor = prJson["vendor"];
            submittedOn = DateTime.parse(prJson["submittedOn"]);
            needBy = DateTime.parse(prJson["needBy"]);
            cost = prJson["cost"];
            totalCost = prJson["totalCost"];
            justification = prJson["justification"];
            partUrl = prJson["partUrl"];
            approved = prJson["approved"];
          });
        });
      }
      else {
        router.navigateTo(context, '/purchase-request', transition: TransitionType.fadeIn);
      }
    });
  }

  Future<void> getUser() async {
    await http.get("$dbHost/users/${_localStorage.containsKey("userID")}", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
      print(response.body);
      setState(() {
        currUser = new User(jsonDecode(response.body));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (html.window.location.toString().contains("?id=")) {
      print(html.window.location.toString().split("?id=")[1]);
      getPR(html.window.location.toString().split("?id=")[1]);
    }
    else {
      router.navigateTo(context, '/purchase-request', transition: TransitionType.fadeIn);
    }
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
                              new Text("Purchase Request", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                              new Padding(padding: EdgeInsets.all(16.0),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Text("Submitted By: ${prUser.firstName} ${prUser.lastName}", style: TextStyle(fontSize: 17.0),),
                                  new Text("Status: ${approved ? "Approved" : "Pending"}", style: TextStyle(fontSize: 17.0),),
                                ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text("Part Name", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text(partName, style: TextStyle(fontSize: 17.0),),
                                  new Padding(padding: EdgeInsets.all(8.0),),

                                  new Text("Part Number / SKU", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text(partNumber.toString(), style: TextStyle(fontSize: 17.0),),
                                  new Padding(padding: EdgeInsets.all(8.0),),

                                  new Text("Part Quantity", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text("$partQuantity", style: TextStyle(fontSize: 17.0),),
                                  new Padding(padding: EdgeInsets.all(8.0),),

                                  new Text("Part Url", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new GestureDetector(child: new Text(partUrl, style: TextStyle(fontSize: 17.0, color: mainColor),), onTap: () {launch(partUrl);}),
                                  new Padding(padding: EdgeInsets.all(8.0),),

                                  new Text("Vendor", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text(vendor, style: TextStyle(fontSize: 17.0),),
                                  new Padding(padding: EdgeInsets.all(8.0),),

                                  new Text("Cost per Item", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text("\$$cost", style: TextStyle(fontSize: 17.0),),
                                  new Padding(padding: EdgeInsets.all(8.0),),

                                  new Text("Total Cost", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text("\$$totalCost", style: TextStyle(fontSize: 17.0),),
                                  new Padding(padding: EdgeInsets.all(8.0),),

                                  new Text("Justification for Purchase", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text(justification, style: TextStyle(fontSize: 17.0),),
                                  new Padding(padding: EdgeInsets.all(8.0),),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Text("Submitted On", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text(DateFormat.yMd().format(submittedOn), style: TextStyle(fontSize: 17.0),),
                                  new Padding(padding: EdgeInsets.all(40.0),),
                                  new Text("Need By", style: TextStyle(fontSize: 20.0)),
                                  new Padding(padding: EdgeInsets.all(4.0),),
                                  new Text(DateFormat.yMd().format(needBy), style: TextStyle(fontSize: 17.0),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
                      new Visibility(
//                        visible: currUser.role == "Mentor" && !approved,
                        visible: true,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new RaisedButton(
                              child: new Text("Deny Purchase Request", style: TextStyle(fontSize: 20.0)),
                              elevation: 0.0,
                              color: Colors.red,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              onPressed: () async {
                              },
                            ),
                            new RaisedButton(
                              child: new Text("Approve Purchase Request", style: TextStyle(fontSize: 20.0)),
                              elevation: 0.0,
                              color: Colors.green,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              onPressed: () async {
                              },
                            ),
                          ],
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
