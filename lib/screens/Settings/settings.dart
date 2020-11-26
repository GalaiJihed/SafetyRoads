
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roads/localization/AppLanguage.dart';
import 'package:roads/localization/AppLocalizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roads/models/Session.dart';
import 'package:roads/screens/Settings/EditProfile.dart';
import 'package:roads/screens/Settings/chatbot.dart';


class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Locale locale;
  bool _dark;
  Session _instance ;
  @override
  void initState() {
    super.initState();
    _dark = false;
    _instance = Session.getState();
    print(_instance.logged_in_user.username);
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
  var appLanguage = Provider.of<AppLanguage>(context);
    return Theme(
      isMaterialAppTheme: true,
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: _dark ? null : Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text( AppLocalizations.translate('settings'),
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.moon),
              onPressed: () {
                setState(() {
                  _dark = !_dark;
                });
              },
            )
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xFF273A48),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => EditProfilePage()));
                      },
                      title: Text(
                        _instance.logged_in_user.username.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      trailing: Icon(
                        Icons.supervised_user_circle,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.lock_outline,
                            color: Colors.lightBlue,
                          ),
                          title: Text(AppLocalizations.translate('change_password')),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {

                            print("");
                          }
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            FontAwesomeIcons.language,
                            color: Colors.lightBlue,
                          ),
                          title: Text(AppLocalizations.translate('change_language')),
                          trailing: Icon(Icons.keyboard_arrow_right),

                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(

                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Image(

                                            image: ExactAssetImage('assets/icons/france.png'),

                                          ),
                                            title: Text("Frensh"),
                                            trailing:IconButton(
                                              icon: Icon(Icons.check),
                                              onPressed:() {
                                                  setState(() {
                                                    appLanguage.changeLanguage(Locale("fr"));
                                                  });



                                            },),


                                        ),
                                        ListTile(
                                          leading: Image(

                                            image: ExactAssetImage('assets/icons/united-kingdom.png'),

                                          ),
                                          title: Text("English"),
                                          trailing:IconButton(
                                            icon: Icon(Icons.check),
                                            onPressed:() {
                                              setState(() {
                                                appLanguage.changeLanguage(Locale("en"));
                                              });


                                            },
                                          ),


                                        ),
                                        ListTile(
                                          leading: Image(

                                            image: ExactAssetImage('assets/icons/tunisia.png'),

                                          ),
                                          title: Text("ARABIC"),
                                          trailing:IconButton(
                                            icon: Icon(Icons.check),
                                            onPressed:()  {
                                              setState(()  {
                                                for(var i=0;i<2;i++){
                                                  appLanguage.changeLanguage(Locale("ar"));
                                                }

                                              });


                                            },
                                          ),


                                        ),
                                      ],
                                    ),

                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close")),
                                    ],
                                  );
                                });
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.lightBlue,
                          ),
                          title: Text(AppLocalizations.translate('change_location')),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change location
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ListTile(
                    leading: Icon(
                      Icons.chat,
                      color: Colors.lightBlue,
                    ),
                    title: Text(AppLocalizations.translate('chat_bot')),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => HomePageDialogflow()));
                    },
                  ),




                  const SizedBox(height: 60.0),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
