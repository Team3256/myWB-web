import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_web/navbar/home_drawer.dart';
import 'package:mywb_web/navbar/home_footer.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
                            new Text("ABOUT US", style: TextStyle(fontSize: 40, color: mainColor, fontFamily: "Bebas Neue"),),
                            new Padding(padding: EdgeInsets.all(4),),
                            new Text(
                              "The WarriorBorgs are a competitive robotics team from the AMSE (Applied Math, Science, and Engineering) Institute at Valley Christian High School in San Jose, California. We participate in the FIRST Robotics Competition, where students, with guidance from mentors, work to design, build, and program robots in a six-week timespan. Team members are exposed to a real-life engineering environment in which they acquire a variety of new skills which may include programming, mechanical design, electrical skills, presentation-giving and the management of business, etc.",
                              style: TextStyle(fontSize: 20)
                            ),
                            new Padding(padding: EdgeInsets.all(12),),
                            new Text("FIRST", style: TextStyle(fontSize: 40, color: mainColor, fontFamily: "Bebas Neue"),),
                            new Padding(padding: EdgeInsets.all(4),),
                            new Text(
                                "FIRST® (For Inspiration and Recognition of Science and Technology) is a non-profit, international organization founded in 1989 by Dean Kamen, an inventor and entrepreneur. Its goal is to inspire and educate young people in the fields of science, technology, engineering, and math (STEM) through a mentor-based teaching system.",
                                style: TextStyle(fontSize: 20)
                            ),
                            new Padding(padding: EdgeInsets.all(16),),
                            new Image.asset("images/dean-quote.png"),
                            new Padding(padding: EdgeInsets.all(16),),
                            new Text(
                                "FIRST® is comprised of multiple robotics programs, all aimed at different age groups. This includes the Junior Lego® League, FIRST Lego® League (FLL), FIRST Tech Challenge (FRC), and the flagship FIRST® Robotics Competition (FRC), in which Citrus Circuits competes in. Each year, FIRST® releases a new game for each program. This game poses an enormous challenge composed of various tasks, and teams must strategize, design, prototype, build, program, and test their robot during build season, which lasts for six weeks. After build season, teams compete in numerous regional tournaments to qualify for world championships, held annually in St. Louis and in Houston.",
                                style: TextStyle(fontSize: 20)
                            ),
                            new Padding(padding: EdgeInsets.all(12),),
                            new Text("OUTREACH", style: TextStyle(fontSize: 40, color: mainColor, fontFamily: "Bebas Neue"),),
                            new Padding(padding: EdgeInsets.all(4),),
                            new Text(
                                "We, Team 3256 The Warriorborgs, are passionate about impacting people. Through the dedicated members of our team, we change lives through advocacy of learning and outreach, as well as the promotion of STEM in not only our own communities, but also in the communities of foreign countries. We have set an everlasting footprint extending into Peru, Brazil, South Korea, Guam, and Mexico. Check out our Outreach page for more information.",
                                style: TextStyle(fontSize: 20)
                            ),
                            new Padding(padding: EdgeInsets.all(8),),
                            new RaisedButton(
                              onPressed: () {
                                router.navigateTo(context, "/about/outreach", transition: TransitionType.fadeIn);
                              },
                              elevation: 0,
                              color: mainColor,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                              child: new Text("LEARN MORE"),
                            ),
                            new Padding(padding: EdgeInsets.all(12),),
                            new Text("SPONSORS", style: TextStyle(fontSize: 40, color: mainColor, fontFamily: "Bebas Neue"),),
                            new Padding(padding: EdgeInsets.all(4),),
                            new Text(
                                "We would not be able to reach all the communities and accomplish all that we do without the help of our amazing sponsors!",
                                style: TextStyle(fontSize: 20)
                            ),
                            new Wrap(
                              // TODO: add sponsors here
                              children: [

                              ],
                            )
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
