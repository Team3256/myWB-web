import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:firebase/firebase.dart' as fb;
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

  String id;

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
  String status = "";

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
            status = prJson["status"];
          });
        });
      }
      else {
        router.navigateTo(context, '/purchase-request', transition: TransitionType.fadeIn);
      }
    });
  }

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

  @override
  void initState() {
    super.initState();
    if (html.window.location.toString().contains("?id=")) {
      print(html.window.location.toString().split("?id=")[1]);
      id = html.window.location.toString().split("?id=")[1];
      getUser();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(16.0),),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new FlatButton(
                            child: new Text("Back to Purchase Requests", style: TextStyle(color: mainColor),),
                            onPressed: () {
                              router.navigateTo(context, '/purchase-request', transition: TransitionType.fadeIn);
                            },
                          ),
                          new FlatButton(
                            child: new Text("Copy to Clipboard", style: TextStyle(color: mainColor),),
                            onPressed: () {
                              if (!isSheet) {
                                Clipboard.setData(ClipboardData(text: "Part Name: $partName\n\nPart Number: $partNumber\n\nQuantity: $partQuantity\n\nPart Url: $partUrl\n\nVendor: $vendor\n\nCost per Item: \$$cost\n\nTotal Cost: \$$totalCost\n\nJustification for Purchase: $justification"));
                              }
                              else {
                                Clipboard.setData(ClipboardData(text: "Part Sheet URL: $partUrl"));
                              }
                            },
                          ),
                        ],
                      ),
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
                                  new Text("Submitted By: ${prUser.firstName} ${prUser.lastName} (${prUser.role})", style: TextStyle(fontSize: 17.0),),
                                  new Text("Status: ${status=="approved" ? "Approved" : status=="pending" ? "Pending" : "Denied"}", style: TextStyle(fontSize: 17.0),),
                                ],
                              )
                            ],
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Expanded(
                                  flex: 4,
                                  child: new Column(
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
                                      new GestureDetector(child: new Text(partUrl.length > 50 ? partUrl.substring(0, 50) + "..." : partUrl, style: TextStyle(fontSize: 17.0, color: mainColor),), onTap: () {launch(partUrl);}),
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
                                      new Text(justification, style: TextStyle(fontSize: 17.0)),
                                      new Padding(padding: EdgeInsets.all(8.0),),
                                    ],
                                  ),
                                ),
                                new Expanded(
                                  flex: 1,
                                  child: new Column(
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Visibility(
                        visible: isSheet,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                new Text("PR Sheet Url", style: TextStyle(fontSize: 20.0)),
                                new Padding(padding: EdgeInsets.all(4.0),),
                                new GestureDetector(child: new Text(partUrl.length > 50 ? partUrl.substring(0, 50) + "..." : partUrl, style: TextStyle(fontSize: 17.0, color: mainColor),), onTap: () {launch(partUrl);}),
                                new Padding(padding: EdgeInsets.all(8.0),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
                      new Visibility(
                        visible: currUser.role == "Mentor" || currUser.perms.contains("DEV"),
//                        visible: true,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Visibility(
                              visible: status != "denied",
                              child: new RaisedButton(
                                child: new Text("Deny Purchase Request", style: TextStyle(fontSize: 20.0)),
                                elevation: 0.0,
                                color: Colors.red,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                onPressed: () async {
                                  await cycleApiKey().then((value) {
                                    http.post("$dbHost/purchase-requests/${id}/status/denied", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
                                      if (response.statusCode == 200) {
                                        // epic it worked!
                                        if (isSheet) {
                                          await http.post(prDiscordUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
                                            "content": "<@${prUser.discordID}> your PR Sheet was **denied**! Please see Mr. Diep for more details.\n<http://vcrobotics.net/#/purchase-request/view?id=${id}>"
                                          })).then((response) {
                                            html.window.open("mailto:mfonda@vcs.net?subject=Robotics%20Order%20-%20namePart&body=Part%20Sheet%3A%20${partUrl.replaceAll(" ", "%20")}", "PR Email");
                                            html.window.location.reload();
                                          });
                                        }
                                        else {
                                          await http.post(prDiscordUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
                                            "content": "<@${prUser.discordID}> your purchase request for $partName was **denied**! Please see Mr. Diep for more details.\n<http://vcrobotics.net/#/purchase-request/view?id=${id}>"
                                          })).then((response) {
                                            html.window.location.reload();
                                          });
                                        }
                                      }
                                      else {
                                        html.window.alert(response.body);
                                      }
                                    });
                                  });
                                },
                              ),
                            ),
                            new Visibility(
                              visible: status != "approved",
                              child: new RaisedButton(
                                child: new Text("Approve Purchase Request", style: TextStyle(fontSize: 20.0)),
                                elevation: 0.0,
                                color: Colors.green,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                onPressed: () async {
                                  await cycleApiKey().then((value) {
                                    http.post("$dbHost/purchase-requests/${id}/status/approved", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
                                      if (response.statusCode == 200) {
                                        // epic it worked!
                                        if (isSheet) {
                                          await http.post(prDiscordUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
                                            "content": "<@${prUser.discordID}> your PR Sheet was **approved**!\n<http://vcrobotics.net/#/purchase-request/view?id=${id}>"
                                          })).then((response) {
//                                          html.window.open("mailto:mfonda@vcs.net?subject=Robotics%20Order%20-%20Sheet&body=Part%20Sheet%3A%20${partUrl.replaceAll(" ", "%20")}", "PR Email");
                                            html.window.open("https://mail.google.com/mail/u/1/?view=cm&fs=1&to=mfonda@vcs.net&su=Robotics%20Order%20-%20Sheet&body=Part%20Sheet%3A%20${partUrl.replaceAll(" ", "%20")}%0D%0A%0D%0A&tf=1", "PR Email");
                                            html.window.location.reload();
                                          });
                                        }
                                        else {
                                          await http.post(prDiscordUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
                                            "content": "<@${prUser.discordID}> your purchase request for $partName was **approved**!\n<http://vcrobotics.net/#/purchase-request/view?id=${id}>"
                                          })).then((response) {
                                            // https://mail.google.com/mail/u/0/?view=cm&fs=1&to=mfonda@vcs.net&su=Robotics%20Order%20-%20${partName.replaceAll(" ", "%20")}&body=Part%20Name%3A%20${partName.replaceAll(" ", "%20")}%0D%0A%0D%0APart%20%23%3A%20${partNumber.replaceAll(" ", "%20")}%0D%0A%0D%0AQuantity%3A%20${partQuantity.toString()}%0D%0A%0D%0APart%20Url%3A%20${partUrl.replaceAll(" ", "%20")}%0D%0A%0D%0AVendor%3A%20${vendor.replaceAll(" ", "%20")}%0D%0A%0D%0ACost%20per%20Item%3A%20${("\$$cost").replaceAll(" ", "%20")}%0D%0A%0D%0ATotal%20Cost%3A%20${("\$$totalCost").replaceAll(" ", "%20")}%0D%0A%0D%0AJustification%20for%20Purchase%3A%20${justification.replaceAll(" ", "%20")}&tf=1
//                                          html.window.open("mailto:mfonda@vcs.net?subject=Robotics%20Order%20-%20namePart&body=Part%20Name%3A%20${partName.replaceAll(" ", "%20")}%0D%0A%0D%0APart%20%23%3A%20${partNumber.replaceAll(" ", "%20")}%0D%0A%0D%0AQuantity%3A%20${partQuantity.toString()}%0D%0A%0D%0APart%20Url%3A%20${partUrl.replaceAll(" ", "%20")}%0D%0A%0D%0AVendor%3A%20${vendor.replaceAll(" ", "%20")}%0D%0A%0D%0ACost%20per%20Item%3A%20${("\$$cost").replaceAll(" ", "%20")}%0D%0A%0D%0ATotal%20Cost%3A%20${("\$$totalCost").replaceAll(" ", "%20")}%0D%0A%0D%0AJustification%20for%20Purchase%3A%20${justification.replaceAll(" ", "%20")}", "PR Email");
                                            html.window.open("https://mail.google.com/mail/u/1/?view=cm&fs=1&to=mfonda@vcs.net&su=Robotics%20Order%20-%20${partName.replaceAll(" ", "%20")}&body=Part%20Name%3A%20${partName.replaceAll(" ", "%20")}%0D%0A%0D%0APart%20%23%3A%20${partNumber.replaceAll(" ", "%20")}%0D%0A%0D%0AQuantity%3A%20${partQuantity.toString()}%0D%0A%0D%0APart%20Url%3A%20${partUrl.replaceAll(" ", "%20")}%0D%0A%0D%0AVendor%3A%20${vendor.replaceAll(" ", "%20")}%0D%0A%0D%0ACost%20per%20Item%3A%20${("\$$cost").replaceAll(" ", "%20")}%0D%0A%0D%0ATotal%20Cost%3A%20${("\$$totalCost").replaceAll(" ", "%20")}%0D%0A%0D%0AJustification%20for%20Purchase%3A%20${justification.replaceAll(" ", "%20")}&tf=1", "PR Email");
                                            html.window.location.reload();
                                          });
                                        }
                                      }
                                      else {
                                        html.window.alert(response.body);
                                      }
                                    });
                                  });
                                },
                              ),
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
