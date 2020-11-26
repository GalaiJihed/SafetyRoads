import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:roads/models/Session.dart';
import 'package:roads/models/User.dart';
import 'package:roads/screens/Home/HomePage.dart';


import 'package:roads/screens/Map/map.dart';
import 'package:roads/screens/Settings/settings.dart';
import 'package:roads/screens/Tags/tags.dart';


class HomeScreen extends StatefulWidget {

  HomeScreen(this.jwt, this.payload);
  factory HomeScreen.fromBase64(String jwt) => HomeScreen(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _HomeScreenState createState() => _HomeScreenState(this.payload);
}


class _HomeScreenState extends State<HomeScreen> {
  final Map<String, dynamic> payload;

  _HomeScreenState(this.payload);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: BottomNavCustom(this.payload),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
}

class BottomNavCustom extends StatefulWidget {
  final Map<String, dynamic> payload;

  const BottomNavCustom( this.payload);

  @override
  _BottomNavCustomState createState() => _BottomNavCustomState(this.payload);
}

class _BottomNavCustomState extends State<BottomNavCustom> {
   Map<String, dynamic> payload;
   Session _instance ;
   User user;
   _BottomNavCustomState(this.payload);
  final List<Widget> _children = [
    HomePage(),
    MapPage(),
    TagsPage(),
    SettingsPage(),

  ];

  int currentIndex = 0;
  int _counter = 0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(this.payload)  ;
    User.fromJson(this.payload);
     user = User.fromJson(this.payload['user']);
    _instance = Session.getState();
    _instance.logged_in_user = user;
      print("user.username");
}
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.lightBlue,
            inactiveColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
            activeColor: Colors.lightBlue,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.location_on),
            title: Text(
              'Tags ',
            ),
            activeColor: Colors.lightBlue,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.lightBlue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
