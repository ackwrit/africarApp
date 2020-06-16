
import 'package:firebase_database/firebase_database.dart';

class billet{
  String id;
  DateTime emission;
  DateTime depart;
  DateTime retour;
  String lieuDepart;
  String lieuArrivee;
  String qrCode;
  String nbPassager;
  String nomPassager;
  String prenomPassager;



  billet(DataSnapshot snapshot)
  {
    id=snapshot.key;
    Map map = snapshot.value;
    //Convertir  les informations en DateTime
    emission = map['emission'];
    depart = map['depart'];
    retour = map['retour'];
    lieuDepart = map['lieuDepart'];
    lieuArrivee = map['lieuArrivee'];
    qrCode = map['qrCode'];
    nbPassager = map['nbPassager'];
    nomPassager = map['nomPassager'];
    prenomPassager = map['prenomPassager'];

  }


  Map toMap(){
    Map map;
    return map ={
      map['emission']:emission,
      map['depart']:depart,
      map['retour']:retour,
      map['lieuDepart']:lieuDepart,
      map['lieuArrivee']:lieuArrivee,
      map['qrCode']:qrCode,
      map['nbPassager']:nbPassager,
      map['nomPassager']:nomPassager,
      map['prenomPassager']:prenomPassager

    };
  }
}