import 'package:africars/fonction/conversion.dart';
import 'package:africars/model/billet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class detailDateController extends StatefulWidget{
  billet ticket;
  detailDateController({billet ticket})
  {
    this.ticket=ticket;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return homeDetail();
  }

}

class homeDetail extends State<detailDateController>{
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),
    );
  }



  Widget bodyPage(){
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20,),
            Text("billet crée le ${formatjour.format(widget.ticket.emission)} à ${formatheure.format(widget.ticket.emission)}"),
            SizedBox(height: 20,),

            QrImage(
              data: widget.ticket.qrCodeAller,
              size: 100,
              version: QrVersions.auto,
            ),

            SizedBox(height: 20,),
            Text("Départ : ${formatjour.format(widget.ticket.jourAller)} à ${formatheure.format(widget.ticket.jourAller)}",style: TextStyle(fontSize: 20),),
            SizedBox(height: 20,),
            Text('${widget.ticket.lieuDepart} - ${widget.ticket.lieuArrivee}',style: TextStyle(fontSize: 25),),
            SizedBox(height: 20,),



            Image.network(widget.ticket.logoCompagnieAller,height: 120,width: 120,),
            SizedBox(height: 20,),
            Text("nombre de passager: ${widget.ticket.nbPassager.toString()}",style: TextStyle(fontSize: 18),),



          ],
        ),
      ),
    );

  }

}