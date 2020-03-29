import 'dart:convert';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:mywb_web/models/post.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_drawer.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Storage _localStorage = html.window.localStorage;

  VideoPlayerController _controller;

  String overlayText = "WE ARE THE WARRIORBORGS";

  User currUser = new User.plain();

  List<Widget> widgetList = new List();
  List<Post> postList = new List();

  Future<void> checkDiscord() async {
    if (_localStorage.containsKey("userID")) {
      await http.get("$dbHost/users/${_localStorage["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
        print(response.body);
        setState(() {
          currUser = new User(jsonDecode(response.body));
          populateHomePage();
        });
        if (response.statusCode == 200) {
          var userJson = jsonDecode(response.body);
          if (userJson["discordID"] == "404" || userJson["discordAuthToken"] == "404") {
            // Need to setup discord integration
            print("NEED TO SETUP DISCORD");
//            router.navigateTo(context, '/register/discord', transition: TransitionType.fadeIn);
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
  }

  Future<void> playVid() async {
    await Future.delayed(const Duration(milliseconds: 500));
    print("Play Vid");
    setState(() {
      _controller.setLooping(true);
      _controller.play();
    });
  }

  Future<void> populateHomePage() async {
    widgetList.clear();
    widgetList.add(new Padding(padding: EdgeInsets.all(16.0),));
    if (_localStorage.containsKey("userID")) {
      widgetList.add(new Container(padding: EdgeInsets.all(8.0), width: double.infinity, child: new Text("Welcome back, ${currUser.firstName}.", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, fontFamily: "Oswald"))));
      widgetList.add(new Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        color: currCardColor,
        child: new InkWell(
          onTap: () {
            router.navigateTo(context, '/purchase-request', transition: TransitionType.fadeIn);
          },
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Purchase Requests", style: TextStyle(fontSize: 20.0)),
              ],
            ),
          ),
        ),
      ));
      widgetList.add(new Padding(padding: EdgeInsets.all(8.0),));
      widgetList.add(new Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        color: currCardColor,
        child: new InkWell(
          onTap: () {
            router.navigateTo(context, '/attendance', transition: TransitionType.fadeIn);
          },
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Attendance", style: TextStyle(fontSize: 20.0)),
              ],
            ),
          ),
        ),
      ));
      widgetList.add(new Padding(padding: EdgeInsets.all(8.0),));
      widgetList.add(new Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        color: currCardColor,
        child: new InkWell(
          onTap: () {
            router.navigateTo(context, '/', transition: TransitionType.fadeIn);
          },
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Scouting", style: TextStyle(fontSize: 20.0)),
              ],
            ),
          ),
        ),
      ));
      widgetList.add(new Padding(padding: EdgeInsets.all(16.0),));
    }
    await http.get("$dbHost/posts").then((response) {
      var responseJson = jsonDecode(response.body);
      for (int i = 0; i < responseJson.length; i++) {
        Post post = new Post(responseJson[i]);
        if (post.tags.contains("Blog") && !post.tags.contains("Private")) {
          postList.add(post);
        }
      }
      postList.sort((a, b) {
        return a.date.compareTo(b.date);
      });
    });
    setState(() {
      widgetList.add(new Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        color: currCardColor,
        child: new Container(
          padding: EdgeInsets.only(top: 50, bottom: 16, right: 50, left: 50),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              new Text("LATEST POST", style: TextStyle(fontSize: 30.0, fontFamily: "Oswald", fontWeight: FontWeight.bold, color: mainColor)),
              new Padding(padding: EdgeInsets.all(4)),
              new InkWell(
                onTap: () {

                },
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: new Container(
                  padding: EdgeInsets.all(16),
                  child: new Column(
                    children: <Widget>[
                      new Text(postList.last.title, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                      new Padding(padding: EdgeInsets.all(8)),
                      new Text(
                        postList.last.body,
                        style: TextStyle(color: Colors.black26, fontSize: 15),
                        maxLines: 3,
                      )
                    ],
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.all(4)),
              new FlatButton(
                child: new Text("ALL POSTS", style: TextStyle(color: mainColor),),
                onPressed: () {

                },
              )
            ],
          ),
        ),
      ));
    });
    widgetList.add(new Padding(padding: EdgeInsets.all(8.0),));
    widgetList.add(new Text(appVersion.toString()));
    widgetList.add(new Padding(padding: EdgeInsets.all(16.0),));
  }

  @override
  void initState() {
    super.initState();
    checkDiscord();
    populateHomePage();
    _controller = VideoPlayerController.network('https://dl.dropboxusercontent.com/s/cao2gz57g1v0ch1/output.mp4?dl=0');
    _controller.initialize().then((_) => setState(() {}));
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
            if (_controller.value.isPlaying) {
              await Future.delayed(const Duration(seconds: 3));
              setState(() {
                overlayText = "";
              });
            }
            else {
              setState(() {
                overlayText = "WE ARE THE WARRIORBORGS";
              });
            }
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
        body: new Column(
          children: <Widget>[
            new HomeNavbar(),
            new Expanded(
              child: new SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16),
                      width: (MediaQuery.of(context).size.width > 1300) ? 1100 : MediaQuery.of(context).size.width - 50,
//                      height: 200,
                      child: _controller.value.initialized ? new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          child: ClipRect(
                            child: new Stack(
                              children: <Widget>[
                                AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                                new AspectRatio(aspectRatio: _controller.value.aspectRatio, child: Center(child: new Text(overlayText, style: TextStyle(fontFamily: "Oswald", fontSize: 50, color: Colors.white),)))
                              ],
                            ),
                          )
                      ) : new HeartbeatProgressIndicator(
                        child: new Image.asset(
                          'images/wblogo.png',
                          height: 25.0,
                        ),
                      ),
                    ),
                    new Container(
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: new SingleChildScrollView(
                        child: new Column(
                            children: widgetList
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Home", style: TextStyle(fontFamily: "Oswald"),),
          elevation: 0.0,
          backgroundColor: mainColor,
        ),
        drawer: new HomeDrawer(),
        backgroundColor: currBackgroundColor,
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(16),
                width: (MediaQuery.of(context).size.width > 1300) ? 1100 : MediaQuery.of(context).size.width - 50,
//                      height: 200,
                child: _controller.value.initialized ? new ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: ClipRect(
                      child: new Stack(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          new AspectRatio(aspectRatio: _controller.value.aspectRatio, child: Center(child: new Text(overlayText, style: TextStyle(fontFamily: "Oswald", fontSize: 50, color: Colors.white),)))
                        ],
                      ),
                    )
                ) : new HeartbeatProgressIndicator(
                  child: new Image.asset(
                    'images/wblogo.png',
                    height: 25.0,
                  ),
                ),
              ),
              new Container(
                width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                child: new SingleChildScrollView(
                  child: new Column(
                      children: widgetList
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
