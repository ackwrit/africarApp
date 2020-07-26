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
      backgroundColor: Colors.orange,
      body: bodyPage(),
    );
  }



  Widget bodyPage(){
    return
      Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            QrImage(
                data: widget.ticket.qrCodeAller,
              size: 80,
              version: QrVersions.auto,
            ),
            Text("${formatjour.format(widget.ticket.jourAller)}"),
            SizedBox(height: 20,),
            Text('${widget.ticket.lieuDepart} - ${widget.ticket.lieuArrivee}'),
            SizedBox(height: 20,),

            Text("${formatheure.format(widget.ticket.jourAller)}"),
            SizedBox(height: 20,),

          ],
        ),
      );
  }

}