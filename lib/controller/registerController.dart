
import 'package:africars/controller/listingTrajet.dart';
import 'package:africars/controller/settingsProfilController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/view/my_material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class registerController extends StatefulWidget{
  bool retour;
  String depart;
  String arrivee;
  DateTime heureDepart;
  DateTime HeureArrivee;
  int nombrepassager;
  registerController({bool retour,String depart,String arrivee,DateTime heureDepart,DateTime heureArrivee,int nombrepassager})
  {
    this.retour =retour;
    this.depart=depart;
    this.arrivee=arrivee;
    this.heureDepart=heureDepart;
    this.HeureArrivee=heureArrivee;
    this.nombrepassager=nombrepassager;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeRegister();
  }

}

class homeRegister extends State<registerController>{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final auth=FirebaseAuth.instance;
  String identifiant;

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number= PhoneNumber(isoCode: 'ML');
  String phone;
  String nom='';
  String prenom='';
  String smsCode,verificationId;
  bool codeSent=false;
  bool sexe=false;
  bool passage=false;
  DateTime naissance=DateTime.now();
  DateFormat formatjour;
  DateFormat formatheure;
  DateFormat formatmois;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseHelper().myId().then((value){
      setState(() {
        identifiant=value;
      });
      firebaseHelper().getUser(identifiant).then((value){
        setState(() {
          globalUser = value;
        });
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR');
    formatjour= DateFormat.yMMMMd('fr_FR');
    formatheure = DateFormat.Hm('fr_FR');
    formatmois = DateFormat.M('fr_FR');
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Incription'),
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),
    );
  }





  Widget bodyPage(){
    return SingleChildScrollView(
      child:Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: (()=>FocusScope.of(context).requestFocus(FocusNode())),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text('Inscription',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              ),
              TextField(
                onChanged: (text){
                  setState(() {
                    nom=text;
                    passage=false;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: 'Entre votre nom',
                  fillColor: Colors.white,
                  filled: true,

                ),
              ),

              (nom==null || nom=='')?Container():TextField(
                onChanged: (text){
                  setState(() {
                    prenom=text;
                    passage=false;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: 'Entre votre prénom',
                  fillColor: Colors.white,
                  filled: true,

                ),
              ),
              (prenom==null||prenom =='')?Container():Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Homme'),
                  Switch.adaptive(
                      value: sexe,
                      onChanged: (bool t){
                        setState(() {
                          sexe =t;
                        });

                      }),
                  Text('Femme')

                ],
              ),
              (prenom==null||prenom =='')?Container():RaisedButton.icon(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: backgroundbar,
                  elevation: 5.0,
                  icon: Icon(Icons.access_time,color: background,),
                  onPressed: (){
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1918, 1, 1),
                        maxTime: DateTime(2030, 6, 7),

                        onConfirm: (DateTime date) {
                          setState(() {
                            naissance=date;
                          });
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.fr,
                    );
                    setState(() {
                      passage=true;
                    });
                  },
                  label: Text('Date de naissance :  ${formatjour.format(naissance)}',style: TextStyle(color:background,fontSize: 18),)
              ),








              (prenom==null||prenom =='')?Container():InternationalPhoneNumberInput(
                initialValue: number,
                onInputChanged: (text){
                  number=text;
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

              (codeSent)?TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    hintText: 'Entrer le code'

                ),
                onChanged: (value){
                  setState(() {
                    smsCode=value;
                  });
                },

              ):Container(),

              (passage)?FlatButton(
                  onPressed: (){
                    print(number.phoneNumber.trim());
                    print(number.toString().trim());
                    print(number.phoneNumber);
                    (codeSent)?handleOTP(smsCode, verificationId):handleSignWithSign(number.toString().trim());


                    //firebaseHelper().handleSignPhone(number.toString());
                  },
                  child: (codeSent)?Text('Enregister'):Text('Validation')


              ):Container(),

            ],
          ),

        ),

      )
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
      timeout: Duration(seconds: 20),
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
  Map <String,dynamic>map ={
    'uid':uid,
    'login':'',
    'prenom':prenom,
    'nom':nom,
    'mail':'',
    'telephone':number.phoneNumber,
    'typeUtilisateur':'particulier',
    'sexe':(sexe)?'Femme':'Homme',
    'naissance':naissance,
    'avoir':0,
    'id':uid,


  };
  firebaseHelper().addUser(uid, map);
  Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context){
        return (widget.depart!=null)?listingTrajet(
          retour: widget.retour,
          depart: widget.depart,
          arrivee: widget.arrivee,
          heureArrivee: widget.HeureArrivee,
          heureDepart: widget.heureDepart,
          nombrepassager: widget.nombrepassager,
        ):settingsProfilController();
      }
  ));
}

}