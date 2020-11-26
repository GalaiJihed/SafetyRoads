import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roads/Screens/Login/components/background.dart';
//import 'package:roads/Screens/Signup/signup_screen.dart';
import 'package:roads/components/already_have_an_account_acheck.dart';
import 'package:roads/components/rounded_button.dart';
import 'package:roads/components/rounded_input_field.dart';
import 'package:roads/components/rounded_password_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roads/localization/AppLocalizations.dart';
import 'package:roads/main.dart';
import 'package:roads/screens/Home/Home.dart';
import 'package:roads/screens/Login/login_screen.dart';
import 'package:roads/screens/Signup/signup_screen.dart';
import 'package:roads/services/web_service.dart';
import 'package:roads/utils/constants.dart';
import 'package:roads/widgets/PopUp.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController username;
  TextEditingController password;
  bool secureText;
  WebService ws = new WebService();
  var storage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storage = FlutterSecureStorage();
    username = new TextEditingController();
    password = new TextEditingController();
    setState(() {
      secureText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
            ),
            SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/images/logo.png",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              value: username,
              hintText:AppLocalizations.translate('username'),
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              value: password,
              hintText: AppLocalizations.translate('password'),
              secureText: secureText,
              iconButton: IconButton(
                icon: new Icon(Icons.visibility, color: kPrimaryColor),
                onPressed: () {
                  setState(() {
                    if (secureText = true) {
                      this.secureText = false;
                      print(this.secureText);
                    } else {
                      secureText = true;
                      print(this.secureText);
                    }
                  });
                },
              ),
              onChanged: (value) {},
            ),
            RoundedButton(
              text: AppLocalizations.translate('login'),
              press: () async {
                if(username.text.isEmpty || password.text.isEmpty) {
                  final action = await Dialogs.yesAbortDialog(
                      context,
                      'Fields ',
                      'Complete all fields',
                      DialogType.error);
                }else{
                  var jwt = await ws.login(username.text, password.text);
                  if (jwt != null) {
                    storage.write(key: "jwt", value: jwt);
                    ws.login(username.text, password.text);
                    final action = await Dialogs.yesAbortDialog(
                        context,
                        'Success ',
                        'You are welcome',
                        DialogType.success);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen.fromBase64(jwt)));

                  }

                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('all fields are empty'),
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void displayDialog(BuildContext context, String title, String text) =>
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );
