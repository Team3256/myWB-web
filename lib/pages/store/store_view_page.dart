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
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/navbar/home_navbar.dart';
import 'dart:js' as js;
import 'package:http/http.dart' as http;
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/utils/config.dart';
import 'dart:html' as html;
import 'package:mywb_web/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreViewPage extends StatefulWidget {
  @override
  _StoreViewPageState createState() => _StoreViewPageState();
}

class _StoreViewPageState extends State<StoreViewPage> {

  final Storage _localStorage = html.window.localStorage;

  User currUser;
  String itemID = "";
  String productName = "";
  String productDescription = "";
  String size = "N/A";
  String variant = "N/A";
  int price = 0;
  int quantity = 1;

  List<Widget> previewList = new List();
  List<String> sizeList = new List();
  List<String> variantList = new List();

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
  }

  void getProductInfo(String id) {
    if (id=="wbshirt") {
      setState(() {
        productName = "WB T-Shirt";
        productDescription = "Just a simple WarrioBorgs T-Shirt.";
        size = "XS";
        price = 2650;
      });
    }
    else if (id=="2020hoodie") {
      setState(() {
        productName = "2020 Hoodie";
        productDescription = "Official WarriorBorgs Hoodie for the 2020 season.";
        size = "S";
        price = 3450;
      });
    }
    else if (id=="shootershirt") {
      setState(() {
        productName = "T-Shirt Shooter T-Shirt";
        productDescription = "Special Edition T-Shirt Shooter hand-drawn vibes t-shirt";
        size = "XS";
        price = 2850;
      });
    }
    else if (id=="shooterhoodie") {
      setState(() {
        productName = "T-Shirt Shooter Hoodie";
        productDescription = "Special Edition T-Shirt Shooter hand-drawn vibes hoodie";
        size = "S";
        price = 3750;
      });
    }
    else if (id=="wbjoggers") {
      setState(() {
        productName = "WB Joggers";
        productDescription = "Official WarriorBorgs joggers, idk what else to say.";
        size = "S";
        variant = "Black";
        price = 3150;
      });
    }
    else if (id=="snapback") {
      setState(() {
        productName = "WB Snapback";
        productDescription = "Funny baseball cap, but it's WB.";
        price = 1950;
      });
    }
    else if (id=="beanie") {
      setState(() {
        productName = "WB Beanie";
        productDescription = "A nice, warm WB beanie perfect for use in Canada.";
        price = 2150;
      });
    }
    else if (id=="flaumpack") {
      setState(() {
        productName = "WB Flaumpack";
        productDescription = "Official WarriorBorgs backpack, designed by the amazing Flaumber himself.";
        price = 4450;
        variant = "Black";
      });
    }
    else if (id=="drawstring") {
      setState(() {
        productName = "WB Drawstring";
        productDescription = "WB drawstring bag, kinda cringe, but hey it's there if ya want it.";
        price = 2250;
      });
    }
    else if (id=="wbmug") {
      setState(() {
        productName = "WB Mug";
        productDescription = "A nice mug to hold your drink while reppin' WB.";
        price = 1550;
      });
    }
  }

  void getPreviews(String id) {
    if (id=="wbshirt") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/wbshirt_front.png", height: 300, width: 300,),
          ),
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/wbshirt_back.png", height: 300, width: 300,),
          )
        ]);
      });
    }
    else if (id=="2020hoodie") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/2020hoodie_front.png", height: 300, width: 300,),
          ),
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/2020hoodie_back.png", height: 300, width: 300,),
          )
        ]);
      });
    }
    else if (id=="shootershirt") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/shootershirt_front.png", height: 300, width: 300,),
          ),
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/shootershirt_back.png", height: 300, width: 300,),
          )
        ]);
      });
    }
    else if (id=="shooterhoodie") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/shooterhoodie_front.png", height: 300, width: 300,),
          ),
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/shooterhoodie_back.png", height: 300, width: 300,),
          )
        ]);
      });
    }
    else if (id=="wbjoggers") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/wbjoggers_heather.png", height: 300, width: 300,),
          ),
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/wbjoggers_black.png", height: 300, width: 300,),
          )
        ]);
      });
    }
    else if (id=="snapback") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/snapback.png", height: 300, width: 300,),
          )
        ]);
      });
    }
    else if (id=="beanie") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/beanie.png", height: 300, width: 300,),
          )
        ]);
      });
    }
    else if (id=="flaumpack") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/flaumpack_black.png", height: 300, width: 300,),
          ),
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/flaumpack_grey.png", height: 300, width: 300,),
          ),
        ]);
      });
    }
    else if (id=="drawstring") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/drawstring.png", height: 300, width: 300,),
          )
        ]);
      });
    }
    else if (id=="wbmug") {
      setState(() {
        previewList.addAll([
          new ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: new Image.network("http://vcrobotics.net/images/wbmug.png", height: 300, width: 300,),
          )
        ]);
      });
    }
  }

  void getSizes(String id) {
    if (id=="wbshirt") {
      setState(() {
        sizeList.addAll(["XS", "S", "M", "L", "XL", "2XL"]);
      });
    }
    else if (id=="2020hoodie") {
      setState(() {
        sizeList.addAll(["S", "M", "L", "XL", "2XL"]);
      });
    }
    else if (id=="shootershirt") {
      setState(() {
        sizeList.addAll(["XS", "S", "M", "L", "XL", "2XL"]);
      });
    }
    else if (id=="shooterhoodie") {
      setState(() {
        sizeList.addAll(["S", "M", "L", "XL", "2XL"]);
      });
    }
    else if (id=="wbjoggers") {
      setState(() {
        sizeList.addAll(["S", "M", "L", "XL", "2XL"]);
      });
    }
    else if (id=="snapback") {

    }
    else if (id=="beanie") {

    }
    else if (id=="flaumpack") {

    }
    else if (id=="drawstring") {

    }
    else if (id=="wbmug") {

    }
  }

  void getVariants(String id) {
    if (id=="wbshirt") {

    }
    else if (id=="2020hoodie") {

    }
    else if (id=="shootershirt") {

    }
    else if (id=="shooterhoodie") {

    }
    else if (id=="wbjoggers") {
      setState(() {
        variantList.addAll(["Black", "Black Heather"]);
      });
    }
    else if (id=="snapback") {

    }
    else if (id=="beanie") {

    }
    else if (id=="flaumpack") {
      setState(() {
        variantList.addAll(["Black", "Grey"]);
      });
    }
    else if (id=="drawstring") {

    }
    else if (id=="wbmug") {

    }
  }

  @override
  void initState() {
    super.initState();
    if (html.window.location.toString().contains("?id=")) {
      print(html.window.location.toString().split("?id=")[1]);
      itemID = html.window.location.toString().split("?id=")[1];
      getProductInfo(itemID);
      getPreviews(itemID);
      getSizes(itemID);
      getVariants(itemID);
      getUser();
    }
    else {
      router.navigateTo(context, '/store', transition: TransitionType.fadeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      child: new Text("Back to Store", style: TextStyle(color: mainColor),),
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
                            new Text(productName, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center),
                            new Padding(padding: EdgeInsets.all(16.0),),
                            new Text(
                              productDescription,
                              style: new TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(8.0),),
                    new Card(
                      color: currCardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      elevation: 0.0,
                      child: new Container(
                        padding: EdgeInsets.all(32.0),
                        width: double.infinity,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Container(
                              height: 300,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: previewList
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(16),
                              child: new Text("\$${price.toDouble()*quantity / 100} – $size – $variant", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center)
                            ),
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                  icon: new Icon(Icons.remove_circle_outline),
                                  color: quantity - 1 > 0 ? mainColor : Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      if (quantity - 1 > 0) {
                                        quantity--;
                                      }
                                    });
                                  },
                                ),
                                new Padding(
                                    padding: EdgeInsets.all(16),
                                    child: new Text("$quantity", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Oswald"), textAlign: TextAlign.center)
                                ),
                                new IconButton(
                                  icon: new Icon(Icons.add_circle_outline),
                                  color: mainColor,
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                )
                              ],
                            ),
                            new Padding(padding: EdgeInsets.all(8.0),),
                            new Visibility(
                              visible: sizeList.length != 0,
                              child: new Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: sizeList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: new InkWell(
                                        onTap: () {
                                          setState(() {
                                            size = sizeList[index];
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: new Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: mainColor),
                                              color: size == sizeList[index] ? mainColor : currCardColor,
                                              borderRadius: BorderRadius.circular(16.0)
                                          ),
                                          width: 100,
                                          child: Center(child: new Text(sizeList[index], style: TextStyle(fontSize: 20, color: size == sizeList[index] ? Colors.white : currTextColor),)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            new Padding(padding: EdgeInsets.all(16.0),),
                            new Visibility(
                              visible: variantList.length != 0,
                              child: new Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: variantList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: new InkWell(
                                        onTap: () {
                                          setState(() {
                                            variant = variantList[index];
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: new Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: mainColor),
                                              color: variant == variantList[index] ? mainColor : currCardColor,
                                              borderRadius: BorderRadius.circular(16.0)
                                          ),
                                          width: 100,
                                          child: Center(child: new Text(variantList[index], style: TextStyle(fontSize: 20, color: variant == variantList[index] ? Colors.white : currTextColor),)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(16.0),),
                    new RaisedButton(
                      child: new Text("Add to Cart", style: TextStyle(fontSize: 20.0)),
                      elevation: 0.0,
                      color: mainColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      onPressed: () async {
                        if (fb.auth().currentUser != null) {
                          String itemJsonString = '{"id": "$itemID", "productName": "$productName", "size": "$size", "variant": "$variant", "quantity": "$quantity", "cost": "$price"}';
                          print(itemJsonString);
                          await cycleApiKey().then((value) async {
                            await http.post("$dbHost/store/cart", headers: {"Authentication": "Bearer $apiKey"}, body: jsonEncode({
                              "productID": itemID,
                              "userID": currUser.id,
                              "productName": productName,
                              "size": size,
                              "variant": variant,
                              "quantity": quantity,
                              "price": price
                            })).then((response) async {
                              print(response.body);
                              if (response.statusCode == 200) {
                                router.navigateTo(context, '/store/cart', transition: TransitionType.fadeIn);
                              }
                              else if (response.statusCode == 404) {
                                html.window.alert(response.body);
                              }
                            });
                          });
                        }
                        else {
                          html.window.alert("You must be logged in to access the merch store!");
                        }
                      }
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
}