import 'dart:ffi';

import 'package:latlong/latlong.dart';

class Tag{
  int id;
  String route ;
  String description;
  String picture;
  LatLng point;
  String ville;
  String titre;
  String createdAt;

  Tag(this.id, this.route, this.description, this.picture, this.point,
      this.ville, this.titre,this.createdAt);

  /*
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      route: json['route'],
      description: json['description'],
      picture: json['picture'],
      ville: json['ville'],
      point: LatLng(json["latitude"],json["longitude"]),
      titre: json['titre'],
        createdAt: json['createdAt'],
    );


  }

*/
  }