import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:roads/Config/AppConfig.dart';
import 'package:roads/models/Tag.dart';
import 'package:location/location.dart';
import 'package:roads/screens/Map/addtag.dart';
import 'package:roads/services/web_service.dart';

class _MapPageState extends State<MapPage> {
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  final List<Tag> places = [];
  final PopupController _popupLayerController = PopupController();
  final List<Tag> _markersOnMap = [];
  bool ready = false;
  WebService ws;
  void addMarker(BuildContext context) {
    for (final place in places) {
      if (!_markersOnMap.contains(place)) {
        statefulMapController.addMarker(
            name: place.titre,
            marker: Marker(
                point: place.point,
                builder: (BuildContext context) {
                  return IconButton(
                      icon: Icon(Icons.location_off),
                      splashColor: Colors.blueAccent,
                      onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            minWidth: 100, maxWidth: 200),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              place.titre,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Image.network(AppConfig.URL_Image +
                                                place.picture,width: 300,
                                                height: 150,
                                                fit:BoxFit.fill),
                                            SizedBox(height: 20),

                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0)),
                                            Text(
                                              "Titre: " + place.titre,
                                              style: const TextStyle(
                                                  fontSize: 12.0),
                                            ),
                                            Text(
                                              "description:" +
                                                  place.description,
                                              style: const TextStyle(
                                                  fontSize: 12.0),
                                            ),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                color: Colors.blue,
                                                child: Text("Close")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                          });
                }
                //
                ));
        _markersOnMap.add(place);

        return;
      }
    }
  }

  @override
  initState() {
    super.initState();
    ws = new WebService();
    //  print("places:"+places.toString());
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => setState(() => ready = true));
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    getCurrentLocation();

    setState(() {
      ws.fetchTags().then((value) {
        print(value);

        for (var i = 0; i < value.length; i++) {
          Map<String, dynamic> tags = value[i];
          places.add(Tag(
              tags["id"],
              tags["route"],
              tags["description"],
              tags["picture"],
              LatLng(tags["latitude"], tags["longitude"]),
              tags["ville"],
              tags["titre"],
              tags["createdAt"]));
        }
        for (var i = 0; i < places.length; i++) {
          addMarker(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SafeArea(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            onTap: (_) => _popupLayerController.hidePopup(),
            center: LatLng(36.806496, 10.181532),
            zoom: 11.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              tileProvider: NonCachingNetworkTileProvider(),
            ),
            MarkerLayerOptions(
              markers: statefulMapController.markers,
            ),
          ],
        ),
      ),
      floatingActionButton: ready
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                setState(() {
                  print(_locationData);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AddTag(_locationData)));
                });
              })
          : const Text(""),
    ));
  }

  void showPopupForFirstMarker() {
    _popupLayerController.togglePopup(statefulMapController.markers.first);
  }

  getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.getLocation().then((value) => {});
    setState(() {
      //_center = LatLng(_locationData.latitude, _locationData.longitude);
      mapController.move(
          LatLng(_locationData.latitude, _locationData.longitude), 13.0);
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}
