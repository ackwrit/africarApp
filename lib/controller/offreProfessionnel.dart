import 'package:flutter/material.dart';

class offreProfessionnel extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeOffre();
  }

}

class homeOffre extends State<offreProfessionnel>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,

      ),
      body: bodyPage(),
    );
  }



  Widget bodyPage(){
    return Text('couou');
  }

}