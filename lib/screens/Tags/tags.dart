import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:roads/models/Tag.dart';
import 'package:roads/screens/Tags/DetailsTags.dart';
import 'package:roads/screens/Tags/components/Background.dart';
import 'package:flutter/cupertino.dart';
import 'package:roads/services/web_service.dart';
import 'package:roads/models/User.dart';
import 'package:http/http.dart' as http;
import '../../models/User.dart';




class TagsPage extends StatefulWidget {
  TextEditingController controller = new TextEditingController();
  final List<String> list = List.generate(10, (index) => "Texto $index");
  final List<Tag> tags;

  TagsPage({Key key, @required this.tags}) : super(key: key);


  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {




  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];
  List<Tag> tags = [];


  void getPostsData() {

    List<Widget> listItems = [];
    tags.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
            BoxShadow(color: Color(0xFF273A48), blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.titre,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post.ville,
                      style: const TextStyle(fontSize: 17, color: Colors.lightBlue),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      post.createdAt.substring(0,10),
                      style: const TextStyle(fontSize: 25, color: Color(0xFF273A48), fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Image.network(
                  "http://192.168.1.18:3000/images/" +
                      post.picture,
                  height: double.infinity,
                ),


              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {

    super.initState();

    controller.addListener(() {


      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
    WebService ws=new WebService();

    ws.fetchTags().then((value)  {
      print(value);
      setState(() {
        for (var i = 0; i < value.length; i++) {
          Map<String, dynamic> tagsres = value[i];
          tags.add(Tag(
              tagsres["id"],
              tagsres["route"],
              tagsres["description"],
              tagsres["picture"],
              LatLng(tagsres["latitude"], tagsres["longitude"]),
              tagsres["ville"],
              tagsres["titre"],
              tagsres["createdAt"]));
        }

        getPostsData();


      });
    });


  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(icon:Icon(
            Icons.location_on,
            color: Colors.black,
          ),
          onPressed: ()=>{

          },
        ),
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Liste des Tags",
                    style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold, fontSize: 20),
                  ),


                ],
              ),


              Expanded(

                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {


                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }

                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(),
                                  // Pass the arguments as part of the RouteSettings. The
                                  // DetailScreen reads the arguments from these settings.
                                  settings: RouteSettings(
                                    arguments: tags[index],
                                  ),
                                ),
                              );
                            },
                            child:Opacity(
                              opacity: scale,
                              child: Transform(
                                transform:  Matrix4.identity()..scale(scale,scale),
                                alignment: Alignment.bottomCenter,
                                child: Align(
                                    heightFactor: 1.0,
                                    alignment: Alignment.topCenter,
                                    child: itemsData[index]),


                              ),

                            )

                        );

                      }





                  )),
            ],
          ),
        ),
      ),
    );
  }



}
