import 'package:flutter/material.dart';
import 'package:mywb_web/utils/theme.dart';

class NotFoundPage extends StatefulWidget {

  String route;

  NotFoundPage(String route) {
    this.route = route;
  }

  @override
  _NotFoundPageState createState() => _NotFoundPageState(route);
}

class _NotFoundPageState extends State<NotFoundPage> {

  String route;

  _NotFoundPageState(String route) {
    this.route = route;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Center(
        child: new Card(
          color: currCardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 6.0,
          child: new Container(
            padding: EdgeInsets.all(32.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text("Error 404", style: TextStyle(fontFamily: "Product Sans", fontSize: 35, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                new Padding(padding: EdgeInsets.all(16.0),),
                new Text("Sorry, we couldn't find the thing you were looking for.\n\n$route",
                  style: TextStyle(fontSize: 20)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
