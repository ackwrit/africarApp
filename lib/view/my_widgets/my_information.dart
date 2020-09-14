import 'package:africars/view/my_widgets/constants.dart';
import 'package:flutter/material.dart';


class Myinformation extends StatefulWidget{
  String refbillet;
  Myinformation({this.refbillet});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyinformationState();
  }

}

class MyinformationState extends State<Myinformation>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: MediaQuery.of(context).size.height/1.7,
        width: MediaQuery.of(context).size.width,
        color: background,
        child:Container(
          padding: EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Text('Réservation effectué',style: TextStyle(fontSize: 25),),
              SizedBox(height: 15,),
              Text("Merci d'avoir effectué votre réservation n°${widget.refbillet}, Vous allez être appeller afin d'effectuer votre paiement.",style: TextStyle(fontSize: 18),),
              SizedBox(height: 15,),
              Text("Merci de vous prémunir du numéro de réservation n°${widget.refbillet} lors de l'appel",style: TextStyle(fontSize: 18),),



            ],
          ),
        )
    );

  }

}