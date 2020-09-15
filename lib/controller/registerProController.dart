import 'package:africars/controller/administrationController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:flutter/material.dart';

class registerProController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeRegisterPro();
  }

}

class homeRegisterPro extends State<registerProController>{
  String matricule,adresse,mail,nomDirigeant,prenomDirigeant,ofrre,password;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/newlogo.jpg",height: 225,),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),

    );
  }



  Widget bodyPage(){
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Numéro de NIF
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Numéro NIF',
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value){
              setState(() {
                matricule=value;
              });
            },

          ),
          Padding(padding: EdgeInsets.all(5),),
          //Adresse locaux
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Entrer l'adresse",
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value){
              setState(() {
                adresse=value;
              });
            },

          ),
          Padding(padding: EdgeInsets.all(5),),
          //adresse mail
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Mail',
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value){
              setState(() {
                mail=value;
              });
            },

          ),
          Padding(padding: EdgeInsets.all(5),),
          TextField(
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'password',
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value){
              setState(() {
                password=value;
              });
            },

          ),
          Padding(padding: EdgeInsets.all(5),),
          //nom dirigeant
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Nom du dirigeant',
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value){
              setState(() {
                nomDirigeant=value;
              });
            },

          ),
          Padding(padding: EdgeInsets.all(5),),
          //Prénom du dirigeant
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Prénom du dirigeant',
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value){
              setState(() {
                prenomDirigeant=value;
              });
            },

          ),


          Padding(padding: EdgeInsets.all(10),),

          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.black,
              elevation: 5,
              onPressed: (){
              firebaseHelper().handleCreateMailCompagnie(mail: mail,password: password,nif: matricule,adresse: adresse,nomDirigeant: nomDirigeant,prenomDirigeant: prenomDirigeant);
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return administrationController();
                  }
              ));

                //enregister les informations dans la base de donnée compagnie
              },
            child: Text('Enregistrer',style: TextStyle(color: Colors.orange),),
          ),

        ],

      ),
    );

  }

}