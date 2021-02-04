import 'package:firebase/firebase.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_web/pages/about/about_page.dart';
import 'package:mywb_web/pages/about/outreach_page.dart';
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:mywb_web/pages/auth/register_discord_page.dart';
import 'package:mywb_web/pages/auth/register_page.dart';
import 'package:mywb_web/pages/home/home_page.dart';
import 'package:mywb_web/pages/maintenance_page.dart';
import 'package:mywb_web/pages/not_found_page.dart';
import 'package:mywb_web/pages/store/store_page.dart';
import 'package:mywb_web/pages/team/team_page.dart';
import 'package:mywb_web/utils/config.dart';
import 'package:mywb_web/utils/service_account.dart';
import 'package:mywb_web/utils/theme.dart';

void main() {
  initializeApp(
      apiKey: ServiceAccount.apiKey,
      authDomain: ServiceAccount.authDomain,
      databaseURL: ServiceAccount.databaseUrl,
      projectId: ServiceAccount.projectID,
      storageBucket: ServiceAccount.storageUrl
  );

  // AUTH ROUTES
  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));
  router.define('/register', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterPage();
  }));
  router.define('/register/discord', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterDiscordPage();
  }));

  // HOME ROUTES
  router.define('/', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HomePage();
    // return new MaintenancePage();
  }));

  // ABOUT ROUTES
  router.define('/about', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AboutPage();
  }));
  router.define('/about/outreach', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new OutreachPage();
  }));

  // TEAM ROUTES
  router.define('/team', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TeamPage();
  }));

  // EVENT ROUTES


  // ATTENDANCE ROUTES


  // STORE ROUTES
  router.define('/store', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new StorePage();
  }));

  // PR ROUTES


  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
    initialRoute: '/',
    title: "WarriorBorgs 3256",
    onGenerateRoute: router.generator,
    onUnknownRoute: (RouteSettings setting) {
      String unknownRoute = setting.name;
      return new MaterialPageRoute(
          builder: (context) => NotFoundPage(unknownRoute)
      );
    },
  ));
}