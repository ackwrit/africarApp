
import 'dart:convert';
import 'dart:io';

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
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class facture extends StatefulWidget{
  billet ticket;
  facture({this.ticket});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return factureState();
  }

}

class factureState extends State<facture> {
  String identifiant;
  utilisateur profil;
  bool useAvoir = false;
  bool affichageretour = false;
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  DateFormat formatminimum = DateFormat.yMd('fr_FR');

  @override
  void initState() {
    // TODO: implement initState
    firebaseHelper().myId().then((uid) {
      setState(() {
        identifiant = uid;
      });
      firebaseHelper().getUser(identifiant).then((user) {
        setState(() {
          globalUser = user;
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

  Widget bodyPage() {

    return Center(
        child: FlatButton(
          onPressed: ()=>listeFacture(),
          child: Text('Visionner Facture'),
        ),
    );
  }


  listeFacture() async {
    print(widget.ticket.idFacture);

    String url=widget.ticket.idFacture+".pdf?api_token=QSTCsbbtRLNYBVUhoyT3";
    print(url);
    String urls="https://k-b-k-services-groupes.vosfactures.fr/invoices/"+url;
    print(urls);
    if (await canLaunch(urls)) {
      await launch(urls);
    }



  }
}














