import 'package:fluro/fluro.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mywb_web/models/user.dart';
import 'package:mywb_web/models/version.dart';

Version appVersion = new Version("2.0.1+1");
String appStatus = "";
String appFull = "Version ${appVersion.toString()}";

final router = new Router();

String dbHost = "http://localhost:6000/api";
String authHost = "http://localhost:6002/api";

String prDiscordUrl = "https://discordapp.com/api/webhooks/633445431602315284/JCEk6xqZICaJNUbKk2K_2bItGziHBqWO71vNqkAcszYxVNA1MzfGMSenZ1UhCWwxfn3-";

String apiKey = "";

User currUser = new User();

Future<void> cycleApiKey() async {
  apiKey = fb.database().ref("tokens").push().key;
  await fb.database().ref("tokens").child(apiKey).set(apiKey);
//  await Future.delayed(const Duration(milliseconds: 100));
}

String appLegal = """
MIT License
Copyright (c) 2020 WarriorBorgs 3256
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
""";