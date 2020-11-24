import 'package:africars/main.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:flutter/material.dart';


class MyinformationAvoir extends StatefulWidget{
  String refbillet;
  MyinformationAvoir({this.refbillet});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyinformationAvoirState();
  }

}

class MyinformationAvoirState extends State<MyinformationAvoir>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: MediaQuery.of(context).size.height/1.7,
        width: MediaQuery.of(context).size.width,
        color: background,
        child:Container(
          padding: EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Text('Achat du billet effectué',style: TextStyle(fontSize: 25),),
              SizedBox(height: 15,),
              Text("Merci d'avoir effectué l'achat de votre billet n°${widget.refbillet}",style: TextStyle(fontSize: 18),),
              SizedBox(height: 15,),
              RaisedButton(
                color: backgroundbar,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return MyHomePage();
                      }
                  ));
                },
                child: Text('OK',style: TextStyle(color: background),),
              ),



            ],
          ),
        )
    );

  }

}