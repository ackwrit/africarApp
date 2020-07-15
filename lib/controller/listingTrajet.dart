import 'package:africars/fonction/conversion.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/trajet.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';

class listingTrajet extends StatefulWidget{
  bool retour;
  String depart;
  String arrivee;
  DateTime heureDepart;
  DateTime HeureArrivee;
  
  listingTrajet({bool retour,String depart,String arrivee,DateTime heureDepart,DateTime heureArrivee}){
    this.retour =retour;
    this.depart=depart;
    this.arrivee=arrivee;
    this.heureDepart=heureDepart;
    this.HeureArrivee=heureArrivee;
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
    return Column(
      children: [
        FirebaseAnimatedList(
            query: firebaseHelper().base_trajet,
            defaultChild: Text("Actuellement, il n'y a aucun trajet"),
            shrinkWrap: true,
            itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
              trajet trajetSelectionne = trajet(snapshot);
              DateTime heurearrivee= conversion().stringtoDateTime(trajetSelectionne.heureDestination);
              DateTime heuredepart =conversion().stringtoDateTime(trajetSelectionne.heureDepart);
              DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
              DateFormat formatheure = DateFormat.Hm('fr_FR');
              return
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(8)),
                      Text(formatjour.format(heuredepart)),
                      ListTile(
                        title: Text("${trajetSelectionne.depart} - ${trajetSelectionne.destination}",textAlign: TextAlign.start,),
                        trailing: Text("${formatheure.format(heuredepart) }- ${formatheure.format(heurearrivee)}"),
                        subtitle: Text('Prix'),

                      ),
                    ],
                  ),


                );



            }
        ),


      ],
    );
  }

}