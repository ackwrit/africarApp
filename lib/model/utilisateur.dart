
import 'package:africars/fonction/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String uid;
  int avoir;


  utilisateur(DocumentSnapshot snapshot)
  {
    id=snapshot.documentID;
    Map map = snapshot.data;
    id=map['id'];
    uid=map['uid'];
    nom = map['nom'];
    prenom = map['prenom'];
    compagnie =map['compagnie'];
    telephone =map['telephone'];
    pseudo= map['login'];
    image =map['image'];
    mail=map['mail'];
    sexe=map['sexe'];
    naissance=conversion().readTimestamp(map['naissance']);
    type_utilisateur =map['typeUtilisateur'];
    avoir=map['avoir'];
  }


  Map toMap()
  {
    Map <String,dynamic>map;
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
      'naissance':naissance.millisecondsSinceEpoch,
      'avoir':avoir,
      'uid':uid

    };
  }
}