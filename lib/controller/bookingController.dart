import 'package:africars/controller/paymentController.dart';
import 'package:africars/controller/reservationController.dart';
import 'package:africars/fonction/conversion.dart';
import 'package:africars/model/trajet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String refBilletRetour=randomAlphaNumeric(13);
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
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
                      Image.network(widget.voyageAller.logoCompagnie,height: 100,),
                      Text(widget.voyageAller.nomCompagnie),


                    ],


                  ),
                  Text("Départ : ${formatheure.format(conversion().stringtoDateTime(widget.voyageAller.heureDepart))}",style: TextStyle(fontSize: 18),),
                  Text("Arrivée : ${formatheure.format(conversion().stringtoDateTime(widget.voyageAller.heureDestination))}",style: TextStyle(fontSize: 18)),
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
                  Text("Référence du billet : $refBilletRetour"),
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
                      Image.network(widget.voyageRetour.logoCompagnie,height: 100,),
                      Text(widget.voyageRetour.nomCompagnie),


                    ],


                  ),
                  Text("Départ : ${formatheure.format(conversion().stringtoDateTime(widget.voyageRetour.heureDepart))}",style: TextStyle(fontSize: 18),),
                  Text("Arrivée : ${formatheure.format(conversion().stringtoDateTime(widget.voyageRetour.heureDestination))}",style: TextStyle(fontSize: 18)),
                  Container(height: 10,)





                ],

              ),
              elevation: 10,
            )


                :Container(),
            RaisedButton(onPressed: (){
              //partie paiement
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context)
                      {
                        return reservationController();
                      }
              ));


            },
              elevation: 10,
              child: Text('Réservation',style: TextStyle(color: Colors.orange),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.black,
            )
          ],
        ),
      ),


    );

  }

}