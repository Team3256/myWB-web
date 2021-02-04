import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_web/navbar/home_drawer.dart';
import 'package:mywb_web/navbar/home_footer.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class OutreachPage extends StatefulWidget {
  @override
  _OutreachPageState createState() => _OutreachPageState();
}

class _OutreachPageState extends State<OutreachPage> {
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
                      width: (MediaQuery.of(context).size.width > 1200) ? 1100 : MediaQuery.of(context).size.width - 100,
                      child: new SingleChildScrollView(
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Padding(padding: EdgeInsets.all(20),),
                              new Text("OUTREACH", style: TextStyle(fontSize: 40, color: mainColor, fontFamily: "Bebas Neue"),),
                              new Padding(padding: EdgeInsets.all(4),),
                              new Text(
                                  "The WarriorBorgs are a competitive robotics team from the AMSE (Applied Math, Science, and Engineering) Institute at Valley Christian High School in San Jose, California. We participate in the FIRST Robotics Competition, where students, with guidance from mentors, work to design, build, and program robots in a six-week timespan. Team members are exposed to a real-life engineering environment in which they acquire a variety of new skills which may include programming, mechanical design, electrical skills, presentation-giving and the management of business, etc.",
                                  style: TextStyle(fontSize: 20)
                              ),
                              new Padding(padding: EdgeInsets.all(12),),
                            ]
                        ),
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
          title: new Text("ABOUT", style: TextStyle(fontFamily: "Bebas Neue"),),
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
                )
              ]
          ),
        ),
      );
    }
  }
}
