

import 'package:africars/controller/avoirController.dart';
import 'package:africars/controller/modificationProfil.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/main.dart';
import 'package:africars/model/affichage_billet_validate.dart';
import 'package:africars/model/affichage_messagerie.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class settingsProfilController extends StatefulWidget{
  int pageselected;
  settingsProfilController({int this.pageselected});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeSettingsProfil();
  }

}


class homeSettingsProfil extends State<settingsProfilController> {
  String identifiant;

  utilisateur profil;
  int selectedindex=0;

  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  var formatchiffre = new NumberFormat("#,###", "fr_FR");





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    firebaseHelper().getUser(idServiceClient).then((user)
    {
      setState(() {
        serviceClient=user;
      });

    });
    if(widget.pageselected!=null){
      setState(() {
        selectedindex=widget.pageselected;
      });

    }


    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (globalUser==null)?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 4,
                        )
                      ],
                    ):Text('${globalUser.prenom} ${globalUser.nom}'),
                    (globalUser.image==null)? Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/userIcon.png"),
                          )
                      ),
                    ): Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(globalUser.image)
                          )
                      ),
                    ),

                  ],

        ),

              ),
            decoration: BoxDecoration(

              color: Colors.orangeAccent,
            ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Menu'),
              selected: (selectedindex==0),
              onTap: () {
                setState(() {
                  selectedindex=0;
                });

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:Icon(Icons.departure_board_rounded),
              title: Text('Courses'),
              selected: (selectedindex==1),
              onTap: () {
                setState(() {
                  selectedindex=1;

                });

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card_rounded),
              title: Text('Porte-Monnaie'),
              selected: (selectedindex==2),
              onTap: () {
                setState(() {
                  selectedindex=2;
                });

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.forum_rounded),
              title: Text('Service Client'),
              selected: (selectedindex==3),
              onTap: () {
                setState(() {
                  selectedindex=3;
                });

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Paramètre'),
              selected: (selectedindex==4),
              onTap: () {
               setState(() {
                 selectedindex=4;
               });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_rounded),
              title: Text('Quitter'),
              selected:(selectedindex==5),
              onTap: () {
               setState(() {
                 selectedindex=5;
               });
                Navigator.push(context,MaterialPageRoute(
                    builder: (BuildContext context){
                      return MyHomePage();
                    }
                ));
              },
            ),
            SizedBox(height: 40,),
            Divider(
              color:Colors.black,
              thickness: 2,

            ),
            ListTile(
              leading: Icon(Icons.logout),
              selected: (selectedindex==6),
              title: Text('Se déconnecter'),
              onTap: () {
                setState(() {
                  selectedindex=6;
                });
                MyDialog();


              },
            ),
          ],
        ),

      ),


      appBar: AppBar(
        title: Image.asset("assets/newlogo.jpg",height: 225,),


        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.orangeAccent,
      body: pageIndex(selectedindex)

    );

  }


  Widget bodyPage(){
    return (globalUser==null)?Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 4,
            )
          ],
        ),
      ],




    )
        :Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height:25),
          (globalUser.image==null)? Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                      image: AssetImage("assets/userIcon.png"),
                  )
                ),
              ): Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                      image: NetworkImage(globalUser.image)
                  )
                ),
              ),

          SizedBox(height:25),
          Text(globalUser.nom),
          SizedBox(height:25),
          Text(globalUser.prenom),
          SizedBox(height:25),
          Text(globalUser.sexe),
          SizedBox(height:25),
          Text('${formatjour.format(globalUser.naissance)}'),
          SizedBox(height:25),




        ],
      ),
    );


  }


  Future MyDialog() async{

    return showDialog(
      barrierDismissible: false,
       context:context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Suppression profil'),
          backgroundColor: background,
          content: SingleChildScrollView(
            child:ListBody(
              children: [
                Text('Cette action supprimera toutes les informations liés à votre profil.'),
                Text('Souhaitez-vous supprimer votre profil ?'),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: backgroundbar,
                    onPressed: (){
                      Navigator.pop(context);


                    },
                    icon: Icon(Icons.cancel,color: background,),
                    label: Text('NON',style: TextStyle(color: background),)
                ),
                SizedBox(width: 10,),
                RaisedButton.icon(
                    color: backgroundbar,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                      setState(() {
                        globalUser=null;
                      });
                      Navigator.push(context,MaterialPageRoute(
                          builder: (BuildContext context){
                            return MyApp();
                          }
                      ));

                    },
                    icon: Icon(Icons.delete_forever,color: background,),
                    label: Text('OUI',style: TextStyle(color: background),)
                ),
              ],
            ),
          ],

        );
      }
    );


  }





  pageIndex(int pos){
    switch(pos){
      case 0: return bodyPage();
      case 1:return billetValidateController();
      case 2: return avoirController();
      case 3: return chatController(globalUser, serviceClient);
      case 4:return modificationProfil();
      case 5:return print('quitter');
      case 6:return print('se decconnecter');
    };

  }
}