import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final mainColor = Color(0xFF014F8F);

const lightTextColor = Colors.black;
const lightBackgroundColor = Color(0xFFf9f9f9);
const lightCardColor = Colors.white;
const lightDividerColor = const Color(0xFFC9C9C9);

// DARK THEME
const darkTextColor = Colors.white;
const darkBackgroundColor = const Color(0xFF212121);
const darkCardColor = const Color(0xFF2C2C2C);
const darkDividerColor = const Color(0xFF616161);

// CURRENT COLORs
var currTextColor = lightTextColor;
var currBackgroundColor = lightBackgroundColor;
var currCardColor = lightCardColor;
var currDividerColor = lightDividerColor;

ThemeData mainTheme = new ThemeData(
  accentColor: mainColor,
  primaryColor: mainColor,
  fontFamily: "WB Sans",
  buttonTheme: ButtonThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    padding: EdgeInsets.only(left: 32, top: 16, bottom: 16, right: 32),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  cardTheme: CardTheme(
    color: currCardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  )
);