
import 'package:africars/controller/listingTrajet.dart';
import 'package:africars/controller/verificationController.dart';
import 'package:africars/view/my_material.dart';
import 'package:africars/view/my_snack.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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


  TextEditingController depart = new TextEditingController(text: 'Depart');
  TextEditingController arrivee =new TextEditingController(text: 'Arrivée');

  DateFormat formatjour;
  DateFormat formatheure;
  DateFormat formatmois;
  int nbpassager=1;
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    momentDepartNational=DateTime.now();
    momentArriveeNational=DateTime.now();

  }
  @override


  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR');
    formatjour= DateFormat.yMMMMd('fr_FR');
    formatheure = DateFormat.Hm('fr_FR');
    formatmois = DateFormat.M('fr_FR');




    // TODO: implement build
    return Scaffold(
      key: globalkey,
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
                items: destination,
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
                items: destination,
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
                  Text(formatjour.format(momentDepartNational)),


                  FlatButton(
                    //snack bar
                    onPressed:()=> affichageSnack('depart'),//affichageSnackBar('depart'),

                    child: Text(formatheure.format(momentDepartNational)),

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
                  Text(formatjour.format(momentArriveeNational)),


                  FlatButton(
                    onPressed:()=>affichageSnack('arrivee'),

                    child: Text(formatheure.format(momentArriveeNational)),

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
                      return verificationController(
                        retour: retour,
                        depart: destinationSelectionDepart,
                        arrivee: destinationSelectionArrivee,
                        heureArrivee: momentArriveeNational,
                        heureDepart: momentDepartNational,
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


  affichageSnack(String periode)
  {
    globalkey.currentState.showBottomSheet((builder) => Mysnackbar(momentDepart: momentDepartNational,momentArrivee: momentArriveeNational,periode:periode));

  }








}