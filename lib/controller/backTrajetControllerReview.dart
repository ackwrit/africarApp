import 'package:africars/controller/bookingController.dart';
import 'package:africars/fonction/conversion.dart';
import 'package:africars/model/trajet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'backTrajetController.dart';

class backTrajetControllerReview extends StatefulWidget{
  bool retour;
  trajet voyageAller;
  trajet voyageRetour;
  DateTime momentDepart;
  DateTime momentArrivee;
  int nombrepassager;

  backTrajetControllerReview({bool retour,trajet trajetsRetour,DateTime momentDepart,DateTime momentArrivee,int nombrepassager,trajet trajetAller})
  {
    this.retour=retour;
    this.voyageRetour=trajetsRetour;
    this.voyageAller=trajetAller;
    this.momentDepart=momentDepart;
    this.momentArrivee=momentArrivee;
    this.nombrepassager=nombrepassager;

  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeReviewBack();
  }

}

class homeReviewBack extends State<backTrajetControllerReview>{
  int bagage =0;
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
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
    //DateTime heuredepart=conversion().stringtoDateTime(widget.voyageRetour.heureDepart);
    //DateTime heureArrivee = conversion().stringtoDateTime(widget.voyageRetour.heureDestination);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Container(
                  height: 10,
                ),
                Text("${widget.voyageAller.destination} - ${widget.voyageAller.depart}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(widget.voyageRetour.logoCompagnie,height: 120,width: 120,),
                    Text(widget.voyageRetour.nomCompagnie)
                  ],
                ),
                Text("${formatjour.format(widget.momentArrivee)}",style: TextStyle(fontSize: 22),),
                Container(height: 20,),
                Text('Départ :  ${formatheure.format(widget.voyageRetour.heureDepart)}',style: TextStyle(fontSize: 18), ),
                //Container(height: 10,),
                //Text('Arrivée : ${formatheure.format(widget.voyageRetour.heureDestination)}',style: TextStyle(fontSize: 18), ),
                Container(height: 15,),
                Text("Nombre de passager(s) : ${widget.nombrepassager}",style:TextStyle(fontSize: 15)),
                Container(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: (bagage<=1)?Text('bagage suplémentaire : $bagage'):Text('bagages supplémentaires : $bagage'),
                      ),
                      Container(
                        child: Row(
                          children: [

                            IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: (){
                                  setState(() {

                                    if(bagage==0)
                                    {
                                      bagage=0;
                                    }
                                    else
                                    {
                                      bagage=bagage-1;
                                    }
                                  });
                                }
                            ),
                            Text('$bagage'),
                            IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: (){
                                  //augmentation
                                  setState(() {
                                    bagage=bagage+1;
                                  });
                                }
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                ),
                Text('Prix ${widget.voyageAller.prix} cfa'),
                Container(height: 10,),
                RaisedButton(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Text('Valider',style:TextStyle(color: Colors.orange),),
                    onPressed: (){

                      //déterminer choix si voyage de retour
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context){
                            return
                            bookingController(voyageRetour:widget.voyageRetour,retour: widget.retour,voyageAller: widget.voyageAller,momentDepart: widget.momentDepart,momentArrivee: widget.momentArrivee,nombrePassager: widget.nombrepassager,);
                          }
                      ));
                    }
                ),

              ],

            ),
          )

      ) ,
    );

  }

}