import 'dart:io';

import 'package:africars/controller/settingsProfilController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/main.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class modificationProfil extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeSettingsProfil();
  }

}


class homeSettingsProfil extends State<modificationProfil> {
  String identifiant;
  utilisateur profil;
  File image;
  String urlImage;
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
              onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context){
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
      child: Container(
        padding: EdgeInsets.all(20),
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
                    fit:BoxFit.fill,
                      image: NetworkImage(profil.image)
                  )
              ),
            ),
            Padding(padding: EdgeInsets.all(5),),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.black,
              onPressed: imagePicker,
              child: Text("Modifier l'image",style: TextStyle(color: Colors.orange),),
            ),
            Padding(padding: EdgeInsets.all(5),),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Pseudo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (text){
                setState(() {
                  profil.pseudo=text;
                });
              },
            ),
            Padding(padding: EdgeInsets.all(5),),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'nom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (text){
                setState(() {
                  profil.nom=text;
                });
              },
            ),
            Padding(padding: EdgeInsets.all(5),),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Prénom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (text){
                setState(() {
                  profil.prenom=text;
                });
              },
            ),
            Padding(padding: EdgeInsets.all(5),),
            RaisedButton(
              child: Text('Enregsitrer',style: TextStyle(color: Colors.orange),),
              onPressed: (){
                Map map ={
                  'prenom':profil.prenom,
                  'id':identifiant,
                  'nom':profil.nom,
                  'image':urlImage,
                  'login':profil.pseudo,


                };
                firebaseHelper().addUser(identifiant, map);
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)
                        {
                          return settingsProfilController();
                        }
                ));

              },
              color: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            RaisedButton(
                onPressed: (){
                 Navigator.push(context, MaterialPageRoute(
                     builder: (BuildContext context){
                       return settingsProfilController();
                     }
                 ));
                },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Text('Retour',style: TextStyle(color: Colors.orange),),
              color: Colors.black,
            )

            //Portemonnaie virtuel


          ],
        ),
      ),

    );


  }



  imagePicker() async {

    image = await FilePicker.getFile(
      type: FileType.image,
    );

    urlImage = await firebaseHelper().savePicture(image, firebaseHelper().storage_profil.child(identifiant));
    Map map=profil.toMap();
    map['image']=urlImage;
    firebaseHelper().addUser(identifiant, map);










  }
}