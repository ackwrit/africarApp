import 'package:africars/controller/modificationProfil.dart';
import 'package:africars/controller/registerController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/main.dart';
import 'package:africars/model/utilisateur.dart';
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
          profil=user;
        });

      });

    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        leading: IconButton(
            icon: Icon(Icons.home,color: Colors.white,size: 40,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return MyHomePage();
                  }
              ));
            }),
        actions: [
          IconButton(
              icon: Icon(Icons.settings,size: 40,color: Colors.white,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)
                        {
                          return modificationProfil();
                        }
                ));
              })
        ],
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.orange,
      body: bodyPage(),

    );

  }


  Widget bodyPage(){
    return (profil==null)?Column(
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
          (profil.image==null)? Container(
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
                      image: NetworkImage(profil.image)
                  )
                ),
              ),
          Padding(padding: EdgeInsets.all(5),),
          Text(profil.pseudo),
          Padding(padding: EdgeInsets.all(5),),
          Text(profil.nom),
          Padding(padding: EdgeInsets.all(5),),
          Text(profil.prenom),

          //Portemonnaie virtuel


        ],
      ),
    );


  }
}