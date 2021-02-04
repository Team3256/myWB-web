import 'package:flutter/material.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeFooter extends StatefulWidget {
  @override
  _HomeFooterState createState() => _HomeFooterState();
}

class _HomeFooterState extends State<HomeFooter> {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
      return Container(
          width: double.infinity,
          height: 500,
          child: new Stack(
            children: [
              new Image.asset("images/2020 TEAM_FINAL.png", fit: BoxFit.cover, width: double.infinity, height: 500,),
              Container(color: mainColor.withOpacity(0.5), width: double.infinity, height: 500),
              Center(
                child: new Container(
                  width: MediaQuery.of(context).size.width - 128,
                  height: 400,
                  child: Row(
                    children: [
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Image.asset("images/3256_WarriorBorgs.png", height: 200,),
                            Container(
                              width: (MediaQuery.of(context).size.width - 128),
                              padding: EdgeInsets.only(left: 28, top: 32),
                              child: new Text(
                                "The WarriorBorgs inspire motivation and respect for the pursuit of Science, Technology, Engineering, and Mathematics (STEM) through innovative outreach centered around generating excitement among children about robotics, and through hands-on, collaborative learning that equips students with the technical skills and experiences they need to succeed in college and their future careers. We are on a Quest for Excellence™, and dedicate all that we do to God.",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                            new Padding(padding: EdgeInsets.all(16))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
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
            ],
          )
      );
    }
    else {
      return Container(
          width: double.infinity,
          height: 350,
          child: new Stack(
            children: [
              new Image.asset("images/2020 TEAM_FINAL.png", fit: BoxFit.cover, width: double.infinity, height: 350,),
              Container(color: mainColor.withOpacity(0.5), width: double.infinity, height: 350),
              Center(
                child: new Container(
                  padding: EdgeInsets.all(16),
                  height: 350,
                  child: Column(
                    children: [
                      new Image.asset("images/WB_Logo_White.png", height: 75,),
                      new Padding(padding: EdgeInsets.all(16)),
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
                    ],
                  ),
                ),
              ),
            ],
          )
      );
    }
  }
}
