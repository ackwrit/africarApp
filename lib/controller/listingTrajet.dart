import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/trajet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class listingTrajet extends StatefulWidget{
  bool retour;
  listingTrajet({bool retour}){
    this.retour =retour;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeListing();
  }

}

class homeListing extends State<listingTrajet>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.orange,
      body: bodyPage(),
    );
  }


  Widget bodyPage(){
    return FirebaseAnimatedList(
        query: firebaseHelper().base_trajet,
        defaultChild: Text("Actuellement, il n'y a aucun trajet"),
        itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
          trajet trajetSelectionne = trajet(snapshot);
          return ListTile(
            title: Text(trajetSelectionne.depart),
          );


        }
    );
  }

}