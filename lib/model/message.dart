import 'package:africars/fonction/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String idMessage;
  String from;
  String to;
  String texte;
  DateTime envoiMessage;


  Message(DocumentSnapshot snapshot) {
    idMessage = snapshot.documentID;
    Map map = snapshot.data;
    from = map['from'];
    to = map['to'];
    texte = map['texte'];
    envoiMessage =conversion().readTimestamp(map['envoiMessage']);;





  }
}