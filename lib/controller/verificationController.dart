
import 'package:africars/controller/listingTrajet.dart';
import 'package:africars/controller/registerController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class verificationController extends StatefulWidget{
  bool retour;
  String depart;
  String arrivee;
  DateTime heureDepart;
  DateTime HeureArrivee;
  int nombrepassager;
  verificationController({bool retour,String depart,String arrivee,DateTime heureDepart,DateTime heureArrivee,int nombrepassager}){
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
    return verifState();
  }

}

class verifState extends State<verificationController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return listingTrajet(
              retour: widget.retour,
              depart: widget.depart,
              arrivee: widget.arrivee,
              heureArrivee: widget.HeureArrivee,
              heureDepart: widget.heureDepart,
              nombrepassager: widget.nombrepassager,);
          }
          else {
            return registerController(
              retour: widget.retour,
              depart: widget.depart,
              arrivee: widget.arrivee,
              heureArrivee: widget.HeureArrivee,
              heureDepart: widget.heureDepart,
              nombrepassager: widget.nombrepassager,
            );
          }
        }
    );
  }
}

