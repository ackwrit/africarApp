
import 'package:africars/model/utilisateur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class firebaseHelper{
//authetification
final auth = FirebaseAuth.instance;
String verificationId;


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





  addUser(String uid,Map map)
  {
    base_user.child(uid).set(map);
  }


  Future<utilisateur> getUser(String uid) async
  {
    DataSnapshot snapshot = await base_user.child(uid).once();
    return utilisateur(snapshot);
  }





}