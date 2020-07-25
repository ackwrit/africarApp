
import 'package:africars/fonction/conversion.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class billet{
  String id;
  bool billetretour;
  DateTime emission;
  DateTime jourAller;
  DateTime jourRetour;
  String departAller;
  String retourAller;
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




  billet(DataSnapshot snapshot)
  {


    id=snapshot.key;
    Map map = snapshot.value;
    //Convertir  les informations en DateTime
    emission = conversion().stringtoDateTime(map['emission']);
    departAller=map['departAller'];
    retourAller=map['retourAller'];
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
    jourAller=conversion().stringtoDateTime(map['jourAller']);
    (billetretour==true)?jourRetour=conversion().stringtoDateTime(map['jourRetour']):vide='';
    idVoyageur=map['idVoyageur'];

  }


  Map toMap(){
    Map map;
    return map ={
      map['emission']:emission,
    map['departAller']:departAller,
    map['retourAller']:retourAller,
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

    };
  }
}