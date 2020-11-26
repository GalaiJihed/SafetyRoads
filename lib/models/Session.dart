
import 'package:roads/models/User.dart';

class Session {
  static Session _instance;

  User user;

  User get logged_in_user => user;
  set logged_in_user(User user) {
    this.user = user;
  }

  factory Session() {
    return _instance;
  }

  Session._internal(){}

  static Session getState(){
    if(_instance == null){
      _instance = Session._internal();
    }

    return _instance;
  }
}