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
import 'package:mywb_web/navbar/home_footer.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Storage _localStorage = html.window.localStorage;

  VideoPlayerController _controller;

  String overlayText = "WE ARE THE WARRIORBORGS";

  List<Widget> widgetList = new List();
  List<Post> postList = new List();

  Future<void> checkDiscord() async {
    if (_localStorage.containsKey("userID")) {
      await http.get("$dbHost/users/${_localStorage["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
        print(response.body);
        setState(() {
          currUser = new User.fromJson(jsonDecode(response.body));
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
    _controller = VideoPlayerController.network('https://vcrobotics.net/videos/FRC%202019.mp4');
    _controller.initialize().then((_) => setState(() {}));
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _controller.play();
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Column(
          children: <Widget>[
            new HomeNavbar(),
            new Expanded(
              child: new SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 300,
                      child: _controller.value.initialized ? new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          child: new Stack(
                            alignment: Alignment.bottomLeft,
                            children: <Widget>[
                              SizedBox.expand(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _controller.value.size?.width ?? 0,
                                    height: _controller.value.size?.height ?? 0,
                                    child: VideoPlayer(_controller),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: mainColor.withOpacity(0.3),
                              ),
                              Container(
                                padding: EdgeInsets.all(32),
                                child: new Text("We are the WarriorBorgs.", style: TextStyle(fontSize: 65, color: Colors.white),)
                              )
                            ],
                          )
                      ) : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        child: Container(
                          color: Colors.black,
                          child: Center(
                            child: new Image.asset(
                              'images/WB_Loading.gif',
                              height: 100,
                            ),
                          ),
                        ),
                      )
                    ),
                    new Container(
                      width: (MediaQuery.of(context).size.width > 1200) ? 1100 : MediaQuery.of(context).size.width - 100,
                      child: new SingleChildScrollView(
                        child: new Column(
                          children: [
                            new Padding(padding: EdgeInsets.all(32),),
                            Center(child: new Text("We are an FRC Team located at Valley Christian High School.", style: TextStyle(fontSize: 40, color: mainColor), textAlign: TextAlign.center,)),
                            new Padding(padding: EdgeInsets.all(16),),
                            new Container(
                              width: double.infinity,
                              child: new Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  new Container(
                                    child: new Column(
                                      children: [
                                        new Text("47", style: TextStyle(fontSize: 70, color: mainColor),),
                                        new Padding(padding: EdgeInsets.all(6),),
                                        new Text("Members", style: TextStyle(fontSize: 25),),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    child: new Column(
                                      children: [
                                        new Text("42", style: TextStyle(fontSize: 70, color: mainColor),),
                                        new Padding(padding: EdgeInsets.all(6),),
                                        new Text("Competitions", style: TextStyle(fontSize: 25),),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    child: new Column(
                                      children: [
                                        new Text("12", style: TextStyle(fontSize: 70, color: mainColor),),
                                        new Padding(padding: EdgeInsets.all(6),),
                                        new Text("Years", style: TextStyle(fontSize: 25),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(32),),
                    new Container(
                      padding: EdgeInsets.all(64),
                      width: MediaQuery.of(context).size.width - 64,
                      child: new Row(
                        children: [
                          new Expanded(
                            child: Center(
                              child: new Container(
                                padding: EdgeInsets.all(32),
                                  child: new Image.asset(
                                    "images/WB_Logo_Blue.png",
                                    fit: BoxFit.contain,
                                    height: 150,
                                    width: 450,
                                  )
                              ),
                            ),
                          ),
                          new Expanded(
                            child: Center(
                              child: new Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text("WARRIORBORGS", style: TextStyle(fontFamily: "Bebas Neue", fontSize: 40),),
                                    new Padding(padding: EdgeInsets.all(8),),
                                    new Text(
                                        "As a continuously learning community, We, the WarriorBorgs, seek to conceive creative and innovative methods to spread the FIRST message of STEM through not only the building of robots, but also the building of teams.",
                                        style: TextStyle(fontSize: 20)
                                    ),
                                    new Padding(padding: EdgeInsets.all(8),),
                                    new RaisedButton(
                                      onPressed: () {
                                        router.navigateTo(context, "/about", transition: TransitionType.fadeIn);
                                      },
                                      elevation: 0,
                                      color: mainColor,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                      child: new Text("ABOUT US"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(64),
                      width: MediaQuery.of(context).size.width - 64,
                      child: new Row(
                        children: [
                          new Expanded(
                            child: Center(
                              child: new Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text("FIRST", style: TextStyle(fontFamily: "Bebas Neue", fontSize: 40),),
                                    new Padding(padding: EdgeInsets.all(8),),
                                    new Text(
                                        "FIRST: For the Inspiration and Recognition of Science and Technology. Dean Kamen founded FIRST, in 1989, with an ultimate vision and goal to create a culture in America where young students celebrate science and technology.",
                                        style: TextStyle(fontSize: 20)
                                    ),
                                    new Padding(padding: EdgeInsets.all(8),),
                                    new RaisedButton(
                                      onPressed: () {
                                        launch("https://www.firstinspires.org/");
                                      },
                                      elevation: 0,
                                      color: mainColor,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                      child: new Text("LEARN MORE"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          new Expanded(
                            child: Center(
                              child: new Container(
                                  padding: EdgeInsets.all(32),
                                  child: new Image.asset(
                                    "images/first-logo.png",
                                    fit: BoxFit.contain,
                                    height: 250,
                                    width: 450,
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(64),
                      width: MediaQuery.of(context).size.width - 64,
                      child: new Row(
                        children: [
                          new Expanded(
                            child: Center(
                              child: new Container(
                                  padding: EdgeInsets.all(32),
                                  child: new Image.asset(
                                    "images/valley-logo.png",
                                    fit: BoxFit.contain,
                                    height: 250,
                                    width: 450,
                                  )
                              ),
                            ),
                          ),
                          new Expanded(
                            child: Center(
                              child: new Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text("VALLEY CHRISTIAN SCHOOLS", style: TextStyle(fontFamily: "Bebas Neue", fontSize: 40),),
                                    new Padding(padding: EdgeInsets.all(8),),
                                    new Text(
                                        "VCS's mission is to provide a nurturing environment offering quality education supported by a strong foundation of Christian values in partnership with parents, equipping students to become leaders to serve God, to serve their families, and to positively impact their communities and the world.",
                                        style: TextStyle(fontSize: 20)
                                    ),
                                    new Padding(padding: EdgeInsets.all(8),),
                                    new RaisedButton(
                                      onPressed: () {
                                        launch("https://vcs.net");
                                      },
                                      elevation: 0,
                                      color: mainColor,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                      child: new Text("LEARN MORE"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: new Column(
                      ),
                    ),
                    new Container(height: 100),
                    new HomeFooter()
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
          title: new Text("HOME", style: TextStyle(fontFamily: "Bebas Neue"),),
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
                child: new Column(),
              )
            ],
          ),
        ),
      );
    }
  }
}
