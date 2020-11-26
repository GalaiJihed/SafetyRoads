
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum DialogAction { yes, abort }
enum DialogType { error, warning, success, offline, online }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
      BuildContext context,
      String title,
      String body,
      DialogType type,
      ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                getImageFromType(type),
                SizedBox(
                  height: 10,
                ),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Playfair',
                  ),
                ),
                //Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              color: getColorFromType(type),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
  static Widget getImageFromType(DialogType type) {
    switch (type) {
      case DialogType.error:
        return FaIcon(
          FontAwesomeIcons.solidTimesCircle,
          color: Colors.red,
          size: 120,
        );
        break;
      case DialogType.warning:
        return FaIcon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.amber,
          size: 120,
        );
        break;
      case DialogType.success:
        return FaIcon(
          FontAwesomeIcons.solidCheckCircle,
          color: Colors.green,
          size: 120,
        );
        break;
      case DialogType.offline:
        return Icon(
          Icons.signal_wifi_off,
          color: Colors.red,
          size: 120,
        );
        break;
      case DialogType.online:
        return FaIcon(
          FontAwesomeIcons.wifi,
          color: Colors.red,
          size: 120,
        );
        break;
    }
  }

  static Color getColorFromType(DialogType type) {
    switch (type) {
      case DialogType.error:
        return Colors.red;
        break;
      case DialogType.warning:
        return Colors.amber;
        break;
      case DialogType.success:
        return Colors.green;
        break;
      case DialogType.offline:
        return Colors.red;
        break;
      case DialogType.online:
        return Colors.green;
        break;
    }
  }
}