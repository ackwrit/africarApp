import 'package:africars/controller/listingTrajet.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class trajetInternationalController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeInternational();
  }

}

class homeInternational extends State<trajetInternationalController>{
  TextEditingController depart = new TextEditingController(text: 'Depart');
  TextEditingController arrivee =new TextEditingController(text: 'Arrivée');
  DateTime momentDepart=DateTime.now();
  DateTime momentArrivee=DateTime.now();
  DateFormat formatjour;
  DateFormat formatheure;
  bool retour=false;
  int nbpassager=1;
  String destinationSelectionDepart='Choisir votre départ';
  String destinationSelectionArrivee='Choisir votre arrivée';
  List <String> destination=[
    'Cotonou',
    'Bobo djoulassa','Ouagadougou',
    'Abidjan','Bouaké','Daloa','Féréké Dougou','Wangolo','Yamoussokoro','Zékoua',
    'Banjul',
    'Accra','Koumassi',
    'Conakry','Divo','Siguiri','Vava',
    'Bamako','Bougouni','Dioïla','Gao','Kayes','Kidal','Koulikoro','Ménaka','Mopti','Nioro du Sahel','Ségou','Sikasso','Taoudénit','Tombouctou',
    'Aleg','Ayoune','Boutilimite','Gogui','Kiffa','Nouakchott','Tintane',
    'Niamey',
    'Dakar','Goudire','Kafrine','Kaolack','Kidira',"M'bour",'Tamba','Thiès',
    'Lomé'
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('Départ : '),
                  DropdownButton <String>(
                      underline: Container(
                        height: 0,
                      ),
                      iconSize: 0,
                      items: destination.map((String value) {
                        return DropdownMenuItem(
                            value: value,

                            child: Text(value)
                        );
                      }).toList(),
                      hint: Text(destinationSelectionDepart),
                      onChanged: (newVal){
                        setState(() {
                          destinationSelectionDepart=newVal;
                        });
                      }
                  ),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.swap_vertical_circle),
                onPressed: ()=>swapVille()
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Arrivée : '),
                  DropdownButton <String>(
                      underline: Container(
                        height: 0,
                      ),
                      iconSize: 0,



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
            ),
            Container(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
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
            ),

            Padding(padding: EdgeInsets.all(10),),
            Text('Souhaitez-vous un retour ? '),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Non'),
                Switch.adaptive(
                    value: retour,
                    onChanged: (bool t){
                      setState(() {
                        retour =t;
                      });

                    }),
                Text('Oui')

              ],
            ),
            Padding(padding: EdgeInsets.all(2),),
            Container(
              child: (retour)?Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Retour'),
                  Text(formatjour.format(momentArrivee)),


                  FlatButton(
                    onPressed:()=>affichageSnackBar('arrivee'),

                    child: Text(formatheure.format(momentArrivee)),

                  ),


                ],
              ):Container(),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),

            ),
            Container(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: (nbpassager==1)?Text('Passager : $nbpassager'):Text('Passagers : $nbpassager'),
                  ),
                  Container(
                    child: Row(
                      children: [

                        IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: (){
                              setState(() {

                                if(nbpassager==1)
                                {
                                  nbpassager=1;
                                }
                                else
                                {
                                  nbpassager=nbpassager-1;
                                }
                              });
                            }
                        ),
                        Text('$nbpassager'),
                        IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: (){
                              //augmentation
                              setState(() {
                                nbpassager=nbpassager+1;
                              });
                            }
                        ),
                      ],
                    ),
                  ),

                ],
              ),

            ),


            Padding(padding: EdgeInsets.all(5),),

            RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)
                    {
                      return listingTrajet(retour: retour,);
                    }
                ));

              },
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.black,
              elevation: 5,
              child: Text('Rechercher',style: TextStyle(color: Colors.orange),),

            )
          ],
        ),
      ),


    );

  }


  swapVille(){
    String tempo;
    setState(() {
      tempo =destinationSelectionDepart;
      destinationSelectionDepart=destinationSelectionArrivee;
      destinationSelectionArrivee=tempo;
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
                  containerHeight: 160,

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
                    DateTime houre = new DateTime(momentArrivee.year,momentArrivee.month,momentArrivee.day,time.hour,time.minute);
                    setState(() {
                      momentArrivee=houre;
                    });

                  }
                },

              ),

            ],
          ),
        ),
        action: SnackBarAction(
            label: 'OK',
            onPressed: (){
              print('excéution');
            })

    );
    Scaffold.of(context).showSnackBar(snackbar);


  }

}