import 'package:firebase/firebase.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_web/pages/events/attendance_page.dart';
import 'package:mywb_web/pages/auth/login_page.dart';
import 'package:mywb_web/pages/auth/register_discord_page.dart';
import 'package:mywb_web/pages/auth/register_page.dart';
import 'package:mywb_web/pages/events/events_attendance_page.dart';
import 'package:mywb_web/pages/events/events_page.dart';
import 'package:mywb_web/pages/home/home_page.dart';
import 'package:mywb_web/pages/not_found_page.dart';
import 'package:mywb_web/pages/purchase_request/new_purchase_request_page.dart';
import 'package:mywb_web/pages/purchase_request/purchase_request_page.dart';
import 'package:mywb_web/pages/purchase_request/view_purchase_request.dart';
import 'package:mywb_web/pages/store/store_cancel_page.dart';
import 'package:mywb_web/pages/store/store_cart_page.dart';
import 'package:mywb_web/pages/store/store_page.dart';
import 'package:mywb_web/pages/store/store_redirect_page.dart';
import 'package:mywb_web/pages/store/store_success_page.dart';
import 'package:mywb_web/pages/store/store_temp.dart';
import 'package:mywb_web/pages/store/store_view_page.dart';
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
  }));

  // EVENT ROUTES
  router.define('/events', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventsPage();
  }));
  router.define('/events/attendance', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventsAttendancePage();
  }));

  // ATTENDANCE ROUTES
  router.define('/attendance', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AttendancePage();
  }));

  // TEAM ROUTES
  router.define('/team', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TeamPage();
  }));

  // STORE ROUTES
  router.define('/store', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new StorePage();
  }));
  router.define('/store/view', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new StoreViewPage();
  }));
  router.define('/store/cart', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new StoreCartPage();
  }));
  router.define('/store/redirect', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new StoreRedirectPage();
  }));
  router.define('/store/checkout/success', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new StoreSuccessPage();
  }));
  router.define('/store/checkout/cancel', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new StoreCancelPage();
  }));

  // PR ROUTES
  router.define('/purchase-request', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new PurchaseRequestPage();
  }));
  router.define('/purchase-request/new', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new NewPurchaseRequestPage();
  }));
  router.define('/purchase-request/view', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ViewPurchaseRequest();
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