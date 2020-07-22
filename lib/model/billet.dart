
import 'package:firebase_database/firebase_database.dart';

class billet{
  String id;
  bool billetretour;
  DateTime emission;
  DateTime jourAller;
  DateTime jourRetour;
  DateTime departAller;
  DateTime retourAller;
  DateTime retourRetour;
  DateTime departRetour;
  String logoCompagnieAller;
  String logoCompagnieRetour;
  String lieuDepart;
  String lieuArrivee;
  String qrCodeAller;
  String qrCodeRetour;
  String nbPassager;
  String nomPassager;
  String prenomPassager;
  bool provisoire;



  billet(DataSnapshot snapshot)
  {
    id=snapshot.key;
    Map map = snapshot.value;
    //Convertir  les informations en DateTime
    emission = map['emission'];
    departAller=map['departAller'];
    retourAller=map['retourAller'];
    departRetour=map['departRetour'];
    retourRetour=map['retourRetour'];
    logoCompagnieAller=map['logoCompagnieAller'];
    logoCompagnieRetour=map['logoCompagnieRetour'];
    lieuDepart = map['lieuDepart'];
    lieuArrivee = map['lieuArrivee'];
    nbPassager = map['nbPassager'];
    nomPassager = map['nomPassager'];
    prenomPassager = map['prenomPassager'];
    qrCodeAller=map['qrCodeAller'];
    qrCodeRetour=map['qrCodeRetour'];
    billetretour=map['billetRetour'];
    provisoire=map['provisoire'];
    jourAller=map['jourAller'];
    jourRetour=map['jourRetour'];

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
      map['provisoire']:provisoire,
      map['jourAller']:jourAller,
      map['jourRetour']:jourRetour,

    };
  }
}