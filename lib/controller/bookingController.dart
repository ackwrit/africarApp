import 'dart:async';
import 'dart:io';

import 'package:africars/controller/infoPersoBilletController.dart';
import 'package:africars/controller/paymentController.dart';
import 'package:africars/controller/reservationController.dart';
import 'package:africars/fonction/conversion.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/trajet.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart';

class bookingController extends StatefulWidget{
  bool retour;
  trajet voyageAller;
  trajet voyageRetour;
  DateTime momentDepart;
  DateTime momentArrivee;
  DateTime momentDepartRetour;
  DateTime momentArriveeRetour;
  int nombrePassager;
  bookingController({trajet voyageAller,trajet voyageRetour,
    DateTime momentDepart,DateTime momentDepartRetour,DateTime momentArrivee,
  DateTime momentArriveeRetour,bool retour,int nombrePassager})
  {
    this.retour=retour;
    this.voyageAller=voyageAller;
    this.voyageRetour=voyageRetour;
    this.momentDepart=momentDepart;
    this.momentArrivee=momentArrivee;
    this.momentDepartRetour=momentDepartRetour;
    this.momentArriveeRetour=momentArriveeRetour;
    this.nombrePassager=nombrePassager;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeBooking();
  }

}

class homeBooking extends State<bookingController>{
  String generateQRCode=randomAlphaNumeric(20);
  String generateQRCodeRetour=randomAlphaNumeric(20);
  String refBillet=randomAlphaNumeric(13);
  utilisateur profil;
  String identifiant;
  var formatchiffre = new NumberFormat('#,###','fr_FR');
  int compteur=1;
  PhoneNumber number= PhoneNumber(isoCode: 'ML');

  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  String nom='Nom';
  String prenom='Prénom';
  FirebaseMessaging _fcm =FirebaseMessaging();
  StreamSubscription iosSubscription;
  @override
  void initState() {
    // TODO: implement initState



    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        centerTitle: true,
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),
    );
  }


  Widget bodyPage(){
    return Container(
      padding: EdgeInsets.all(20),

      width: MediaQuery.of(context).size.width,
      child:SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(height: 10,),
                  (widget.retour==true)?Text("Aller"):Text("Aller simple"),
                  Container(height: 10,),
                  Text("Référence du billet : $refBillet"),
                  Container(height: 10,),
                  Text(formatjour.format(widget.momentDepart)),
                  Container(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      QrImage(
                        data: generateQRCode,
                        version: QrVersions.auto,
                        size: 80.0,
                      ),
                      Text("${widget.voyageAller.depart} - ${widget.voyageAller.destination}",style: TextStyle(fontSize: 20),),


                    ],
                  ),
                  Container(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      (widget.voyageAller.logoCompagnie==null)?Container():Image.network(widget.voyageAller.logoCompagnie,height: 100,),
                      (widget.voyageAller.nomCompagnie==null)?Container():Text(widget.voyageAller.nomCompagnie),


                    ],


                  ),
                  Text("Départ : ${formatheure.format(widget.voyageAller.heureDepart)}",style: TextStyle(fontSize: 18),),
                  //Text("Arrivée : ${formatheure.format(widget.voyageAller.heureDestination)}",style: TextStyle(fontSize: 18)),
                  Container(height: 10,)





                ],

              ),
              elevation: 10,
            ),
            (widget.retour)?Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(height: 10,),
                  (widget.retour==true)?Text("Retour"):Text("Aller simple"),
                  Container(height: 10,),
                  Text("Référence du billet : $refBillet"),
                  Container(height: 10,),
                  Text(formatjour.format(widget.momentArrivee)),
                  Container(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      QrImage(
                        data: generateQRCodeRetour,
                        version: QrVersions.auto,
                        size: 80.0,
                      ),
                      Text("${widget.voyageRetour.depart} - ${widget.voyageRetour.destination}",style: TextStyle(fontSize: 20),),


                    ],
                  ),
                  Container(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      (widget.voyageRetour.logoCompagnie==null)?Container():Image.network(widget.voyageRetour.logoCompagnie,height: 100,),
                      (widget.voyageRetour.nomCompagnie==null)?Container():Text(widget.voyageRetour.nomCompagnie),


                    ],


                  ),
                  Text("Départ : ${formatheure.format(widget.voyageRetour.heureDepart)}",style: TextStyle(fontSize: 18),),
                  //Text("Arrivée : ${formatheure.format(widget.voyageRetour.heureDestination)}",style: TextStyle(fontSize: 18)),
                  Container(height: 10,)





                ],

              ),
              elevation: 10,
            )


                :Container(),


            SizedBox(height: 5,),
            InternationalPhoneNumberInput(
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
            SizedBox(height: 5,),
            Text('Passager',style: TextStyle(fontSize: 25),),


            SizedBox(height: 5,),

            ajout(),



           /* TextField(
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
            SizedBox(height: 15,),*/

            Image.asset("assets/logoorangemoney.jpeg",width: 180,),
            SizedBox(height: 15,),




            //reservation total;
            RaisedButton(
              color: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: (){
                print(widget.retour);
                //Enregistrement billet en mode provisoire
                Map <String,dynamic>map={
                  'emission':DateTime.now(),
                  'departAller':widget.voyageAller.depart,
                  'telephone':number.toString(),
                  'retourAller':(widget.retour)?widget.voyageAller.destination:'',
                  'departRetour':(widget.retour)?widget.voyageRetour.depart:'',
                  'retourRetour':(widget.retour)?widget.voyageRetour.destination:'',
                  'logoCompagnieAller':widget.voyageAller.logoCompagnie,
                  'logoCompagnieRetour':(widget.retour)?widget.voyageRetour.logoCompagnie:'',
                  'lieuDepart': widget.voyageAller.depart.toString(),
                  'lieuArrivee':widget.voyageAller.destination.toString(),
                  'nbPassager':widget.nombrePassager,
                  'nomPassager':nom,
                  'prenomPassager':prenom,
                  'qrCodeAller':generateQRCode,
                  'qrCodeRetour':(widget.retour)?generateQRCodeRetour:'',
                  'billerRetour':widget.retour,
                  'validate':false,
                  'jourAller':widget.momentDepart,
                  'jourRetour':(widget.retour)?widget.momentArrivee:DateTime.now(),

                };
                firebaseHelper().addBillet(refBillet, map);




                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return reservationController(refbillet: refBillet,);
                    }
                ));
              },
              child: Text('Réservation',style: TextStyle(color: Colors.white),),
            )

          ],
        ),
      ),


    );

  }

  Widget ajout()
  {


    return ListView.builder(
      itemCount: widget.nombrePassager,
        shrinkWrap: true,
        itemBuilder: (BuildContext context,int index){
        return Column(
          children: [
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2-30,
                  child:  TextField(
                    onChanged: (String text){
                      setState(() {
                        nom=text;
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: '$nom',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2-30,
                  child: TextField(
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
                ),





              ],
            ),
            SizedBox(height: 15,),
          ],


        );


        }
    );

  }



}