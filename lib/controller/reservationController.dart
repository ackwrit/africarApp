import 'package:africars/main.dart';
import 'package:flutter/material.dart';


class reservationController extends StatefulWidget{

  String refbillet;
  reservationController({String this.refbillet});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeReserve();
  }

}

class homeReserve extends State<reservationController>{






  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/newlogo.jpg",height: 225,),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),
    );
  }

  Widget bodyPage(){
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15,top:15,bottom: 80),
      child: Container(

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),


        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Votre réservation n° ${widget.refbillet} a bien été pris en compte. Africar vous invite à noter le numéro de réservation, Celui-ci pourrait vous être demander lors des différents échanges auprès de nos services."
              ,style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.black,
                onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context)
                              {
                                return MyApp();
                              }
                      ));
                    },
              child: Text('Validation',style: TextStyle(color: Colors.orangeAccent),),

            )

          ],
        ),

      )
    );

  }




}