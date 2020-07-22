import 'package:africars/controller/paymentController.dart';
import 'package:africars/controller/reservationController.dart';
import 'package:africars/fonction/conversion.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/billet.dart';
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
    this.billetRetour=billetRetour;

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
  billet creationBillet;
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Passager',style: TextStyle(fontSize: 25),),
          SizedBox(height: 15,),
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
              print(widget.billetRetour);
              //Enregistrement billet en mode provisoire
                Map map={
                  'emission':DateTime.now().toIso8601String(),
                  'departAller':widget.aller.depart,
                  'retourAller':(widget.billetRetour)?widget.aller.destination:'',
                  'departRetour':(widget.billetRetour)?widget.retour.depart:'',
                  'retourRetour':(widget.billetRetour)?widget.retour.destination:'',
                  'logoCompagnieAller':widget.aller.logoCompagnie,
                  'logoCompagnieRetour':(widget.billetRetour)?widget.retour.logoCompagnie:'',
                  'lieuDepart': widget.aller.depart.toString(),
                  'lieuArrivee':widget.aller.destination.toString(),
                  'nbPassager':widget.nombrePassager,
                  'nomPassager':nom,
                  'prenomPassager':prenom,
                  'qrCodeAller':widget.qrCodeAller,
                  'qrCodeRetour':(widget.billetRetour)?widget.qrCodeRetour:'',
                  'billerRetour':widget.billetRetour,
                  'validate':false,
                  'jourAller':widget.jourDepart.toIso8601String(),
                  'jourRetour':(widget.billetRetour)?widget.jourRetour.toIso8601String():'',

                };
                firebaseHelper().addBillet(widget.refBillet, map);


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