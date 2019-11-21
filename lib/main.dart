import 'package:firebase/firebase.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:mywb_web/pages/home/home_page.dart';
import 'package:mywb_web/pages/not_found_page.dart';
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

  // HOME ROUTES
  router.define('/', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HomePage();
  }));

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
    initialRoute: '/',
    onGenerateRoute: router.generator,
    onUnknownRoute: (RouteSettings setting) {
      String unknownRoute = setting.name;
      return new MaterialPageRoute(
          builder: (context) => NotFoundPage(unknownRoute)
      );
    },
  ));
}