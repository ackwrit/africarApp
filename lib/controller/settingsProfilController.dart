import 'package:africars/controller/avoirController.dart';
import 'package:africars/controller/modificationProfil.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/main.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class settingsProfilController extends StatefulWidget{
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



  pageIndex(int pos){
    switch(pos){
      case 0: return bodyPage();
      case 1:return null;
      case 2: return avoirController();
      case 3:return modificationProfil();
      case 4:return print('quitter');
      case 5:return print('se decconnecter');
    };

  }
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
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Text('${globalUser.prenom} ${globalUser.nom}'),
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
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
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
              leading: Icon(Icons.settings),
              title: Text('Paramètre'),
              selected: (selectedindex==3),
              onTap: () {
               setState(() {
                 selectedindex=3;
               });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_rounded),
              title: Text('Quitter'),
              selected:(selectedindex==4),
              onTap: () {
               setState(() {
                 selectedindex=4;
               });
                Navigator.push(context,MaterialPageRoute(
                    builder: (BuildContext context){
                      return MyHomePage();
                    }
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              selected: (selectedindex==5),
              title: Text('Se déconnecter'),
              onTap: () {
                setState(() {
                  selectedindex=5;
                });

                FirebaseAuth.instance.signOut();

                Navigator.push(context,MaterialPageRoute(
                    builder: (BuildContext context){
                      return MyApp();
                    }
                ));
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
          Padding(padding: EdgeInsets.all(5),),
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
              ):Container(
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
          Padding(padding: EdgeInsets.all(5),),
          //Text(profil.pseudo),
          Padding(padding: EdgeInsets.all(5),),
          Text(globalUser.nom),
          Padding(padding: EdgeInsets.all(5),),
          Text(globalUser.prenom),



          //Portemonnaie virtuel


        ],
      ),
    );


  }
}