import 'package:africars/controller/paymentController.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class reservationController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeReserve();
  }

}

class homeReserve extends State<reservationController>{
  bool paiementBoutique=false;
  bool paiementPro =false;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number= PhoneNumber(isoCode: 'ML');





  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),
    );
  }

  Widget bodyPage(){
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         /* RaisedButton(
            color: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: (){
              setState(() {
                paiementBoutique=!paiementBoutique;
              });

              },
            child: Text('Paiement en agence',style: TextStyle(color: Colors.orange),),
          ),*/
         //Orange money
          GestureDetector(
            child: Image.asset("assets/logoorangemoney.jpeg",width: 180,),
            onTap: (){
              print('afficher orange money');
            },
          ),

          SizedBox(height: 10,),
          (paiementBoutique==true)?Text("Merci d'effectuer le paiement 1h avant le départ de votre voyage en agence"):Container(),
          SizedBox(height: 10,),

          RaisedButton.icon(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black,
              onPressed: (){
                setState(() {
                  paiementPro=!paiementPro;

                });

              },
              icon: Icon(Icons.phone,color: Colors.orange,),
              label: Text('Être rappeller',style: TextStyle(color: Colors.white),)),
          SizedBox(height: 10,),
          (paiementPro)? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InternationalPhoneNumberInput(
                initialValue: number,
                onInputChanged: (text){
                  number=text;
                },
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                inputDecoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.black,
                child: Text("Appeler-moi",style: TextStyle(color: Colors.orange),),
                onPressed: (){
                  //enregistrement dans la BDD rappel,
                  print('Rappel');
                },
              ),
            ],
          ) :Container(),
          SizedBox(height: 20,),
         /* RaisedButton(
            color: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context)
                      {
                        return paymentController();
                      }
              ));
            },
            child: Text('Paiement en ligne',style: TextStyle(color: Colors.orange),),
          ),*/
          SizedBox(height: 10,),

        ],
      ),
    );

  }




}