
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class trajetController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeTrajet();
  }

}

class homeTrajet extends State<trajetController>{
  String depart = 'Départ';
  String arrivee ='Arrivée';
  DateTime momentDepart=DateTime.now();
  DateTime momentArrivee;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return bodyPage();
  }




  Widget bodyPage()
  {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),

      color: Colors.orange,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(10),),
          TextField(
            scrollPadding: EdgeInsets.all(10),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              hintText: depart,
              fillColor: Colors.white,
              filled: true,

            ),

            onChanged: (String value){
              setState(() {
                depart=value;
              });
            },

          ),
          Padding(padding: EdgeInsets.all(5)),

          TextField(
            scrollPadding: EdgeInsets.all(10),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              hintText: arrivee,
              fillColor: Colors.white,
              filled: true,

            ),
            onChanged: (String value){
              setState(() {
                arrivee=value;
              });
            },
          ),
          Padding(padding: EdgeInsets.all(10)),
          Text('Depart'),
          CalendarStrip(
              startDate: DateTime.now(),
              endDate: DateTime.now().add(Duration(days: 30)),
              onDateSelected: (selectDate){
                setState(() {
                  momentDepart=selectDate;

                });

              }
          ),
          Text('Heure'),
          //Liste déroulante chiffre
          Padding(padding: EdgeInsets.all(10)),
          Text('Arrivée'),
          CalendarStrip(


            startDate: momentDepart,
            endDate: momentDepart.add(Duration(days: 30)),
            onDateSelected: (selected){
              setState(() {
                momentArrivee =selected;
              });
            },
          ),
          Padding(padding: EdgeInsets.all(10),),
          RaisedButton(
              onPressed: (){
                //cheminement vers page selection trajet

              },
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black,
            elevation: 5,
            child: Text('Continuer',style: TextStyle(color: Colors.orange),),

          )
        ],
      ),

    );

  }


  swapVille(){
    String tempo;
    setState(() {
      tempo =depart;
      depart=arrivee;
      arrivee=tempo;
    });


  }

}