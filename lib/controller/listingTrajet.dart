import 'package:africars/controller/singleTrajetController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/compagnie.dart';
import 'package:africars/model/trajet.dart';
import 'package:africars/view/my_material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String heuredepart;
  String heurearrivee;





  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),
    );
  }


  Widget bodyPage(){

    return StreamBuilder<QuerySnapshot>
      (
        stream:firebaseHelper().fire_trajet.snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot>snapshot){
          if (!snapshot.hasData){
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
                        title: Text('Les trajets'),
                        centerTitle: true,



                      ),

                    )

                  ];
                },

                body: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext ctx,int index){
                      trajet entreprise = trajet(documents[index]);
                      if(entreprise.depart==widget.depart && entreprise.destination==widget.arrivee)
                        {
                          return GestureDetector(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Padding(padding: EdgeInsets.all(2)),
                                  Text(formatjour.format(widget.heureDepart)),
                                  ListTile(
                                    title: Text("${entreprise.depart} - ${entreprise.destination}",textAlign: TextAlign.start,),

                                    trailing: Text(formatheure.format(entreprise.heureDepart)),
                                    subtitle: Text('prix : ${entreprise.prix} CFA'),

                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.network(entreprise.logoCompagnie,height: 80,width: 80,),
                                      Text(entreprise.nomCompagnie),
                                      //Text(logoCompagnie)





                                    ],
                                  ),
                                ],
                              ),


                            ),
                            onTap: (){

                              //Trajet Aller
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context)
                                  {
                                    return singleTrajetController(retour: widget.retour,trajets: entreprise,momentDepart: widget.heureDepart,momentArrivee: widget.HeureArrivee,nombrepassager: widget.nombrepassager,);
                                  }
                              ));

                            },

                          );

                        }
                      else
                        {
                          return Container();
                        }
                      /*return InkWell(
                          onTap: (){
                            //print('direction page détail voyageur');
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context)
                                {
                                  //return detailTrajetController(entreprise);
                                }
                            ));
                          },
                          child: Card(
                              child: ListTile(
                                leading:Image.network(entreprise.logoCompagnie),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entreprise.nomCompagnie),
                                    Text("${entreprise.depart} - ${entreprise.destination}"),
                                    Text("Prix : ${entreprise.prix.toString()} CFA")

                                  ],
                                ),

                                trailing: Text("Départ : ${formatheure.format(entreprise.heureDepart)}"),
                              )

                          )

                      );*/



                    }
                ));
          }
        });




      
  }





}