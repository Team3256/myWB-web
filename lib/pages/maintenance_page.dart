import 'package:flutter/material.dart';
import 'package:mywb_web/navbar/home_footer.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'dart:html';
import 'package:fluro/fluro.dart';
import 'package:firebase/firebase.dart' as fb;
import 'dart:html' as html;

class MaintenancePage extends StatefulWidget {
  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {

  VideoPlayerController _controller;
  final Storage _localStorage = html.window.localStorage;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://vcrobotics.net/videos/FRC%202019%20Bag%20Day.mp4');
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
    return Scaffold(
      backgroundColor: mainColor,
      body: new Container(
        color: mainColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _controller.value.initialized ? new Stack(
          alignment: Alignment.center,
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
              color: mainColor.withOpacity(0.5),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(32),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width > 800 ? 700 : MediaQuery.of(context).size.width - 16,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Text(
                        "We'll be right back...",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width > 550 ? 65 : 35, color: Colors.white),
                      ),
                      new Padding(padding: EdgeInsets.all(16)),
                      new Text(
                        "We are working very hard on our new site. It will bring a lot of new features and content, so stay tuned!\n\nIf you require immediate access to myWB or any of our other internal tools, please reach out to robotics@warriorlife.net",
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width > 550 ? 25 : 17, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                new Container(
                  padding: EdgeInsets.all(32),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          width: 300,
                          child: new Image.asset(
                            "images/WB_Website_Banner.png",
                            fit: BoxFit.fitHeight,
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: MediaQuery.of(context).size.width >= 800,
              child: new Container(
                width: MediaQuery.of(context).size.width - 128,
                height: MediaQuery.of(context).size.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new Expanded(
                      child: new Container()
                    ),
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 12),
                            child: new Text("FOLLOW US", style: TextStyle(fontFamily: "Bebas Neue", fontSize: 35, color: Colors.white),)
                          ),
                          new Wrap(
                            children: [
                              new IconButton(
                                icon: Image.asset("images/linkedin-social.png", color: Colors.white),
                                iconSize: 40,
                                onPressed: () {
                                  launch("https://www.linkedin.com/company/18620955");
                                },
                              ),
                              new IconButton(
                                icon: Image.asset("images/instagram-social.png", color: Colors.white),
                                iconSize: 40,
                                onPressed: () {
                                  launch("https://instagram.com/warriorborgs");
                                },
                              ),
                              new IconButton(
                                icon: Image.asset("images/twitter-social.png", color: Colors.white),
                                iconSize: 40,
                                onPressed: () {
                                  launch("https://twitter.com/warriorborgs");
                                },
                              ),
                              new IconButton(
                                icon: Image.asset("images/youtube-social.png", color: Colors.white),
                                iconSize: 40,
                                onPressed: () {
                                  launch("https://www.youtube.com/channel/UCDTTbG3EDz7G_ZvsicbJ6Pg");
                                },
                              ),
                            ],
                          ),
                          new Padding(padding: EdgeInsets.all(32))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: MediaQuery.of(context).size.width >= 800,
              child: new Container(
                padding: EdgeInsets.only(left: 32, bottom: 8, right: 32),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new FlatButton(
                          child: new Text("COPYRIGHT © 2020 WARRIORBORGS 3256"),
                          textColor: Colors.white,
                          onPressed: () {
                            launch("https://github.com/team3256");
                          },
                        ),
                        Row(
                          children: [
                            new FlatButton(
                              child: new Text("v${appVersion.toString()}"),
                              textColor: Colors.white,
                              onPressed: () {

                              },
                            ),
                            new FlatButton(
                              child: new Text("AMSE INSTITUTE"),
                              textColor: Colors.white,
                              onPressed: () {
                                launch("https://amse.vcs.net");
                              },
                            ),
                            new FlatButton(
                              child: new Text("DOCS"),
                              textColor: Colors.white,
                              onPressed: () {
                                launch("https://docs.vcrobotics.net");
                              },
                            ),
                            new FlatButton(
                              child: new Text("STATUS"),
                              textColor: Colors.white,
                              onPressed: () {
                                launch("https://status.bk1031.dev");
                              },
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: MediaQuery.of(context).size.width < 800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new Text("FOLLOW US", style: TextStyle(fontFamily: "Bebas Neue", fontSize: 35, color: Colors.white),),
                  new Wrap(
                    children: [
                      new IconButton(
                        icon: Image.asset("images/linkedin-social.png", color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          launch("https://www.linkedin.com/company/18620955");
                        },
                      ),
                      new IconButton(
                        icon: Image.asset("images/instagram-social.png", color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          launch("https://instagram.com/warriorborgs");
                        },
                      ),
                      new IconButton(
                        icon: Image.asset("images/twitter-social.png", color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          launch("https://twitter.com/warriorborgs");
                        },
                      ),
                      new IconButton(
                        icon: Image.asset("images/youtube-social.png", color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          launch("https://www.youtube.com/channel/UCDTTbG3EDz7G_ZvsicbJ6Pg");
                        },
                      ),
                    ],
                  ),
                  new Padding(padding: EdgeInsets.all(8)),
                  new Container(
                    child: new Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        new FlatButton(
                          child: new Text("v${appVersion.toString()}"),
                          textColor: Colors.white,
                          onPressed: () {

                          },
                        ),
                        new FlatButton(
                          child: new Text("AMSE INSTITUTE"),
                          textColor: Colors.white,
                          onPressed: () {
                            launch("https://amse.vcs.net");
                          },
                        ),
                        new FlatButton(
                          child: new Text("DOCS"),
                          textColor: Colors.white,
                          onPressed: () {
                            launch("https://docs.vcrobotics.net");
                          },
                        ),
                        new FlatButton(
                          child: new Text("STATUS"),
                          textColor: Colors.white,
                          onPressed: () {
                            launch("https://status.bk1031.dev");
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: new FlatButton(
                      child: new Text("COPYRIGHT © 2020 WARRIORBORGS 3256"),
                      textColor: Colors.white,
                      onPressed: () {
                        launch("https://github.com/team3256");
                      },
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(8)),
                ],
              ),
            )
          ],
        ) : Center(
          child: Container(
            width: 200,
            height: 200,
            padding: EdgeInsets.all(16),
            child: new Image.asset(
              'images/WB_Loading.gif',
            ),
          ),
        ),
      ),
    );
  }
}
