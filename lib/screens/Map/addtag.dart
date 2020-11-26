import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roads/screens/Map/input_text.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:roads/screens/Map/map.dart';
import 'package:roads/services/web_service.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';


class AddTag extends StatefulWidget {
  LocationData _locationData;
  AddTag(this._locationData);
  @override
  _AddTagState createState() => _AddTagState(this._locationData);
}

class _AddTagState extends State<AddTag> {
  LocationData _locationData;
  _AddTagState(this._locationData);
  TextEditingController route, titre, description, ville;
  File file;
  Future<File> uploadedImage;
  String imageName;
  String status = '';
  String base64Image;
  File tmpFile;
  int selected;
  WebService ws;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = -1;
    ws = new WebService();
    route = new TextEditingController();
    titre = new TextEditingController();
    description = new TextEditingController();
    ville = new TextEditingController();
    print(widget._locationData);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Back"),
          titleSpacing: 0,
        ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: <Widget>[
            //IMAGE

            SafeArea(
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: card(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget card(BuildContext context) {
    final double keyboardsize = 18.0;
    final statusBarHeight = 24;
    final marginBottom = 30;
    final bottomPosition = 28;
    return Expanded(
        child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width * .74,
            decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        Positioned(
          bottom: 14,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width * .83,
            decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        Positioned(
          bottom: 28,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height -
                    statusBarHeight -
                    keyboardsize -
                    marginBottom -
                    bottomPosition),
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(height: 30),
                    _Title(context),
                    _Subtitle(context),
                    SizedBox(height: 30),
                    _Form(context),
                    SizedBox(height: 40),
                    _SubmitButton(context),
                    SizedBox(height: 20),
                  ]),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }

  @override
  Widget _Title(BuildContext context) {
    return Text(
      'ADD TAG',
      style: Theme.of(context).textTheme.headline5.copyWith(
          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget _Subtitle(BuildContext context) {
    return Text(
      'fill in the fields!',
      style: Theme.of(context)
          .textTheme
          .subtitle1
          .copyWith(color: Theme.of(context).primaryColor),
    );
  }

  @override
  Widget _Form(BuildContext context) {
    return Form(
        child: Column(
      children: <Widget>[
        InputText(
          label: 'Road',
          icon: FontAwesomeIcons.route,
          value: route,
        ),
        InputText(
          label: 'Title',
          icon: FontAwesomeIcons.laughBeam,
          value: titre,
        ),
        InputText(label: 'City', icon: FontAwesomeIcons.city, value: ville),
        InputText(
          label: 'Description',
          icon: FontAwesomeIcons.addressCard,
          value: description,
        ),
        GestureDetector(
            onTap: () => mainBottomSheet(context),
            child: _setImageView(context)),
      ],
    ));
  }
  clearFields(){
    description.clear();
    ville.clear();
    route.clear();
    titre.clear();
  }
  @override
  Widget _SubmitButton(BuildContext context) {
    return RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 80),
        onPressed: () {
          if (route.text.isEmpty ||
              description.text.isEmpty ||
              ville.text.isEmpty ||
              description.text.isEmpty) {
            print("empty fields");
          } else {
            ws.AddTag(
                route.text,
                description.text,
                imageName,
                ville.text,
                titre.text,
                widget._locationData.latitude,
                widget._locationData.longitude,
                );
            ws.uploadImage(file.path);
            clearFields();
            _showMyDialog(context);

//ws.sendNotification(payload);
          }
        },
        child: Text(
          'CONFIRM',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        color: Theme.of(context).primaryColor);
  }

  Widget _setImageView(BuildContext context) {
    if (file == null) {
      return Center(
        child: Stack(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                image: new DecorationImage(
                  image: ExactAssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 10))
                ],
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    color: Colors.lightBlue,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      );
    } else {
      return Center(
        child: Stack(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                image: new DecorationImage(
                  image: new FileImage(file),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 10))
                ],
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    color: Colors.lightBlue,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      );
    }
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
}
_showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('your tag added successfully!'),
              Text('Go to the map to see your tag '),
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            child: Text('Go To Map'),
            onPressed: () {

              Navigator.of(context).pop();
              MapPage();
            },
          ),
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