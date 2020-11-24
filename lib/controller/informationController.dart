import 'package:africars/controller/affichage_billet.dart';
import 'package:africars/controller/facture.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/billet.dart';
import 'package:africars/view/my_material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class informationController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeInformation();
  }

}

class homeInformation extends State<informationController>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return bodyPage();
  }



  Widget bodyPage(){
    return Container(
      color: background,
      child: StreamBuilder(
          stream: firebaseHelper().fire_billet.where('idvoyageur',isEqualTo:globalUser.id).where('validate',isEqualTo: true).snapshots(),
          builder: (BuildContext contex,AsyncSnapshot<QuerySnapshot>snapshot){
            if (!snapshot.hasData){
              return LoadingScaffold();
            }
            else{
              List<DocumentSnapshot> _documents= snapshot.data.documents;
              return ListView.builder(
                  itemCount: _documents.length,
                  itemBuilder: (BuildContext context,int index)
                  {
                    billet ticket=billet(_documents[index]);
                    String formatbarre=DateFormat("dd/MM/yyyy").format(ticket.depart);
                    return Card(
                      color: Colors.white,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        title: Text("${ticket.lieuDepart}-${ticket.lieuArrivee}"),
                        leading: Text(formatbarre),
                        subtitle:IconButton(
                          icon: Icon(Icons.article_rounded),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context){
                                  return facture(ticket: ticket,);
                                }
                            ));
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.qr_code_rounded),
                          onPressed: (){
                            //afiichage du billet
                            print('affichage billet');
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext ctx)
                                    {
                                      return affichageBillet(ticket: ticket,);
                                    }
                            ));
                          },
                        )
                      ),
                    );
                      
                  }
              );
            }
          }
      ),
    );
  }

}