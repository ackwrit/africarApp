

import 'package:africars/controller/administrationController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class registerController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeRegister();
  }

}

class homeRegister extends State<registerController>{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

      ),
      backgroundColor: Colors.orange,
      body: bodyPage(),
    );
  }





  Widget bodyPage(){
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return administrationController();
                    }
                ));
              },
              child: Text('Professionnel')
          ),
          Padding(padding: EdgeInsets.all(10)),
          InternationalPhoneNumberInput(
            initialValue: number,
            onInputChanged: (text){
              number =text;
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
          Padding(padding: EdgeInsets.all(10)),
        
          FlatButton(
            onPressed: ()=>validationPhone(number.toString()),
            child: Text('Validation'),
          ),

        ],
      ),
    );

  }


  validationPhone(String number){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text(number),
          );
        }


    );
  }

}