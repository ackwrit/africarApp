
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
  int prixAller;
  int prixRetour;
  String idCompagnieAller;
  String idCompagnieRetour;
  String idVoyageur;
  String idFacture;



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
    nbPassager = map['nbPassager'];
    nomPassager = map['nomPassager'];
    prenomPassager = map['prenomPassager'];
    telephobne =map ['telephone'];
    validate =map['validate'];
    prixAller=map['prixAller'];
    prixRetour=map['prixRetour'];
    idCompagnieAller=map['idCompagnieAller'];
    idCompagnieRetour=map['idCompagnieRetour'];
    idVoyageur=map['idvoyageur'];
    idFacture=map['idfacture'];


  }


  Map toMap(){
    Map map;
    return map ={
      'emission':emission,
      'depart':depart,
      'retour':retour,
      'lieuDepart':lieuDepart,
      'lieuArrivee':lieuArrivee,
      'qrCodeAller':qrCodeAller,
      'qrCodeRetour':qrCodeRetour,
      'nbPassager':nbPassager,
      'nomPassager':nomPassager,
      'prenomPassager':prenomPassager,
      'logoCompagnieAller':logoCompagnieAller,
      'logoCompagnieRetour':logoCompagnieRetour,
      'telephone':telephobne,
      'validate':validate,
      'prixAller':prixAller,
     'prixRetour':prixRetour,
      'idCompagnieAller':idCompagnieAller,
      'idCompagnieRetour':idCompagnieRetour,
     'idvoyageur':idVoyageur,
      'idfacture':idFacture

    };
  }
}