import 'package:flutter/material.dart';
import 'package:roads/Screens/Login/components/body.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Body(),
    );
  }
  dispose(){

  }
}
