import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:roads/localization/AppLanguage.dart';
import 'package:roads/localization/AppLocalizations.dart';
import 'package:roads/screens/Home/Home.dart';
import 'package:roads/screens/Home/HomePage.dart';
import 'package:roads/screens/Login/login_screen.dart';
import 'package:roads/utils/custom_splash.dart';
import 'package:roads/Router.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';


void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  WonderPush.subscribeToNotifications();
  if (kDebugMode) {
    WonderPush.setLogging(true);
  }
  runApp(MaterialApp(home: CustomSplashs(appLanguage: appLanguage)));

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatelessWidget  {

  var storage = FlutterSecureStorage();

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return
       FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");

              if (jwt.length != 3) {
                return LoginScreen();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 10)
                    .isAfter(DateTime.now())) {
                  return HomeScreen(str, payload);
                } else {
                  return LoginScreen();
                }
              }
            } else {
              return LoginScreen();
            }
          }
       );

  }
}

Function duringSplash = () {
  print('Something background process');
  int a = 123 + 23;
  print(a);

  if (a > 100)
    return 1;
  else
    return 2;
};

class CustomSplashs extends StatelessWidget {
  final AppLanguage appLanguage;

  CustomSplashs({this.appLanguage});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(


            locale: model.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
              Locale('fr', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],

            onGenerateRoute:  CustomRouter.generatedRoute,
            debugShowCheckedModeBanner: false,
            title: "Flutter Localization Demo",
            theme: ThemeData(primarySwatch: Colors.blue),
            home: CustomSplash(
              imagePath: 'assets/images/logo.png',
              backGroundColor: Colors.lightBlue,
              // backGroundColor: Color(0xfffc6042),
              animationEffect: 'zoom-in',
              logoSize: 200,
              home: MyApp(),
              customFunction: duringSplash,
              duration: 4000,
              type: CustomSplashType.StaticDuration,
            ));
      }),
    );
  }



}

