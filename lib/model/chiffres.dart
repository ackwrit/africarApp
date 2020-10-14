
import 'package:cloud_firestore/cloud_firestore.dart';

class chiffres{
  String id;
  int janvier;
  int fevrier;
  int mars;
  int avril;
  int mai;
  int juin;
  int juillet;
  int aout;
  int septembre;
  int octobre;
  int novembre;
  int decembre;
  String uidChiffre;
  String nomCompagnie;






  chiffres(DocumentSnapshot snapshot)
  {
    id=snapshot.documentID;
    Map map = snapshot.data;
    janvier=map['Janvier'];
    fevrier=map['Fevrier'];
    mars=map['Mars'];
    avril=map['Avril'];
    mai=map['Mai'];
    juin=map['Juin'];
    juillet=map['Juillet'];
    aout=map['Aout'];
    septembre=map['Septembre'];
    octobre=map['Octobre'];
    novembre=map['Novembre'];
    decembre=map['Decembre'];
    uidChiffre=map['uidChiffre'];
    nomCompagnie=map['nomCompagnie'];




  }


  Map toMap(){
    Map map;
    return map ={
      map['Janvier']:janvier,
      map['Fevrier']:fevrier,
      map['Mars']:mars,
      map['Avril']:avril,
      map['Mai']:mai,
      map['Juin']:juin,
      map['Juillet']:juillet,
      map['Aout']:aout,
      map['Septembre']:septembre,
      map['Octobre']:octobre,
      map['Novembre']:novembre,
      map['Decembre']:decembre,
      map['uidChiffre']:uidChiffre,
      map['nomCompagnie']:nomCompagnie,
    };

  }
}