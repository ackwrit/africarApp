import 'package:africars/controller/avoirController.dart';
import 'package:africars/controller/registerController.dart';
import 'package:africars/controller/registerProController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class testingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeTesting();
  }

}

class homeTesting extends State<testingPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder <FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context,snapshot){
          if(snapshot.hasData){
            return avoirController();
          }
          else
            {
              return registerController();
            }
        }
    );
  }

}