
import 'package:flutter/material.dart';

class dateController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeDate();
  }

}

class homeDate extends State<dateController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.orange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('message')
        ],
      ),
    );
  }

}