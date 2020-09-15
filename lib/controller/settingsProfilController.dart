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
      appBar: AppBar(
        title: Image.asset("assets/newlogo.jpg",height: 225,),
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
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),

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
          Padding(padding: EdgeInsets.all(5),),
          FlatButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return MyApp();
                    }
                ));
              },
              child: Text('Se déconnecter'))


          //Portemonnaie virtuel


        ],
      ),
    );


  }
}