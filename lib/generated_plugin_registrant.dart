//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins(PluginRegistry registry) {
  GoogleSignInPlugin.registerWith(registry.registrarFor(GoogleSignInPlugin));
  UrlLauncherPlugin.registerWith(registry.registrarFor(UrlLauncherPlugin));
  registry.registerMessageHandler();
}
