
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class trajetController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeTrajet();
  }

}

class homeTrajet extends State<trajetController>{
  TextEditingController depart = new TextEditingController(text: 'Depart');
  TextEditingController arrivee =new TextEditingController(text: 'Arrivée');
  DateTime momentDepart=DateTime.now();
  DateTime momentArrivee=DateTime.now();
  DateFormat formatjour;
  DateFormat formatheure;
  String destinationSelectionDepart='Choisir votre départ';
  String destinationSelectionArrivee='Choisir votre arrivée';
  List <String> destination=[
    'Bamako','Bandiagara','Béma','Bla','Boni','Bougouni',
    'Diabé','Diboli','Didjan','Didjeni','Diéma','Dioïla','Djenné','Douentza',
    'Fana','Fatoma',
    'Gao','Gossi',
    'Hombori',
    'Kayes','Kéniéba','Kidal','Kita','Koffi','Kona','Konobougou','Koulikoro','Koury','Koutiala',
    'Labbezanga','Lakamani',
    'Mbessoba','Ménaka','Mopti',
    'Niéna',
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override


  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR');
    formatjour= DateFormat.yMMMMd('fr_FR');
    formatheure = DateFormat.Hm('fr_FR');


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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Départ : '),
              DropdownButton <String>(
                  items: destination.map((String value) {
                    return DropdownMenuItem(
                        value: value,

                        child: Text(value)
                    );
                  }).toList(),
                  hint:Text(destinationSelectionDepart),
                  onChanged: (newVal){
                    setState(() {
                      destinationSelectionDepart=newVal;
                    });
                  }
              ),
            ],
          ),


          Padding(padding: EdgeInsets.all(2)),
          IconButton(icon: Icon(Icons.swap_vertical_circle),
              onPressed: ()=>swapVille()
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Arrivée : '),
              DropdownButton <String>(


                  items: destination.map((String value) {
                    return DropdownMenuItem(



                        value: value,

                        child: Text(value)
                    );
                  }).toList(),
                  hint:Text(destinationSelectionArrivee),
                  
                  onChanged: (newVal){
                    setState(() {
                      destinationSelectionArrivee=newVal;
                    });
                  }
              ),
            ],
          ),


          TextField(
            controller: arrivee,
            scrollPadding: EdgeInsets.all(10),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),

              fillColor: Colors.white,
              filled: true,

            ),
            onChanged: (String prevalue){
              setState(() {
                arrivee.text=prevalue;
              });
            },
          ),
           Padding(padding: EdgeInsets.all(10),),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               Text('Aller'),
               Text(formatjour.format(momentDepart)),


               FlatButton(
                   onPressed:()=>affichageSnackBar('depart'),

                   child: Text(formatheure.format(momentDepart)),

               ),


             ],
           ),



          Padding(padding: EdgeInsets.all(10),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Retour'),
              Text(formatjour.format(momentDepart)),


              FlatButton(
                onPressed:()=>affichageSnackBar('arrivee'),

                child: Text(formatheure.format(momentArrivee)),

              ),


            ],
          ),
          Padding(padding: EdgeInsets.all(10),),

          RaisedButton(
              onPressed: (){
                //cheminement vers page selection trajet

              },
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black,
            elevation: 5,
            child: Text('Réservation',style: TextStyle(color: Colors.orange),),

          )
        ],
      ),

    );

  }


  swapVille(){
    TextEditingController tempo = new TextEditingController();
    setState(() {
      tempo =depart;
      depart=arrivee;
      arrivee=tempo;
    });


  }

  affichageSnackBar(String periode)
  {

    final snackbar =SnackBar(
      duration: Duration(seconds: 30),
        backgroundColor: Colors.orangeAccent,
        content: Container(

          height: MediaQuery.of(context).size.height/2,

          child: Column(
            children: [
              Text('Horaire'),

              CalendarStrip(
                containerHeight: 100,

                  onDateSelected: (heure)
                      {
                        if(periode=='depart')
                          {
                            setState(() {
                              momentDepart=heure;
                            });

                          }
                        else
                          {
                            setState(() {
                              momentArrivee=heure;
                            });
                          }

                      }
              ),
              Padding(padding: EdgeInsets.all(10),),
              TimePickerSpinner(
                isForce2Digits: true,
                minutesInterval: 15,
                highlightedTextStyle: TextStyle(color: Colors.black,fontSize: 30),
                normalTextStyle: TextStyle(color: Colors.white,fontSize: 20),
                onTimeChange: (time)
                {
                  if(periode=='depart')
                    {
                      DateTime hour = new DateTime(momentDepart.year,momentDepart.month,momentDepart.day,time.hour,time.minute);
                      setState(() {
                        momentDepart=hour;
                      });
                    }
                  else
                    {
                      DateTime hour = new DateTime(momentArrivee.year,momentArrivee.month,momentArrivee.day,time.hour,time.minute);
                      setState(() {
                        momentArrivee=hour;
                      });

                    }
                },

              ),

            ],
          ),
        ),
      action: SnackBarAction(
          label: '',
          onPressed: (){
            print('excéution');
          })

    );
    Scaffold.of(context).showSnackBar(snackbar);


  }

}