

import 'package:africars/controller/singleTrajetController.dart';
import 'package:africars/fonction/conversion.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/compagnie.dart';
import 'package:africars/model/trajet.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';

class listingTrajet extends StatefulWidget{
  bool retour;
  String depart;
  String arrivee;
  DateTime heureDepart;
  DateTime HeureArrivee;
  int nombrepassager;
  
  listingTrajet({bool retour,String depart,String arrivee,DateTime heureDepart,DateTime heureArrivee,int nombrepassager}){
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
    return homeListing();
  }

}

class homeListing extends State<listingTrajet>{
  compagnie partenaire;
  String offrepartenaire,logoCompagnie;
  String nameCompagnie;

  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  DateTime heuredepart;
  DateTime heurearrivee;





  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.orange,
      body: bodyPage(),
    );
  }


  Widget bodyPage(){

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 5,
          ),
          FirebaseAnimatedList(
            padding: EdgeInsets.all(10),
              query: firebaseHelper().base_trajet,
              defaultChild: Text("Actuellement, il n'y a aucun trajet"),
              shrinkWrap: true,

              itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
                trajet trajetSelectionne = trajet(snapshot);

                heurearrivee= conversion().stringtoDateTime(trajetSelectionne.heureDestination);
                heuredepart =conversion().stringtoDateTime(trajetSelectionne.heureDepart);














                return GestureDetector(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.all(8)),
                        Text(formatjour.format(widget.heureDepart)),
                        ListTile(
                          title: Text("${trajetSelectionne.depart} - ${trajetSelectionne.destination}",textAlign: TextAlign.start,),
                          trailing: Text("${formatheure.format(heuredepart) }- ${formatheure.format(heurearrivee)}"),
                          subtitle: Text('prix : ${trajetSelectionne.prix} cfa'),

                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.network(trajetSelectionne.logoCompagnie,height: 100,width: 100,),
                            Text(trajetSelectionne.nomCompagnie),
                            //Text(logoCompagnie)





                          ],
                        ),
                      ],
                    ),


                  ),
                  onTap: (){
                    print('envoyer sur la page correspondante');
                    //Trajet Aller
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context)
                            {
                              return singleTrajetController(retour: widget.retour,trajets: trajetSelectionne,momentDepart: widget.heureDepart,momentArrivee: widget.HeureArrivee,nombrepassager: widget.nombrepassager,);
                            }
                    ));

                  },

                );




              }
          ),


        ],
      ),
    );
      
  }





}