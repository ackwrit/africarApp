import 'package:africars/controller/offreProfessionnel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class professionnelSettingsController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeSettings();
  }

}

class homeSettings extends State<professionnelSettingsController>{
  List <String> choixSelected=['Liste des agences',"Chiffre d'affaire"];
  double _elevation =10.0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height/1.5,
          child: ListView.builder(
              itemCount: choixSelected.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (BuildContext context,int index)
              {
                return GestureDetector(
                  onTap: (){
                    print('Appuyer');
                    setState(() {
                      _elevation=0.0;
                    });

                  },
                  child: Card(
                    elevation: _elevation,

                    child: Text(choixSelected[index],textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),

                  )
                );

              }
          )
        ),
        RaisedButton(
          elevation: 5.0,
          color: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder:
            (BuildContext context)
                {
                  return  offreProfessionnel();
                }
            ));

            },
          child: Text("Mise à niveau",style: TextStyle(color: Colors.orangeAccent),),
        )
      ],
    );

  }

}