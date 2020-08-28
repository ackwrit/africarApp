
import 'package:africars/fonction/conversion.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class trajet{
  String id;
  String depart;
  String destination;
  DateTime heureDepart;
  DateTime heureDestination;
  String prix;
  bool retour;
  String idCompagnie;
  String logoCompagnie;
  String nomCompagnie;



  trajet(DocumentSnapshot snapshot)
  {
    id= snapshot.documentID;
    Map map = snapshot.data;
    depart=map['depart'];
    destination=map['destination'];
    heureDepart=conversion().readTimestamp(map['heureDepart']);
    //heureDestination=conversion().readTimestamp(map['heureDestination']);
    prix=map['prix'].toString();
    idCompagnie=map['idCompagnie'];
    logoCompagnie=map['logoCompagnie'];
    nomCompagnie=map['nomCompagnie'];
    retour = map['retour'];
  }

  Map toMap(){
    Map map;
    return map={
      map['depart']:depart,
      map['destination']:destination,
      map['heureDepart']:heureDepart.millisecondsSinceEpoch,
      //map['heureDestination']:Timestamp.fromMillisecondsSinceEpoch(heureDestination.millisecondsSinceEpoch),
      map['prix']:int.parse(prix),
      map['idCompagnie']:idCompagnie,
      map['nomCompagnie']:nomCompagnie,
      map['logoCompagnie']:logoCompagnie,
      map['retour']:retour,

    };

  }
}

