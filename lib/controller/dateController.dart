
import 'package:africars/controller/detailDateController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/billet.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class dateController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeDate();
  }

}

class homeDate extends State<dateController>{
  String identifiant;
  utilisateur profil;
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
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
          profil=user;
        });

      });

    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.orangeAccent,
      child: FirebaseAnimatedList(
          query: firebaseHelper().base_billet,
          defaultChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Il n' y a aucun achat effectué")
            ],
          ),
          itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double> animation,int index){
            billet ticket= billet(snapshot);
            if(ticket.idVoyageur==identifiant && ticket.validate==true)
              {
                return Card(
                  child: ListTile(
                    leading: Text("${formatjour.format(ticket.jourAller)}"),
                    title: Text("${ticket.lieuDepart}-${ticket.lieuArrivee}"),
                    trailing: Text("${formatheure.format(ticket.jourAller)}"),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context){
                            return detailDateController(ticket: ticket,);
                          }
                      ));

                    },
                  ),

                );
              }





          }
      )
    );
  }

}