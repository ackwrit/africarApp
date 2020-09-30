import 'dart:io';

import 'package:africars/controller/settingsProfilController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/main.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class modificationProfil extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeSettingsProfil();
  }

}


class homeSettingsProfil extends State<modificationProfil> {
  utilisateur profil;
  File image;
  String urlimage;
  String uid;
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  var formatchiffre = new NumberFormat("#,###", "fr_FR");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseHelper().myId().then((value){
      setState(() {
        uid=value;
      });

      firebaseHelper().getUser(uid).then((value){
        setState(() {
          globalUser = value;
        });

      });

    });

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

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


              SizedBox(height:25),
              Text(globalUser.nom),

              SizedBox(height:25),
              Text(globalUser.prenom),
              SizedBox(height:25),
              Text(globalUser.sexe),
              SizedBox(height:25),
              Text('${formatjour.format(globalUser.naissance)}'),
              SizedBox(height:25),
              RaisedButton(
                child: Text('Enregsitrer',style: TextStyle(color: Colors.orange),),
                onPressed: (){
                  Map <String,dynamic> map ={
                    'prenom':globalUser.prenom,
                    'id':globalUser.id,
                    'nom':globalUser.nom,
                    'naissance':globalUser.naissance,
                    'image':urlimage,
                    'login':globalUser.pseudo,
                    'sexe':globalUser.sexe,
                    'typeUtilisateur':globalUser.type_utilisateur,
                    'avoir':globalUser.avoir



                  };
                  firebaseHelper().addUser(uid, map);
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
      urlimage= await firebaseHelper().savePicture(image, firebaseHelper().storage_profil.child(uid));
    });

    setState(() async {
      urlimage = await firebaseHelper().savePicture(image, firebaseHelper().storage_profil.child(uid));
      globalUser.image=urlimage;
    });













  }
}