
import 'package:africars/controller/detailDateController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/billet.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:africars/view/my_widgets/loading_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class affichageBillet extends StatefulWidget{
  billet ticket;
  affichageBillet({this.ticket});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return affichageBilletState();
  }

}

class affichageBilletState extends State<affichageBillet>{
  String identifiant;
  utilisateur profil;
  bool useAvoir=false;
  bool affichageretour=false;
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  DateFormat formatminimum = DateFormat.yMd('fr_FR');
  @override
  void initState() {
    // TODO: implement initState
    firebaseHelper().myId().then((uid)
    {
      setState(() {
        identifiant=uid;
      });
      firebaseHelper().getUser(identifiant).then((user)
      {
        setState(() {
          globalUser=user;
        });

      });

    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: imagebar,
        backgroundColor: backgroundbar,
      ),
      backgroundColor: background,
      body: bodyPage(),
    );
  }



  Widget bodyPage(){
    return Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("${widget.ticket.nomPassager}  ${widget.ticket.prenomPassager}",style:TextStyle(fontSize: 25)),
          (widget.ticket.billetRetour)?Text("${widget.ticket.lieuArrivee}-${widget.ticket.lieuDepart}",style: TextStyle(fontSize: 25),):Text("${widget.ticket.lieuDepart}-${widget.ticket.lieuArrivee}",style: TextStyle(fontSize: 25),),
          QrImage(
            data: (widget.ticket.billetRetour)?widget.ticket.qrCodeRetour:widget.ticket.qrCodeAller,
            version: QrVersions.auto,
            size: 120.0,
          ),
          Text('Depart',style: TextStyle(fontSize: 25),),
          (widget.ticket.billetRetour)?Text(formatjour.format(widget.ticket.retour),style: TextStyle(fontSize: 25),):Text(formatjour.format(widget.ticket.depart),style: TextStyle(fontSize: 25),),
          Text('Heure',style: TextStyle(fontSize: 25),),
          (widget.ticket.billetRetour)?Text(formatheure.format(widget.ticket.retour),style: TextStyle(fontSize: 25),):Text(formatheure.format(widget.ticket.depart),style: TextStyle(fontSize: 25),),





          
          
          (widget.ticket.billetRetour)?RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 5.0,
              color: backgroundbar,
              onPressed: (){
              setState(() {
                affichageretour=!affichageretour;
              });
                
              },
            child:(affichageretour)?Text('Billet retour',style: TextStyle(color: background),):Text('Billet Aller',style: TextStyle(color: background),),
          ):Container(),
        ],
      ),
    );
  }

}