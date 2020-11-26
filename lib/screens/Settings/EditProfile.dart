import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roads/Config/AppConfig.dart';
import 'package:roads/models/Session.dart';
import 'package:roads/screens/Login/login_screen.dart';
import 'package:roads/services/web_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
class EditProfilePage extends StatefulWidget {




  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
   Session _instance;
  WebService ws;

  final storage = new FlutterSecureStorage();
@override
  void initState() {

    // TODO: implement initState
    super.initState();
    ws =new WebService();
    _instance = Session.getState();

   }
  @override
  Widget build(BuildContext context) {
    return
    MaterialApp(

      home:   Scaffold(
          resizeToAvoidBottomInset: false,
        appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(icon:Icon(
        Icons.arrow_back,
        color: Colors.black,

    ),
        onPressed: ()=>{
          Navigator.of(context).pop()
        },)
        ),
        body: new Stack(
        children: <Widget>[
        ClipPath(
        child: Container(color: Colors.blue.withOpacity(0.8)),
    clipper: getClipper(),
    ),
    Positioned(
    width: 350.0,
    top: MediaQuery.of(context).size.height / 5,
    child: Column(
    children: <Widget>[
    Container(
    width: 150.0,
    height: 150.0,
    decoration: BoxDecoration(
    color: Colors.blue,
    image: DecorationImage(
    image: NetworkImage(
    AppConfig.URL_Image+_instance.logged_in_user.picture),
    fit: BoxFit.cover),
    borderRadius: BorderRadius.all(Radius.circular(75.0)),
    boxShadow: [
    BoxShadow(blurRadius: 7.0, color: Colors.blue)
    ])),
    SizedBox(height: 30.0),

      Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              SizedBox(width: 90.0),

              Icon(Icons.supervised_user_circle),
              SizedBox(width: 20,),

              Text(

                _instance.logged_in_user.username,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              SizedBox(width: 90.0),

              Icon(Icons.location_on),
              SizedBox(width: 20,),

              Text(

                _instance.logged_in_user.address,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              SizedBox(width: 90.0),

              Icon(Icons.email),
              SizedBox(width: 20,),

              Text(

                _instance.logged_in_user.email,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              SizedBox(width: 90.0),

              Icon(Icons.phone_android),
              SizedBox(width: 20,),

              Text(

                _instance.logged_in_user.phoneNumber.toString(),
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              SizedBox(width: 90.0),

              Icon(Icons.calendar_view_day),
              SizedBox(width: 20,),

              Text(

                _instance.logged_in_user.birthDate.substring(0,10),
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ],
          ),
        ],
      ),
    )
   ,
    SizedBox(height: 15.0),


    SizedBox(height: 25.0),
    Container(
    height: 40.0,
    width: 200.0,
    child: Material(
    borderRadius: BorderRadius.circular(20.0),
    shadowColor: Colors.blue,
    color: Colors.blue,
    elevation: 7.0,
    child: GestureDetector(
    onTap: () {

      storage.deleteAll();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen()));
    },
    child: Center(

    child: Text(
    'Log out',
    style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
    ),
    ),
    ),
    ))
    ],
    ))
    ],
    )));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
