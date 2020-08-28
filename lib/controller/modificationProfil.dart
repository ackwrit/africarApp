import 'dart:io';

import 'package:africars/controller/settingsProfilController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/main.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_material.dart';
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
      backgroundColor: Colors.orangeAccent,
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
        child: SingleChildScrollView(
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
                        fit:BoxFit.fill,
                        image: NetworkImage(globalUser.image)
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
                  globalUser.pseudo=text;
                });
              },
            ),
            Padding(padding: EdgeInsets.all(5),),
              Text(globalUser.nom),

              Padding(padding: EdgeInsets.all(5),),
              Text(globalUser.prenom),
              Padding(padding: EdgeInsets.all(5),),
              RaisedButton(
                child: Text('Enregsitrer',style: TextStyle(color: Colors.orange),),
                onPressed: (){
                  Map map ={
                    'prenom':globalUser.prenom,
                    'id':globalUser.id,
                    'nom':globalUser.nom,
                    'image':urlImage,
                    'login':globalUser.pseudo,
                    'typeUtilisateur':globalUser.type_utilisateur,



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

      ),

    );


  }



  imagePicker() async {

    image = await FilePicker.getFile(
      type: FileType.image,
    );
    setState(()async {
      urlImage = await firebaseHelper().savePicture(image, firebaseHelper().storage_profil.child(identifiant));
    });

    urlImage = await firebaseHelper().savePicture(image, firebaseHelper().storage_profil.child(identifiant));











  }
}