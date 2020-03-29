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

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

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

  Future<void> getUser() async {
    if (_localStorage.containsKey("userID")) {
      if (html.window.location.toString().contains("?id=")) {
        await http.get("$dbHost/users/${html.window.location.toString().split("?id=")[1]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          if (response.statusCode == 200) {
            setState(() {
              currUser = new User(jsonDecode(response.body));
            });
            getEvents();
          }
          else if (response.statusCode == 404) {
            print("USER NOT IN DB");
            router.navigateTo(context, '/attendance', transition: TransitionType.fadeIn);
          }
        });
      }
      else {
        await http.get("$dbHost/users/${_localStorage["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          if (response.statusCode == 200) {
            setState(() {
              currUser = new User(jsonDecode(response.body));
            });
            getEvents();
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
          int attendance = await getAttendanceVal(user.id);
          setState(() {
            usersWidgetList.add(new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 0.0,
              child: new InkWell(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                onTap: () {
                  router.navigateTo(context, '/attendance?id=${user.id}', transition: TransitionType.fadeIn);
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

  Future<void> getEvents() async {
    await http.get("$dbHost/events", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      print(DateTime.now());
      eventsList.clear();
      eventsWidgetList.clear();
      double requiredPractice = 0;
      var eventsJson = jsonDecode(response.body);
      await http.get("$dbHost/users/${currUser.id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
        print(response.body);
        var excusedJson = jsonDecode(response.body);
        for (int i = 0; i < eventsJson.length; i++) {
          Event event = new Event(eventsJson[i]);
          print(event.date);
          setState(() {
            eventsList.add(event);
          });
          if (event.endTime.compareTo(DateTime.now()) < 0 && event.type == "practice") {
            print(event.endTime.difference(event.startTime).inMilliseconds / 3600000);
            requiredPractice += event.endTime.difference(event.startTime).inMilliseconds / 3600000;
            for (int i = 0; i < excusedJson.length; i++) {
              if (excusedJson[i]["eventID"] == event.id && excusedJson[i]["status"] == "verified") {
                print("EXCUSED");
                requiredPractice -= event.endTime.difference(event.startTime).inMilliseconds / 3600000;
              }
            }
          }
        }
        print("REQUIRED HOURS FOR USER: " + requiredPractice.toString());
        getAttendance(requiredPractice);
        eventsList.sort((a, b) {
          return a.date.compareTo(b.date);
        });
        getEventsList();
      });
    });
  }

  Future<void> getAttendance(double requiredPractice) async {
    await http.get("$dbHost/users/${currUser.id}/attendance", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      double outreachHours = 0;
      double practiceHours = 0;
      var responseJson = jsonDecode(response.body);
      for (int i = 0; i < responseJson.length; i++) {
        if (responseJson[i]["type"] == "outreach") {
          outreachHours += responseJson[i]["hours"];
        }
        else if (responseJson[i]["type"] == "practice") {
          practiceHours += responseJson[i]["hours"];
        }
      }
      print("OUTREACH PROGRESS: ${outreachHours / 50.0 * 100}%");
      print("ATTENDANCE: ${practiceHours / requiredPractice * 100}%");
      setState(() {
        outreachProgress = (outreachHours / 50.0 * 100).round();
        print(outreachProgress.toString());
        practiceProgress = (practiceHours / requiredPractice * 100).round();
        print(practiceProgress.toString());
        Color outreachColor = Colors.blueGrey[600];
        Color practiceColor = Colors.blueGrey[600];
        if (practiceProgress < 75) {
          practiceColor = Colors.red;
        }
        else if (practiceProgress < 90) {
          practiceColor = Colors.orange;
        }
        else {
          practiceColor = Colors.lightGreen;
        }
        if (outreachProgress < 75) {
          outreachColor = Colors.red;
        }
        else if (outreachProgress < 90) {
          outreachColor = Colors.orange;
        }
        else {
          outreachColor = Colors.lightGreen;
        }
        _chartKey.currentState.updateData(<CircularStackEntry>[
          new CircularStackEntry(
            <CircularSegmentEntry>[
              new CircularSegmentEntry(practiceProgress.toDouble(), practiceColor, rankKey: 'done'),
              new CircularSegmentEntry(100 - practiceProgress.toDouble(), Colors.blueGrey[600], rankKey: 'remaining'),
            ],
          ),
        ]);
        _chartKey2.currentState.updateData(<CircularStackEntry>[
          new CircularStackEntry(
            <CircularSegmentEntry>[
              new CircularSegmentEntry(outreachProgress.toDouble(), outreachColor, rankKey: 'done'),
              new CircularSegmentEntry(100 - outreachProgress.toDouble(), Colors.blueGrey[600], rankKey: 'remaining'),
            ],
          ),
        ]);
      });
    });
  }

  Future<int> getAttendanceVal(String id) async {
    double requiredPractice = 0;
    await http.get("$dbHost/events", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var eventsJson = jsonDecode(response.body);
      await http.get("$dbHost/users/${id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
        print(response.body);
        var excusedJson = jsonDecode(response.body);
        for (int i = 0; i < eventsJson.length; i++) {
          Event event = new Event(eventsJson[i]);
          if (event.endTime.compareTo(DateTime.now()) < 0 && event.type == "practice") {
            print(event.endTime.difference(event.startTime).inMilliseconds / 3600000);
            requiredPractice += event.endTime.difference(event.startTime).inMilliseconds / 3600000;
            for (int i = 0; i < excusedJson.length; i++) {
              if (excusedJson[i]["eventID"] == event.id && excusedJson[i]["status"] == "verified") {
                print("EXCUSED");
                requiredPractice -= event.endTime.difference(event.startTime).inMilliseconds / 3600000;
              }
            }
          }
        }
        print("REQUIRED HOURS FOR USER: " + requiredPractice.toString());
      });
    });
    double outreachHours = 0;
    double practiceHours = 0;
    await http.get("$dbHost/users/${id}/attendance", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var responseJson = jsonDecode(response.body);
      for (int i = 0; i < responseJson.length; i++) {
        if (responseJson[i]["type"] == "outreach") {
          outreachHours += responseJson[i]["hours"];
        }
        else if (responseJson[i]["type"] == "practice") {
          practiceHours += responseJson[i]["hours"];
        }
      }
      print("OUTREACH PROGRESS: ${outreachHours / 50.0 * 100}%");
      print("ATTENDANCE: ${practiceHours / requiredPractice * 100}%");
    });
    return (practiceHours / requiredPractice * 100).round();
  }

  Future<void> getEventsList() async {
    print("GET ALL EVENTS");
    setState(() {
      eventsWidgetList.clear();
      eventsList.clear();
      eventsWidgetList.add(new Container(padding: EdgeInsets.all(8.0), width: double.infinity, child: new Text("Events", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center,)));
    });
    await http.get("$dbHost/events", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var eventsJson = jsonDecode(response.body);
      for (int i = 0; i < eventsJson.length; i++) {
        Event event = new Event(eventsJson[i]);
        eventsList.add(event);
        print(event.id);
      }
      eventsList.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      for (Event event in eventsList) {
        await http.get("$dbHost/users/${currUser.id}/attendance/${event.id}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          var responseJson = jsonDecode(response.body);
          Color statusColor;
          if (responseJson["message"] != null && event.endTime.compareTo(DateTime.now()) < 0 && event.type == "practice") {
            print("NOT ATTENDED");
            statusColor = Colors.red;
            await http.get("$dbHost/users/${currUser.id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
              var excusedJson = jsonDecode(response.body);
              for (int i = 0; i < excusedJson.length; i++) {
                if (excusedJson[i]["eventID"] == event.id && excusedJson[i]["status"] == "verified") {
                  print("EXCUSED ABSENCE FOR ${event.id}");
                  statusColor = Colors.green;
                }
              }
            });
          }
          else if (responseJson["message"] != null) {
            print("UPCOMING");
            statusColor = Colors.grey;
          }
          else if (responseJson["checkIn"] == responseJson["checkOut"]) {
            print("CURRENT EVENT");
            statusColor = mainColor;
          }
          else {
            print("EVENT ATTENDED");
            statusColor = Colors.green;
          }
          setState(() {
            eventsWidgetList.add(
                new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 0.0,
                  child: new InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onTap: () {
                      router.navigateTo(context, '/events?id=${event.id}', transition: TransitionType.fadeIn);
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
                                    DateFormat('M/d').format(event.date),
                                    style: TextStyle(
                                        color: statusColor,
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
                                        event.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: currTextColor,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      new Padding(padding: EdgeInsets.all(1.0)),
                                      new Text(
                                        event.desc,
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
            eventsWidgetList.add(new Padding(padding: EdgeInsets.all(4.0)));
          });
        });
      }
    });
    for (Widget widget in eventsWidgetList) {
      print(widget.runtimeType);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
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
                        new Container(padding: EdgeInsets.all(8.0), width: double.infinity, child: new Text("${currUser.firstName}'s Attendance", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, fontFamily: "Oswald"))),
                        new Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                          color: currCardColor,
                          elevation: 0.0,
                          child: new InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            child: new Container(
                              height: 200,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new AnimatedCircularChart(
                                    key: _chartKey,
                                    size: const Size(200, 200),
                                    initialChartData: <CircularStackEntry>[
                                      new CircularStackEntry(
                                        <CircularSegmentEntry>[
                                          new CircularSegmentEntry(
                                            0.0,
                                            Colors.blue[400],
                                            rankKey: 'completed',
                                          ),
                                          new CircularSegmentEntry(
                                            100.0,
                                            Colors.blueGrey[600],
                                            rankKey: 'remaining',
                                          ),
                                        ],
                                        rankKey: 'progress',
                                      ),
                                    ],
                                    chartType: CircularChartType.Radial,
                                    percentageValues: true,
                                    holeLabel: '$practiceProgress%',
                                    labelStyle: new TextStyle(
                                      color: Colors.blueGrey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                  new AnimatedCircularChart(
                                    key: _chartKey2,
                                    size: const Size(200, 200),
                                    initialChartData: <CircularStackEntry>[
                                      new CircularStackEntry(
                                        <CircularSegmentEntry>[
                                          new CircularSegmentEntry(
                                            0.0,
                                            Colors.blue[400],
                                            rankKey: 'completed',
                                          ),
                                          new CircularSegmentEntry(
                                            100.0,
                                            Colors.blueGrey[600],
                                            rankKey: 'remaining',
                                          ),
                                        ],
                                        rankKey: 'progress',
                                      ),
                                    ],
                                    chartType: CircularChartType.Radial,
                                    percentageValues: true,
                                    holeLabel: '$outreachProgress%',
                                    labelStyle: new TextStyle(
                                      color: Colors.blueGrey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Visibility(
                              visible: currUser.role != "Member",
                              child: new Expanded(
                                child: new Column(
                                  children: usersWidgetList,
                                ),
                              ),
                            ),
                            new Expanded(
                              child: new Column(
                                children: eventsWidgetList,
                              ),
                            )
                          ],
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
