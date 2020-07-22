import 'package:africars/controller/paymentController.dart';
import 'package:africars/controller/reservationController.dart';
import 'package:africars/fonction/conversion.dart';
import 'package:africars/model/trajet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart';

class infoPersoBilletController extends StatefulWidget{
  bool billetRetour;
  trajet aller;
  trajet retour;
  String qrCodeAller;
  String qrCodeRetour;
  String refBillet;
  int nombrePassager;
  DateTime jourDepart;
  DateTime jourRetour;



  infoPersoBilletController(
      {
        bool billetRetour,
        trajet aller,
        trajet retour,
        String qrCodeAller,
        String qrCodeRetour,
        String refBillet,
        int nombrePassager,
        DateTime jourDepart,
        DateTime jourRetour,
      })
  {
    this.aller=aller;
    this.retour=retour;
    this.qrCodeAller=qrCodeAller;
    this.qrCodeRetour=qrCodeRetour;
    this.refBillet=refBillet;
    this.nombrePassager=nombrePassager;
    this.jourDepart=jourDepart;
    this.jourRetour=jourRetour;

  }


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeInfoPerso();
  }

}

class homeInfoPerso extends State<infoPersoBilletController>{


  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  String nom='Nom';
  String prenom='Prénom';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        centerTitle: true,
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.orange,
      body: bodyPage(),
    );
  }


  Widget bodyPage(){
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (String text){
              setState(() {
                nom=text;
              });
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: nom,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),

          ),
          SizedBox(height: 15,),
          TextField(
            onChanged: (String text){
              setState(() {
                prenom=text;
              });
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: prenom,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),

          ),
          SizedBox(height: 15,),
          RaisedButton(
            color: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: (){
              //Enregistrement billet en mode provisoire

                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return reservationController();
                    }
                ));
              },
            child: Text('Paiement',style: TextStyle(color: Colors.orange),),
          )

        ],
      ),
    );
      
  }
}