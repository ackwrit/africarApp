
import 'dart:io';

import 'package:africars/model/billet.dart';
import 'package:africars/model/compagnie.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class firebaseHelper{
//authetification
final auth = FirebaseAuth.instance;
String verificationId;
String generate=randomAlphaNumeric(20);




//Authentification par mail

Future<FirebaseUser> handleCreateMailCompagnie({String nif,String adresse,String mail,String password,String nomDirigeant,String prenomDirigeant})async{
  final AuthResult authResult = await auth.createUserWithEmailAndPassword(email: mail, password: password);
  FirebaseUser user =authResult.user;
  String uid= user.uid;
  Map map ={
    'id':uid,
    'matricule':nif,
    'adresse':adresse,
    'mail':mail,
    'nomeDirigeant':nomDirigeant,
    'prenomDirigeant':prenomDirigeant,
    'offre':'gratuit'
  };
  addCompagnie(map, uid);
  return user;

}


Future <void> handleSignPhone(String phone) async
{
  final PhoneVerificationCompleted verified = (AuthCredential credential){
    auth.signInWithCredential(credential);

  };

  final PhoneVerificationFailed failed =(AuthException exception){
    print(exception);
  };


  final PhoneCodeSent phoneCodeSent =(String verifId,[int forceResend]){
    this.verificationId = verifId;


  };

  final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout =(String verifId){
    this.verificationId = verifId;

  };


  auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: failed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout
  );

}


Future<void> signOTP(smsCode,verifId)async{
  AuthCredential authCredential=PhoneAuthProvider.getCredential(
      verificationId: verifId,
      smsCode: smsCode);
  AuthResult authResult = await auth.signInWithCredential(authCredential);
  FirebaseUser user=authResult.user;
  String uid=user.uid;
  Map map={
    'nom':'',
    'prenom':'',
    'id':'',
    'compagnie':'',
    'telephone':'',
    'image':'',
    'type_utilisateur':'',
  };

}


//database
  static final base=FirebaseDatabase.instance.reference();
  static final data_instance = Firestore.instance;
  final base_user=base.child("utilisateur");
  final base_compagnie=base.child('compagnie');
  final base_trajet=base.child('trajet');
  final base_billet=base.child('billet');
  final fire_compagnie = data_instance.collection("compagnie");
  final fire_user =data_instance.collection("utilisateur");
  final fire_trajet=data_instance.collection("trajets");
  final fire_billet=data_instance.collection("billets");
  final fire_message=data_instance.collection('messages');
  final fire_conversation=data_instance.collection('conversations');
  final fire_chiffre=data_instance.collection('chiffres');

  //storage



  static final base_storage = FirebaseStorage.instance.ref();
  final StorageReference storage_profil = base_storage.child('photoprofil');





  addUser(String uid,Map <String,dynamic>map)
  {
    fire_user.document(uid).setData(map);
  }

  addCompagnie(Map <String,dynamic>map,String uid)
  {
    fire_compagnie.document(uid).setData(map);
  }

  addBillet(String uid,Map<String,dynamic>map)
  {
    fire_billet.document(uid).setData(map);
  }

  addChiffre(String uid,Map<String,dynamic>map)
  {
    fire_chiffre.document(uid).setData(map);
  }



  Future<String> myId() async{
    FirebaseUser user = await auth.currentUser();
    return user.uid;


  }


  Future <String> savePicture(File file,StorageReference storageReference) async{
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    StorageTaskSnapshot snapshot = await storageUploadTask.onComplete;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }





  Future<compagnie> getCompagnie(String uid) async{
    DataSnapshot snapshot = await base_compagnie.child(uid).once();
    return compagnie(snapshot);
  }






  Future<utilisateur> getUser(String uid) async
  {
    DocumentSnapshot snapshot = await fire_user.document(uid).get();
    return utilisateur(snapshot);
  }



  sendMessage(String texte,utilisateur user,utilisateur moi){
    print('passage');
    DateTime date=DateTime.now();
    Map <String,dynamic>map={
      'from':moi.id,
      'to':user.id,
      'texte':texte,
      'envoiMessage':date
    };
    print('passage2');
    String idDate = date.microsecondsSinceEpoch.toString();
    print('message');
    addMessage(map, getMessageRef(moi.id, user.id, idDate));
    print('conversation');
    addConversation(getConversation(moi.id, user, texte, date), moi.id);
    print('conversation 2');
    addConversation(getConversation(user.id, moi, texte, date), user.id);




  }

  Map getConversation(String sender,utilisateur partenaire,String texte,DateTime date){
    Map <String,dynamic> map = partenaire.toMap();
    map ['idmoi']=sender;
    map['lastmessage']=texte;
    map['envoimessage']=date;
    map['destinateur']=partenaire.id;

    return map;

  }


  String getMessageRef(String from,String to,String date){
    String resultat="";
    List<String> liste=[from,to];
    liste.sort((a,b)=>a.compareTo(b));
    for(var x in liste){
      resultat += x+"+";
    }
    resultat =resultat + date;
    return resultat;

  }



  addMessage(Map<String,dynamic> map,String uid){
    fire_message.document(uid).setData(map);

  }

  addConversation(Map<String,dynamic> map,String uid){
    fire_conversation.document(uid).setData(map);

  }







}