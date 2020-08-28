
import 'package:firebase_database/firebase_database.dart';

class utilisateur{
  String id;
  String nom;
  String prenom;
  String compagnie;
  String telephone;
  String image;
  String type_utilisateur;
  String sexe;
  DateTime naissance;
  String pseudo;
  String mail;


  utilisateur(DataSnapshot snapshot)
  {
    id=snapshot.key;
    Map map = snapshot.value;
    nom = map['nom'];
    prenom = map['prenom'];
    compagnie =map['compagnie'];
    telephone =map['telephone'];
    pseudo= map['login'];
    image =map['image'];
    mail=map['mail'];
    sexe=map['sexe'];
    naissance=map['naissance'];
    type_utilisateur =map['typeUtilisateur'];
  }


  Map toMap()
  {
    Map map;
    return map ={
      'nom':nom,
      'prenom':prenom,
      'id':id,
      'compagnie':compagnie,
      'telephone':telephone,
      'image':image,
      'typeUtilisateur':type_utilisateur,
      'login':pseudo,
      'mail':mail,
      'sexe':sexe,
      'naissance':naissance,

    };
  }
}