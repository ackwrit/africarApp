import 'package:africars/controller/singleTrajetController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/trajet.dart';
import 'package:africars/view/my_widgets/loading_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class verificationRetour extends StatefulWidget{
  bool retour;
  String depart;
  String arrivee;
  DateTime heureDepart;
  DateTime HeureArrivee;
  int nombrepassager;

  verificationRetour({bool retour,String depart,String arrivee,DateTime heureDepart,DateTime heureArrivee,int nombrepassager}){
    this.retour =retour;
    this.depart=depart;
    this.arrivee=arrivee;
    this.heureDepart=heureDepart;
    this.HeureArrivee=heureArrivee;
    this.nombrepassager=nombrepassager;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeVerification();
  }

}

class homeVerification extends State<verificationRetour>{
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  String heuredepart;
  String heurearrivee;
  int compteur=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(
       title: Image.asset("assets/logo.png",height: 225,),
       backgroundColor: Colors.black,
       centerTitle: true,
     ),
     backgroundColor: Colors.orangeAccent,
     body: bodyPage(),
   );

  }


  Widget bodyPage(){
    return null;
  }

}