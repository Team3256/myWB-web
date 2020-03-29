import 'dart:convert';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/models/event.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/pages/app_store_page.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  final Storage _localStorage = html.window.localStorage;

  User currUser = new User.plain();

  List<Widget> widgetList = new List();

  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  final GlobalKey<AnimatedCircularChartState> _chartKey2 = new GlobalKey<AnimatedCircularChartState>();

  List<Widget> eventsWidgetList = new List();
  List<Event> eventsList = new List();

  List<Widget> usersWidgetList = new List();
  List<User> usersList = new List();

  int practiceProgress = 0;
  int outreachProgress = 0;

  Event selectedEvent;

  Widget fabWidget = new Container();

  String checkInText = "";
  String checkOutText = "";

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

  Future<void> getAllUsers() async {
    setState(() {
      usersWidgetList.add(new Container(padding: EdgeInsets.all(8.0), width: double.infinity, child: new Text("Users", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center,)));
    });
    await http.get("$dbHost/users").then((response) async {
      print(response.body);
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (int i = 0; i < responseJson.length; i++) {
          User user = new User(responseJson[i]);
          int attendance = 0;
          setState(() {
            usersWidgetList.add(new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 0.0,
              child: new InkWell(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                onTap: () {
                  router.navigateTo(context, '/events/attendance?id=${user.id}', transition: TransitionType.fadeIn);
                },
                child: new Container(
                  padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: new Center(
                              child: new Text(
                                "$attendance%",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            width: 50.0,
                          ),
                          new Padding(padding: EdgeInsets.all(8.0)),
                          new Expanded(
                            child: new Container(
                              padding: EdgeInsets.all(4.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    user.firstName + " " + user.lastName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: currTextColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  new Padding(padding: EdgeInsets.all(1.0)),
                                  new Text(
                                    user.role,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: CupertinoColors.inactiveGray,
                                      fontSize: 14.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          new Icon(Icons.navigate_next, color: currDividerColor)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
            );
            usersWidgetList.add(new Padding(padding: EdgeInsets.all(4.0)));
          });
        }
      }
      else if (response.statusCode == 404) {
        print("USER NOT IN DB");
        _localStorage.remove("userID");
        await fb.auth().signOut();
        router.navigateTo(context, '/login', transition: TransitionType.fadeIn);
      }
    });
  }

  Future<void> getEvent() async {
    if (html.window.location.toString().contains("?id=")) {
      await http.get("$dbHost/events/${html.window.location.toString().split("?id=")[1]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
        print(response.body);
        setState(() {
          selectedEvent = new Event(jsonDecode(response.body));
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getEvent();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800 && _localStorage["userID"] != null) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Column(
          children: <Widget>[
            new HomeNavbar(),
            new Visibility(
              visible: currUser.firstName != "",
              child: new Expanded(
                child: new Container(
                  width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                  child: new SingleChildScrollView(
                    child: new Column(
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(8.0), width: double.infinity, child: new Text(selectedEvent.name, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, fontFamily: "Oswald"))),
                          new Padding(padding: EdgeInsets.all(4.0)),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                color: mainColor,
                                elevation: 6.0,
                                child: new Container(
                                  child: new Text(selectedEvent.type, style: TextStyle(color: Colors.white)),
                                  padding: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
                                ),
                              ),
                              new Text("${DateFormat("EEEE LLLL d, yyyy").format(selectedEvent.date)}")
                            ],
                          ),
                          new Padding(padding: EdgeInsets.all(4.0)),
                          new Text(
                            selectedEvent.desc,
                          ),
                          new Padding(padding: EdgeInsets.all(4.0)),
//                          new ClipRRect(
//                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
//                            child: new Container(
//                              height: 250,
//                              child: new GoogleMap(
//                                onMapCreated: _onMapCreated,
//                                myLocationButtonEnabled: true,
//                                myLocationEnabled: true,
//                                markers: _markers,
//                                initialCameraPosition: CameraPosition(
//                                    target: LatLng(selectedEvent.latitude, selectedEvent.longitude),
//                                    zoom: 14.0
//                                ),
//                              ),
//                            ),
//                          ),
                          new Padding(padding: EdgeInsets.all(4.0)),
                          new ListTile(
                            leading: new Text("Start Time"),
                            trailing: new Text("${DateFormat("jm").format(selectedEvent.startTime)}"),
                          ),
                          new ListTile(
                            leading: new Text("End Time"),
                            trailing: new Text("${DateFormat("jm").format(selectedEvent.endTime)}"),
                          ),
                          new Visibility(visible: (checkInText != ""), child: new Divider(color: mainColor, indent: 8.0, endIndent: 8.0)),
                          new Visibility(
                            visible: (checkInText != ""),
                            child: new ListTile(
                              leading: new Text("Check In Time"),
                              trailing: new Text(checkInText),
                            ),
                          ),
                          new Visibility(
                            visible: (checkOutText != ""),
                            child: new ListTile(
                              leading: new Text("Check Out Time"),
                              trailing: new Text(checkOutText),
                            ),
                          ),
                          new Visibility(visible: (checkOutText != ""), child: new Padding(padding: EdgeInsets.all(32.0))),
                          new Column(
                            children: usersWidgetList,
                          ),
                          new Padding(padding: EdgeInsets.all(32))
                        ]
                    ),
                  ),
                ),
              ),
            ),
            new Visibility(
              visible: currUser.firstName == "",
              child: new Container(
                width: 100,
                padding: EdgeInsets.all(32),
                child: new HeartbeatProgressIndicator(
                  child: new Image.asset(
                    'images/wblogo.png',
                    height: 25.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
      return new AppStorePage();
    }
  }
}
