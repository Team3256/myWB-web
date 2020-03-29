import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:mywb_web/models/cart.dart';
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_drawer.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'dart:js' as js;
import 'package:http/http.dart' as http;
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/utils/config.dart';
import 'dart:html' as html;
import 'package:mywb_web/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCartPage extends StatefulWidget {
  @override
  _StoreCartPageState createState() => _StoreCartPageState();
}

class _StoreCartPageState extends State<StoreCartPage> {

  final Storage _localStorage = html.window.localStorage;

  User currUser;

  List<Cart> cartList = new List();
  List<Widget> cartWidgetList = new List();

  int totalPrice = 0;

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
    else {
      router.navigateTo(context, '/login', replace: true);
    }
  }
  
  Future<void> getItems() async {
    await http.get("$dbHost/store/cart/${_localStorage["userID"]}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var responseJson = jsonDecode(response.body);
      for (int i = 0; i < responseJson.length; i++) {
        setState(() {
          cartList.add(new Cart(responseJson[i]));
          totalPrice += (cartList[i].price * cartList[i].quantity);
          cartWidgetList.add(new Container(
            padding: new EdgeInsets.all(4.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await cycleApiKey().then((value) async {
                          await http.delete("$dbHost/store/cart/${_localStorage["userID"]}/${cartList[i].productID}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
                            if (response.statusCode == 200) {
                              html.window.location.reload();
                            }
                          });
                        });
                      },
                    ),
                    new Padding(padding: EdgeInsets.all(8.0)),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                            cartList[i].productName,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "Oswald")
                        ),
                        new Padding(padding: EdgeInsets.all(4.0)),
                        new Text(
                            "Size: ${cartList[i].size}",
                            style: TextStyle(fontSize: 17)
                        ),
                        new Text(
                            "Variant: ${cartList[i].variant}",
                            style: TextStyle(fontSize: 17)
                        ),
                        new Text(
                            "Quantity: ${cartList[i].quantity}",
                            style: TextStyle(fontSize: 17)
                        )
                      ],
                    ),
                  ],
                ),
                new Text("\$${(cartList[i].price * cartList[i].quantity).toDouble()/100}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
              ],
            ),
          ));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getItems();
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
              child: new Container(
                width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                child: new SingleChildScrollView(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(16.0),),
                      new FlatButton(
                        child: new Text("Contintue Shopping", style: TextStyle(color: mainColor),),
                        onPressed: () {
                          router.navigateTo(context, '/store', transition: TransitionType.fadeIn);
                        },
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
                              new Text("My Cart", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                              new Padding(padding: EdgeInsets.all(16.0),),
                              new Text(
                                "After reviewing your items below, please click the check out button at the bottom. All items ordered will be delivered to the robotics room (G137) in 7-10 business days.",
                                style: new TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
                      new Visibility(
                        visible: cartList.isNotEmpty,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Column(
                              children: cartWidgetList,
                            ),
                          ),
                        ),
                      ),
                      new Visibility(
                        visible: cartList.isEmpty,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: Center(child: new Text("Wow, such empty.", style: TextStyle(fontSize: 30),)),
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0),),
                      new Visibility(
                        visible: cartList.isNotEmpty,
                        child: new Card(
                          color: currCardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          elevation: 0.0,
                          child: new Container(
                            padding: EdgeInsets.all(32.0),
                            width: double.infinity,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Text("Total Cost", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                new Text("\$${totalPrice.toDouble()/100}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(16.0),),
                      new Visibility(
                        visible: cartList.isNotEmpty,
                        child: Center(
                          child: new RaisedButton(
                            child: new Text("Proceed to Checkout", style: TextStyle(fontSize: 20.0)),
                            elevation: 0.0,
                            color: mainColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                            onPressed: () async {
                              Map<String, dynamic> order = new Map();
                              order["orderID"] = "";
                              order["userID"] = currUser.id;
                              order["paymentComplete"] = false;
                              order["paymentComplete"] = false;
                              List<dynamic> itemList = new List();
                              cartList.forEach((ctem) {
                                Map<String, dynamic> itemMap = new Map();
                                itemMap["productID"] = ctem.productID;
                                itemMap["orderID"] = ctem.productID;
                                itemMap["productName"] = ctem.productName;
                                itemMap["size"] = ctem.size;
                                itemMap["variant"] = ctem.variant;
                                itemMap["quantity"] = ctem.quantity;
                                itemMap["price"] = ctem.price;
                                itemList.add(itemMap);
                              });
                              order["items"] = itemList;
                              await cycleApiKey().then((value) async {
                                await http.post("$dbHost/store/orders", headers: {"Authentication": "Bearer $apiKey"}, body: jsonEncode(order)).then((response) {
                                  if (response.statusCode == 200) {
                                    var responseJson = jsonDecode(response.body);
                                    html.window.location.assign("https://vcrobotics.net/#/store/redirect?session_id=${responseJson["orderID"]}");
                                  }
                                  else {
                                    html.window.alert(response.body);
                                  }
                                });
                              });
                            },
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(16.0),),
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
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Cart", style: TextStyle(fontFamily: "Oswald"),),
          elevation: 0.0,
          backgroundColor: mainColor,
        ),
        drawer: new HomeDrawer(),
        backgroundColor: currBackgroundColor,
        body: new Container(
          padding: EdgeInsets.all(16),
          child: new SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new FlatButton(
                  child: new Text("Contintue Shopping", style: TextStyle(color: mainColor),),
                  onPressed: () {
                    router.navigateTo(context, '/store', transition: TransitionType.fadeIn);
                  },
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
                        new Text("My Cart", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                        new Padding(padding: EdgeInsets.all(16.0),),
                        new Text(
                          "After reviewing your items below, please click the check out button at the bottom. All items ordered will be delivered to the robotics room (G137) in 7-10 business days.",
                          style: new TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(8.0),),
                new Visibility(
                  visible: cartList.isNotEmpty,
                  child: new Card(
                    color: currCardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    elevation: 0.0,
                    child: new Container(
                      padding: EdgeInsets.all(32.0),
                      width: double.infinity,
                      child: new Column(
                        children: cartWidgetList,
                      ),
                    ),
                  ),
                ),
                new Visibility(
                  visible: cartList.isEmpty,
                  child: new Card(
                    color: currCardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    elevation: 0.0,
                    child: new Container(
                      padding: EdgeInsets.all(32.0),
                      width: double.infinity,
                      child: Center(child: new Text("Wow, such empty.", style: TextStyle(fontSize: 30),)),
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(8.0),),
                new Visibility(
                  visible: cartList.isNotEmpty,
                  child: new Card(
                    color: currCardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    elevation: 0.0,
                    child: new Container(
                      padding: EdgeInsets.all(32.0),
                      width: double.infinity,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text("Total Cost", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                          new Text("\$${totalPrice.toDouble()/100}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0),),
                new Visibility(
                  visible: cartList.isNotEmpty,
                  child: Center(
                    child: new RaisedButton(
                      child: new Text("Proceed to Checkout", style: TextStyle(fontSize: 20.0)),
                      elevation: 0.0,
                      color: mainColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      onPressed: () async {
                        Map<String, dynamic> order = new Map();
                        order["orderID"] = "";
                        order["userID"] = currUser.id;
                        order["paymentComplete"] = false;
                        order["paymentComplete"] = false;
                        List<dynamic> itemList = new List();
                        cartList.forEach((ctem) {
                          Map<String, dynamic> itemMap = new Map();
                          itemMap["productID"] = ctem.productID;
                          itemMap["orderID"] = ctem.productID;
                          itemMap["productName"] = ctem.productName;
                          itemMap["size"] = ctem.size;
                          itemMap["variant"] = ctem.variant;
                          itemMap["quantity"] = ctem.quantity;
                          itemMap["price"] = ctem.price;
                          itemList.add(itemMap);
                        });
                        order["items"] = itemList;
                        await cycleApiKey().then((value) async {
                          await http.post("$dbHost/store/orders", headers: {"Authentication": "Bearer $apiKey"}, body: jsonEncode(order)).then((response) {
                            if (response.statusCode == 200) {
                              var responseJson = jsonDecode(response.body);
                              html.window.location.assign("https://vcrobotics.net/#/store/redirect?session_id=${responseJson["orderID"]}");
                            }
                            else {
                              html.window.alert(response.body);
                            }
                          });
                        });
                      },
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0),),
              ],
            ),
          ),
        ),
      );
    }
  }
}