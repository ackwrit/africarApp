
import 'package:africars/fonction/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class billet{
  String id;
  bool billetretour;
  DateTime emission;
  DateTime jourAller;
  DateTime jourRetour;
  String depart;
  String retour;
  String retourRetour;
  String departRetour;
  String logoCompagnieAller;
  String logoCompagnieRetour;
  String lieuDepart;
  String lieuArrivee;
  String qrCodeAller;
  String qrCodeRetour;
  int nbPassager;
  String nomPassager;
  String prenomPassager;
  bool  validate;
  String idVoyageur;
  String vide;
  int prix;




  billet(DocumentSnapshot snapshot)
  {


    id=snapshot.documentID;
    Map map = snapshot.data;
    //Convertir  les informations en DateTime
    emission = conversion().stringtoDateTime(map['emission']);
    depart=map['depart'];
    retour=map['retour'];
    departRetour=map['departRetour'];
    retourRetour=map['retourRetour'];
    logoCompagnieAller=map['logoCompagnieAller'];
    logoCompagnieRetour=map['logoCompagnieRetour'];
    lieuDepart = map['lieuDepart'];
    lieuArrivee = map['lieuArrivee'];
    nbPassager =map['nbPassager'];
    nomPassager = map['nomPassager'];
    prenomPassager = map['prenomPassager'];
    qrCodeAller=map['qrCodeAller'];
    qrCodeRetour=map['qrCodeRetour'];
    billetretour=map['billetRetour'];
    validate=map['validate'];
    prix=map['prix'];
    jourAller=conversion().stringtoDateTime(map['jourAller']);
    (billetretour==true)?jourRetour=conversion().stringtoDateTime(map['jourRetour']):vide='';
    idVoyageur=map['idVoyageur'];

  }


  Map toMap(){
    Map map;
    return map ={
      map['emission']:emission,
    map['departAller']:depart,
    map['retourAller']:retour,
    map['departRetour']:departRetour,
    map['retourRetour']:retourRetour,
    map['logoCompagnieAller']:logoCompagnieAller,
    map['logoCompagnieRetour']:logoCompagnieRetour,
   map['lieuDepart']: lieuDepart,
    map['lieuArrivee']:lieuArrivee,
     map['nbPassager']:nbPassager,
     map['nomPassager']:nomPassager,
    map['prenomPassager']:prenomPassager,
    map['qrCodeAller']:qrCodeAller,
    map['qrCodeRetour']:qrCodeRetour,
      map['billerRetour']:billetretour,
      map['validate']:validate,
      map['jourAller']:jourAller,
      map['jourRetour']:jourRetour,
      map['idVoyageur']:idVoyageur,
      map['prix']:prix,

    };
  }
}