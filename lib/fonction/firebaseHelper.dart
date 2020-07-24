
import 'dart:io';

import 'package:africars/model/billet.dart';
import 'package:africars/model/compagnie.dart';
import 'package:africars/model/trajet.dart';
import 'package:africars/model/utilisateur.dart';
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
  addCompagnie(uid, map);
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
  final base_user=base.child("utilisateur");
  final base_compagnie=base.child('compagnie');
  final base_trajet=base.child('trajet');
  final base_billet=base.child('billet');

  //storage



  static final base_storage = FirebaseStorage.instance.ref();
  final StorageReference storage_profil = base_storage.child('photoprofil');





  addUser(String uid,Map map)
  {
    base_user.child(uid).set(map);
  }

  addCompagnie(String uid,Map map)
  {
    base_compagnie.child(uid).set(map);
  }

  addBillet(String uid,Map map)
  {
    base_billet.child(uid).set(map);
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



  Future<billet> getBillet(String uid) async{
    DataSnapshot snapshot = await base_compagnie.child(uid).once();
    return billet(snapshot);
  }

  Future<compagnie> getCompagnie(String uid) async{
    DataSnapshot snapshot = await base_compagnie.child(uid).once();
    return compagnie(snapshot);
  }






  Future<utilisateur> getUser(String uid) async
  {
    DataSnapshot snapshot = await base_user.child(uid).once();
    return utilisateur(snapshot);
  }


  addTrajet(String uid,Map map)
  {
    base_trajet.child(uid).set(map);
  }

  Future<trajet> getTrajet(String uid) async{
    DataSnapshot snapshot = await base_trajet.child(uid).once();
    return trajet(snapshot);
  }


}