
import 'package:africars/controller/detailDateController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/billet.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:africars/view/my_widgets/loading_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
    return (globalUser==null)?Container(
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.width/2,
      color: background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Aucune Réservation',style: TextStyle(fontSize: 40),),
          SizedBox(height: 20,),
          Image.asset('assets/nodata.png',width: 200,height: 200,),

        ],
      ),


    ):
    StreamBuilder(
        stream: firebaseHelper().fire_billet.snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(!snapshot.hasData){
            return LoadingCenter();

          }
          else
          {
            List<DocumentSnapshot>documents =snapshot.data.documents;
            return NestedScrollView(
                headerSliverBuilder: (BuildContext build,bool srolled){
                  return [
                    SliverAppBar(
                      leading: Container(),
                      pinned: true,
                      backgroundColor: Colors.orangeAccent,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('Les billets'),
                        centerTitle: true,
                        




                      ),


                    ),


                  ];
                },

                body: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext ctx,int index){
                      billet entreprise=billet(documents[index]);

                      if(entreprise.idVoyageur==identifiant){
                        return InkWell(
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: Text("${formatminimum.format(entreprise.depart)}"),
                              title: Text("${entreprise.lieuDepart} - ${entreprise.lieuArrivee} "),
                             trailing:(entreprise.validate)?Icon(FontAwesome.check,color: Colors.green,):Icon(FontAwesome.history,color: Colors.orange,),
                             // trailing: Text('Date : ${formatjour.format(entreprise.depart)} - ${formatheure.format(entreprise.depart)}'),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context){
                                  return detailDateController(ticket:entreprise,validation: entreprise.validate,);
                                }
                            ));

                          },
                        );

                      }
                      else
                      {
                        return Container();
                      }



                    }
                ));
          }
        }
    );
  }

}