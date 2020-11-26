import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:roads/Config/AppConfig.dart';
import 'package:roads/models/User.dart';
import 'package:roads/screens/Login/login_screen.dart';
import 'package:roads/screens/Map/addtag.dart';
import 'package:roads/screens/Map/map.dart';
import 'package:location/location.dart';

var dio = new Dio();

class WebService {
  Future<String> login(var username, var password) async {
    var params = {"username": username, "password": password};

    String url =AppConfig.URL_SignIn;

    final response = await dio.post(url,
        data: params,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }));
    if (response.statusCode == 200) {

      User.fromJson(response.data);

      String token = response.data["token"];
      return token;
      /*  Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));*/
    } else {
      return throw Exception("Failed to get token");
    }
  }

  signUp(var username, var password, var address, var picture, var email,
      var phoneNumber) async {
    var now = new DateTime.now();
    var params = {
      "username": username,
      "password": password,
      "role": "CLIENT",
      "address": address,
      "picture": picture,
      "email": email,
      "phoneNumber": phoneNumber,
      "birthDate": new DateFormat("yyyy-MM-dd").format(now),
    };

    String url = AppConfig.URL_SignUp;
    final response = await dio.post(url,
        data: params,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }));
    if (response.statusCode == 201) {
      print(response.statusCode);

    } else
      return throw Exception(
          "Failed to add new user : username already in use ");
  }

  uploadImage(filename) async {
    var request =
    http.MultipartRequest('POST', Uri.parse(AppConfig.URL_Upload_image));
    request.files.add(await http.MultipartFile.fromPath('filedata', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }
  GetTagByLatLng(var Lat ,var Lng ) async{
    var params = {
      "longitude": Lng,
      "longitude": Lat,

    };

    String url = AppConfig.URL;
    final response = await dio.post(url,
        data: params,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }));
    if (response.statusCode == 201) {
      print(response.data);

    } else
      return throw Exception(
          "Failed to add new user : username already in use ");
  }

  fetchTags() async {
    final response =
    await http.post(AppConfig.URL_GET_TAGS);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  AddTag(var route, var description, var picture, var ville, var titre,
      var latitude,var longitude) async {
    var now = new DateTime.now();
    var params = {
      "route": route,
      "description": description,
      "role": "CLIENT",
      "picture": picture,
      "ville": ville,
      "titre": titre,
      "latitude":latitude,
      "longitude":longitude,
      "createdAt": new DateFormat("yyyy-MM-dd").format(now),
    };
    String url = AppConfig.URL_Addtag;
    final response = await dio.post(url,
        data: params,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }));
    if (response.statusCode == 200) {
    } else
      return throw Exception(
          "Failed to add new user new TAG  ");
  }
  editUser(var username, var address, var picture, var email,
      var phoneNumber,var id) async {
    var now = new DateTime.now();
    var params = {
      "username": username,
      "address": address,
      "picture": picture,
      "email": email,
      "phoneNumber": phoneNumber,

    };

    String url = AppConfig.URL_edit_profile+id;
    print(url);
    final response = await http.patch(url,
      body: params,
    );
    if (response.statusCode == 204) {
      print(response.statusCode);
      return response.statusCode;
    } else
      return throw Exception(
          "Failed to edit new user : username already in use ");
  }

}
