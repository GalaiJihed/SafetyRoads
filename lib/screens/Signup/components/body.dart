import 'dart:io';

import 'package:flutter/material.dart';

import 'package:roads/components/already_have_an_account_acheck.dart';
import 'package:roads/components/rounded_button.dart';
import 'package:roads/components/rounded_input_field.dart';
import 'package:roads/components/rounded_password_field.dart';

import 'package:roads/screens/Login/login_screen.dart';
import 'package:roads/screens/Signup/components/background.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:roads/services/web_service.dart';
import 'package:roads/utils/or_divider.dart';
import 'package:roads/utils/social_icon.dart';
import 'package:roads/widgets/PopUp.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<File> uploadedImage;
  String imageName;
  File file;
  String status = '';
  String base64Image;
  File tmpFile;
  int selected;
  WebService ws;
  TextEditingController username,
      email,
      password,
      address,
      phoneNumber,
      retypePassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = -1;
    ws = new WebService();
    username = new TextEditingController();
    email = new TextEditingController();
    password = new TextEditingController();
    address = new TextEditingController();
    phoneNumber = new TextEditingController();
    retypePassword = new TextEditingController();
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            GestureDetector(
              onTap: () async {
                await mainBottomSheet(context);
              },
              child: _setImageView(),
            ),
            RoundedInputField(
              value: username,
              hintText: "Username",
              icon: Icons.person,
              onChanged: (value) {},
            ),
            RoundedInputField(
              value: email,
              hintText: " Email",
              icon: Icons.email,
              onChanged: (value) {},
            ),
            RoundedInputField(
              value: address,
              icon: Icons.location_on,
              hintText: "Address",
              onChanged: (value) {},
            ),
            RoundedInputField(
              value: phoneNumber,
              hintText: "phoneNumber",
              icon: Icons.phone_android,
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              value: password,
              secureText: true,
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              value: retypePassword,
              hintText: "Confirm Password",
              secureText: true,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () async {
                var now = new DateTime.now();

                String role = "CLIENT";
                //   User.fromMap(data);

                if (username.text.isEmpty ||
                    password.text.isEmpty ||
                    address.text.isEmpty ||
                    imageName.isEmpty ||
                    email.text.isEmpty ||
                    phoneNumber.text.isEmpty ||
                    file.path.isEmpty) {
                  final action = await Dialogs.yesAbortDialog(
                      context, 'All Fields ', 'Check fields', DialogType.error);
                } else if (phoneNumber.text.trim().length > 8) {
                  final action = await Dialogs.yesAbortDialog(context, 'Over ',
                      'Phone Number is Over 8 number', DialogType.error);
                } else if (phoneNumber.text.trim().length < 8) {
                  final action = await Dialogs.yesAbortDialog(context, 'Under ',
                      'Phone Number is Under 8 number', DialogType.error);
                } else if (password.text != retypePassword.text) {
                  final action = await Dialogs.yesAbortDialog(context,
                      'Password ', 'Password not match', DialogType.error);
                } else {
                  ws.signUp(
                    username.text,
                    password.text,
                    address.text,
                    imageName,
                    email.text,
                    phoneNumber.text,
                  );
                  ws.uploadImage(file.path);
                  final action = await Dialogs.yesAbortDialog(
                      context,
                      'Success ',
                      'your account has been created',
                      DialogType.success);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  getImageGallery() async {
    uploadedImage = ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      uploadedImage.then((onValue) {
        file = onValue;
        if (onValue != null) {
          imageName = path.basename(file.path);
          print(imageName);
        }
      });
    });
  }

  getImageCamera() async {
    uploadedImage = ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      uploadedImage.then((onValue) {
        file = onValue;
        if (onValue != null) {
          imageName = path.basename(file.path);
          print(imageName);
        }
      });
    });
  }

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.lightBlue,
                ),
                title: Text("Take a photo"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    this.selected = 0;
                  });
                  getImageCamera();
                  //print(selected);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Colors.lightBlue,
                ),
                title: Text("My images"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    this.selected = 1;
                  });
                  setState(() {
                    getImageGallery();
                  });

                  print(selected);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.clear,
                  color: Colors.blue,
                ),
                title: Text("Cancel"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    this.selected = 2;
                  });
                  print(selected);
                },
              ),
            ],
          );
        });
  }

  Widget _setImageView() {
    if (file != null) {
      return Image.file(file, width: 100, height: 200);
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          "assets/images/logo.png",
          height: 250.0,
          width: 200.0,
        ),
      );
    }
  }

  _showMyDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: ListBody(
            children: <Widget>[
              Text('you have empty fields check it '),
            ],
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
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("My title"),
    content: Text("This is my message."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
