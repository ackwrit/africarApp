
import 'package:firebase_database/firebase_database.dart';

class utilisateur{
  String id;
  String nom;
  String prenom;
  String compagnie;
  String telephone;
  String image;
  String type_utilisateur;
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
    type_utilisateur =map['typeUtilisateur'];
  }


  Map toMap()
  {
    Map map;
    return map ={
      map['nom']:nom,
      map['prenom']:prenom,
      map['id']:id,
      map['compagnie']:compagnie,
      map['telephone']:telephone,
      map['image']:image,
      map['typeUtilisateur']:type_utilisateur,
      map['login']:pseudo,
      map['mail']:mail,
    };
  }
}