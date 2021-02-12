
import 'dart:async';

import 'package:africars/constants/lib_africars.dart';
import 'package:africars/controller/listingTrajet.dart';
import 'package:africars/controller/verificationController.dart';
import 'package:africars/view/my_material.dart';
import 'package:animate_icons/animate_icons.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  GlobalKey <ScaffoldState> globalkey = GlobalKey<ScaffoldState>();
  GlobalKey <ScaffoldState> globalkeyInternational = GlobalKey<ScaffoldState>();


  TextEditingController depart = new TextEditingController(text: 'Depart');
  TextEditingController arrivee =new TextEditingController(text: 'Arrivée');

  DateFormat formatjour;
  DateFormat formatheure;
  DateFormat formatmois;
  int nbpassager=1;
  bool internatinational = false;
  bool retour=false;
  final List<String> imgList = [
      'assets/banniere01.JPG',
        'assets/banniere02.JPG',
        'assets/banniere03.JPG',
        'assets/banniere04.JPG'
  ];
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
    'Niéna','Niono','Nioro du Sahel',
    'San','Sandaré','Ségou','Sévaré','Sikasso',
    'Tabakoto','Taoudénit','Ténè','Tillaberry','Tombouctou','Toukoto',
    'Yangasso'
  ];

  List <String> destinationInternational=[
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


  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR');
    formatjour= DateFormat.yMMMMd('fr_FR');
    formatheure = DateFormat.Hm('fr_FR');
    formatmois = DateFormat.M('fr_FR');
    momentDepartNational=DateTime.now();
    momentArriveeNational=DateTime.now();




    // TODO: implement build
    return Scaffold(
      key: (internatinational)?globalkeyInternational:globalkey,
      body: bodyPage(),
    );
  }




  Widget bodyPage()
  {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),

      color:Colors.orangeAccent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('National'),
                Switch.adaptive(
                    value: internatinational,
                    onChanged: (bool valeur){
                      setState(() {
                        internatinational=valeur;
                        destinationSelectionDepart='Choisir votre départ';
                        destinationSelectionArrivee='Choisir votre arrivée';
                      });
                    }
                ),

                Text('International'),
              ],


            ),

            //
            Container(
              height: 65,
              child: DropdownSearch<String>(

                validator: (v) => v == null ? "required field" : null,
                hint: "Choisir votre départ",
                searchBoxDecoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Indiquer votre ville de départ',
                    alignLabelWithHint: true,

                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                ),
                showSearchBox: true,
                dropdownSearchDecoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))

                ),
                mode: Mode.DIALOG,
                showSelectedItem: true,
                items: (internatinational)?destinationInternational:destination,
                showClearButton: false,
                onChanged: (text){
                  setState(() {
                    destinationSelectionDepart=text;
                  });
                },

                selectedItem: destinationSelectionDepart,
              ),
            ),


            Align(
              alignment: Alignment.center,
              child: AnimateIcons(
                startIcon: Icons.swap_vertical_circle,
                endIcon: Icons.swap_vertical_circle,
                size: 50.0,
                onStartIconPress: (){

                    swapVille();


                  return true;
                },
                onEndIconPress: () {
                  swapVille();
                  return true;
                },
                duration: Duration(milliseconds: 500),
                color: Colors.white,
                clockwise: false,
              ),
            ),
            Container(
              height: 65,
              child: DropdownSearch<String>(
                validator: (v) => v == null ? "required field" : null,
                hint: "Choisir votre arrivée",
                searchBoxDecoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    alignLabelWithHint: true,

                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                ),
                showSearchBox: true,
                dropdownSearchDecoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))

                ),
                mode: Mode.DIALOG,
                showSelectedItem: true,
                items: (internatinational)?destinationInternational:destination,
                showClearButton: false,
                onChanged: (String text){
                  print(text);
                  setState(() {
                    destinationSelectionArrivee = text;


                  });
                },

                selectedItem: destinationSelectionArrivee,
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
                  (internatinational)?Text(formatjour.format(GlobalDepartInternational)):Text(formatjour.format(GlobalDepart)),


                  FlatButton(
                    //snack bar
                    onPressed:()=> affichageSnack('depart',internatinational),//affichageSnackBar('depart'),

                    child: (internatinational)?Text(formatheure.format(GlobalDepartInternational)):Text(formatheure.format(GlobalDepart)),

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
                  (internatinational)?Text(formatjour.format(GlobalDestinationInternational)):Text(formatjour.format(GlobalDesttination)),


                  FlatButton(
                    onPressed:()=>affichageSnack('arrivee',internatinational),

                    child: (internatinational)?Text(formatheure.format(GlobalDestinationInternational)):Text(formatheure.format(GlobalDesttination)),

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


            Padding(padding: EdgeInsets.all(2),),

            RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)
                    {
                      return verificationController(
                        retour: retour,
                        depart: destinationSelectionDepart,
                        arrivee: destinationSelectionArrivee,
                        heureArrivee: (internatinational)?GlobalDestinationInternational:GlobalDesttination,
                        heureDepart: (internatinational)?GlobalDepartInternational:GlobalDepart,
                        nombrepassager: nbpassager,);
                    }
                ));

              },
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.black,
              elevation: 5,
              child: Text('Rechercher',style:TextStyle(color:Colors.white)),

            ),
            Padding(padding: EdgeInsets.all(10),),
            
            CarouselSlider(

              options: CarouselOptions(
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: 3000),
              ),
              items: imgList.map((item) => 
                  Container(
                child:Card(
                  child: Center(
                      child: Image.asset(item, fit: BoxFit.cover, width: 1000,height: 1000,)
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  
                ),
                
              )).toList(),
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




  affichageSnack(String periode,bool international)
  {
    int count=0;
    int affichage;
    if(international==true){
      globalkeyInternational.currentState.showBottomSheet((context) => MySnack(periode, international));

    }
    else
      {
        globalkey.currentState.showBottomSheet((builder) => MySnack(periode,international));
      }


    Timer.periodic(Duration(seconds:2), (timer){
      if(count<10)
      {
        count++;
        print(count);
        setState(() {
          affichage=count;
          momentDepartNational=GlobalDepart;
          momentDepartInternational=GlobalDepartInternational;
          momentArriveeNational=GlobalDesttination;
          momentArriveeInternational=GlobalDestinationInternational;
          print('exterieur');
          print(GlobalDepart);
          print(momentDepartNational);
        });

      }
      else
      {
        timer.cancel();
      }



    });
    setState(() {
      momentDepartNational=GlobalDepart;
      momentDepartInternational=GlobalDepartInternational;
      momentArriveeNational=GlobalDesttination;
      momentArriveeInternational=GlobalDestinationInternational;
      print('exterieur');
      print(GlobalDepart);
      print(momentDepartNational);

    });

  }





  MySnack(String periode,bool international){
    DateTime momentDepart=DateTime.now();
    DateTime momentArrivee=DateTime.now();
    return Container(
        height: MediaQuery.of(context).size.height/1.43,
        color: background,
        child:Container(

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DatePicker(
                  DateTime.now(),
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.amber,
                selectedTextColor: Colors.white,
                locale: 'fr_FR',
                onDateChange: (heure){
                    if(periode=='depart') {
                      setState(() {
                        momentDepart=heure;
                        print('moment depart');
                        print(momentDepart);
                        GlobalDepart=momentDepart;
                        GlobalDepartInternational=momentDepart;

                      });
                    }
                    else
                      {
                        setState(() {
                          momentArrivee=heure;
                          GlobalDesttination=momentArrivee;
                          GlobalDestinationInternational=momentArrivee;

                        });
                      }

                },

              ),


              Text('Horaire',style: TextStyle(fontSize: 20),),

              TimePickerSpinner(
                isForce2Digits: true,
                minutesInterval: 15,
                highlightedTextStyle: TextStyle(color: background,fontSize: 20),
                normalTextStyle: TextStyle(color: Colors.black,fontSize: 10),
                onTimeChange: (time)
                {
                  if(periode=='depart')
                  {
                    DateTime hour = new DateTime(momentDepart.year,momentDepart.month,momentDepart.day,time.hour,time.minute);
                    print('hour');
                    print(hour);
                    setState(() {
                      momentDepartNational=hour;
                      momentDepartInternational=hour;
                      GlobalDepart=hour;
                      print('fin départ');
                      print(GlobalDepart);
                      GlobalDepartInternational=hour;

                    });
                  }
                  else
                  {
                    DateTime houre = new DateTime(momentArrivee.year,momentArrivee.month,momentArrivee.day,time.hour,time.minute);
                    setState(() {
                      momentArriveeNational=houre;
                      momentArriveeInternational=houre;
                      GlobalDesttination=houre;
                      GlobalDestinationInternational=houre;

                    });

                  }
                },

              ),
              RaisedButton(
                onPressed: (){


                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: backgroundbar,
                child: Text("Valider",style: TextStyle(color: background),),
              )

            ],
          ),
        )
    );
  }








}