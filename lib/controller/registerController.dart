

import 'package:africars/controller/administrationController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class registerController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeRegister();
  }

}

class homeRegister extends State<registerController>{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final auth=FirebaseAuth.instance;

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number= PhoneNumber(isoCode: 'ML');
  String smsCode,verificationId;
  bool codeSent=false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.orange,
      body: bodyPage(),
    );
  }





  Widget bodyPage(){
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return administrationController();
                    }
                ));
              },
              child: Text('Professionnel')
          ),
          Padding(padding: EdgeInsets.all(10)),
          InternationalPhoneNumberInput(
            initialValue: number,
            onInputChanged: (text){
              number =text;
            },
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            inputDecoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              )
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          (codeSent)?TextField(
            decoration: InputDecoration(

              hintText: 'Entrer le code'

            ),
            onChanged: (value){
              setState(() {
                smsCode=value;
              });
            },

          ):Container(),
        
          FlatButton(
            onPressed: (){
              (codeSent)?handleOTP(smsCode, verificationId):handleSignWithSign(number.toString());


                //firebaseHelper().handleSignPhone(number.toString());
            },
            child: Text('Validation')
              

          ),

        ],
      ),
    );

  }







  //authentification
Future <void> handleSignWithSign(phone)async
{
  final PhoneVerificationCompleted verified = (AuthCredential credential){
    auth.signInWithCredential(credential);

  };

  final PhoneVerificationFailed failed =(AuthException exception){
    print(exception);
  };


  final PhoneCodeSent phoneCodeSent =(String verifId,[int forceResend]){
    this.verificationId = verifId;
    setState(() {
      codeSent=true;
    });


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


Future <void> handleOTP(smsCode,verifId) async{
  AuthCredential authCredential=PhoneAuthProvider.getCredential(
      verificationId: verifId,
      smsCode: smsCode);
  AuthResult authResult= await FirebaseAuth.instance.signInWithCredential(authCredential);
  FirebaseUser user =authResult.user;
  String uid = user.uid;
  Map map ={
    'uid':uid,
    'login':'',
    'prenom':'',
    'nom':'',
    'mail':'',
    'typeUtilisateur':''

  };
  firebaseHelper().addUser(uid, map);
}

}