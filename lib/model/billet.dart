
import 'package:africars/fonction/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class billet{
  String id;
  bool billetRetour;
  DateTime emission;
  DateTime depart;
  DateTime retour;
  String lieuDepart;
  String lieuArrivee;
  String qrCodeAller;
  String qrCodeRetour;
  int nbPassager;
  String nomPassager;
  String prenomPassager;
  String logoCompagnieAller;
  String logoCompagnieRetour;
  String telephobne;
  bool validate;
  int prix;
  String idVoyageur;



  billet(DocumentSnapshot snapshot)
  {
    id=snapshot.documentID;
    Map map = snapshot.data;
    billetRetour = map['billerRetour'];
    //Convertir  les informations en DateTime
    emission = conversion().readTimestamp(map['emission']);
    depart = conversion().readTimestamp(map['jourAller']);
    retour = conversion().readTimestamp(map['jourRetour']);
    lieuDepart = map['lieuDepart'];
    lieuArrivee = map['lieuArrivee'];
    logoCompagnieAller= map['logoCompagnieAller'];
    logoCompagnieRetour= map['logoCompagnieRetour'];
    qrCodeAller = map['qrCodeAller'];
    qrCodeRetour =map['qrCodeRetour'];
    idVoyageur=map['idvoyageur'];
    nbPassager = map['nbPassager'];
    nomPassager = map['nomPassager'];
    prenomPassager = map['prenomPassager'];
    telephobne =map ['telephone'];
    validate =map['validate'];
    prix=map['prix'];

  }


  Map toMap(){
    Map map;
    return map ={
      map['emission']:emission,
      map['depart']:depart,
      map['retour']:retour,
      map['lieuDepart']:lieuDepart,
      map['lieuArrivee']:lieuArrivee,
      map['qrCodeAller']:qrCodeAller,
      map['qrCodeRetour']:qrCodeRetour,
      map['nbPassager']:nbPassager,
      map['nomPassager']:nomPassager,
      map['prenomPassager']:prenomPassager,
      map['logoCompagnieAller']:logoCompagnieAller,
      map['logoCompagnieRetour']:logoCompagnieRetour,
      map['telephone']:telephobne,
      map['validate']:validate,
      map['prix']:prix,
      map['idVoyageur']:idVoyageur

    };
  }
}