import 'package:flutter/material.dart';

class informationController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeInformation();
  }

}

class homeInformation extends State<informationController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return bodyPage();
  }



  Widget bodyPage(){
    return Container(
      color: Colors.orangeAccent,
      child: Text('Liste des messages reçus'),
    );
  }

}