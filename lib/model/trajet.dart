
import 'package:firebase_database/firebase_database.dart';

class trajet{
  String id;
  String depart;
  String destination;
  String heureDepart;
  String heureDestination;
  String prix;
  String idCompagnie;
  String logoCompagnie;
  String nomCompagnie;


  trajet(DataSnapshot snapshot)
  {
    id= snapshot.key;
    Map map = snapshot.value;
    depart=map['depart'];
    destination=map['destination'];
    heureDepart=map['heureDepart'];
    heureDestination=map['heureDestination'];
    prix=map['prix'];
    idCompagnie=map['idCompagnie'];
    logoCompagnie=map['logoCompagnie'];
    nomCompagnie=map['nomCompagnie'];
  }

  Map toMap(){
    Map map;
    return map={
      map['depart']:depart,
      map['destination']:destination,
      map['heureDepart']:heureDepart,
      map['heureDestination']:heureDestination,
      map['prix']:prix,
      map['idCompagnie']:idCompagnie,
      map['nomCompagnie']:nomCompagnie,
      map['logoCompagnie']:logoCompagnie,

    };

}
}

