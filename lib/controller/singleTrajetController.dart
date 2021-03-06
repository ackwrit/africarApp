import 'package:africars/controller/bookingController.dart';
import 'package:africars/fonction/conversion.dart';
import 'package:africars/model/trajet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'backTrajetController.dart';

class singleTrajetController extends StatefulWidget{
  bool retour;
  trajet voyage;
  DateTime momentDepart;
  DateTime momentArrivee;
  int nombrepassager;

  singleTrajetController({bool retour,trajet trajets,DateTime momentDepart,DateTime momentArrivee,int nombrepassager})
  {
    this.retour=retour;
    this.voyage=trajets;
    this.momentDepart=momentDepart;
    this.momentArrivee=momentArrivee;
    this.nombrepassager=nombrepassager;

  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeSingle();
  }

}

class homeSingle extends State<singleTrajetController>{
  int bagage =0;
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  var formatchiffre =new NumberFormat('#,###','fr_FR');
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
    appBar: AppBar(
      title: Image.asset("assets/newlogo.jpg",height: 225,),
      backgroundColor: Colors.black,
      centerTitle: true,

    ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),

    );
  }




  Widget bodyPage(){

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
              Text("${widget.voyage.depart} - ${widget.voyage.destination}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  (widget.voyage.logoCompagnie==null)?Container():Image.network(widget.voyage.logoCompagnie,height: 120,width: 120,),
                  (widget.voyage.nomCompagnie==null)?Container():Text(widget.voyage.nomCompagnie)
                ],
              ),
              Text("${formatjour.format(widget.momentDepart)}",style: TextStyle(fontSize: 22),),
              Container(height: 20,),
              Text('Départ :  ${formatheure.format(widget.voyage.heureDepart)}',style: TextStyle(fontSize: 18), ),
             // Container(height: 10,),
             // Text('Arrivée : ${formatheure.format(heureArrivee)}',style: TextStyle(fontSize: 18), ),
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
              Text('Prix ${formatchiffre.format(widget.voyage.prix)} cfa'),
              Container(height: 10,),
              RaisedButton(
                color: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Text('Valider',style:TextStyle(color: Colors.white),),
                  onPressed: (){
                  
                  //déterminer choix si voyage de retour
                    Navigator.push(context, MaterialPageRoute(
                       builder: (BuildContext context){
                         return (widget.retour)?
                             //backsignleController
                         backTrajetController(trajetAller:widget.voyage,retour: widget.retour,depart: widget.voyage.depart,arrivee: widget.voyage.destination,heureArrivee: widget.momentArrivee,heureDepart: widget.momentDepart,nombrepassager: widget.nombrepassager,momenDepart: widget.momentDepart,momentArrivee: widget.momentArrivee,)
                         :
                         //booking billet
                         bookingController(retour: widget.retour,voyageAller: widget.voyage,momentDepart: widget.momentDepart,momentArrivee: widget.momentArrivee,nombrePassager: widget.nombrepassager,);
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