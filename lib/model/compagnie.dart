
import 'package:firebase_database/firebase_database.dart';

class compagnie{
  String id;
  String matricule;
  String adresse;
  String mail;
  String nomDirigeant;
  String prenomDirigeant;
  String offre;



  compagnie(DataSnapshot snapshot){
    id = snapshot.key;
    Map map = snapshot.value;
    matricule = map['matricule'];
    adresse = map['adresse'];
    mail = map['mail'];
    nomDirigeant = map['nomeDirigeant'];
    prenomDirigeant = map['prenomDirigeant'];
    offre = map['offre'];

  }

  Map toMap(){
    Map map;
    return map ={
      map['id']:id,
      map['matricule']:matricule,
      map['adresse']:adresse,
      map['mail']:mail,
      map['nomeDirigeant']:nomDirigeant,
      map['prenomDirigeant']:prenomDirigeant,
      map['offre']:offre

    };
  }

}