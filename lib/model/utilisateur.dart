
import 'package:firebase_database/firebase_database.dart';

class utilisateur{
  String id;
  String nom;
  String prenom;
  String compagnie;
  String telephone;
  String image;
  String type_utilisateur;


  utilisateur(DataSnapshot snapshot)
  {
    id=snapshot.key;
    Map map = snapshot.value;
    nom = map['nom'];
    prenom = map['prenom'];
    compagnie =map['compagnie'];
    telephone =map['telephone'];
    image =map['image'];
    type_utilisateur =map['type_utilisateur'];
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
      map['type_utilisateur']:type_utilisateur,
    };
  }
}