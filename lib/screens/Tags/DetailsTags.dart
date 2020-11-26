import 'package:flutter/material.dart';
import 'package:roads/Config/AppConfig.dart';
import 'package:roads/models/Tag.dart';


class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Tag detail = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.titre),
      ),
      body: Center(child:Column(
        children: <Widget>[
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
              BoxShadow(color: Color(0xFF273A48), blurRadius: 10.0),
            ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              child: Image.network(AppConfig.URL_Image+detail.picture,width: 500,
                  height: 150,
                  fit:BoxFit.fill),
            ),
          ),
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
              BoxShadow(color: Color(0xFF273A48), blurRadius: 10.0),
            ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              child: Column(

                children: <Widget>[
                  SizedBox(height: 20,),

                  Row(
                    children: <Widget>[
                      SizedBox(width: 20,),
                      Icon(Icons.location_on),
                      SizedBox(width: 20,),
                      Text(detail.ville,style: TextStyle(fontSize: 20),)
                    ],
                  ),

                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20,),
                      Icon(Icons.location_on),
                      SizedBox(width: 20,),
                      Text(detail.route,style: TextStyle(fontSize: 20))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20,),
                      Icon(Icons.do_not_disturb),
                      SizedBox(width: 20,),
                      Text(detail.titre,style: TextStyle(fontSize: 20))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20,),
                      Icon(Icons.calendar_today),
                      SizedBox(width: 20,),
                      Text("Created at ${detail.createdAt.substring(0,10)}",style: TextStyle(fontSize: 20))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20,),
                      Icon(Icons.text_fields),
                      SizedBox(width: 20,),
                      Text(detail.description,style: TextStyle(fontSize: 20))
                    ],
                  ),
                  SizedBox(height: 20,),

                ],
              )
            ),
          ),
          SizedBox(width: 20,),


        ],
      ),),

    );
  }
}