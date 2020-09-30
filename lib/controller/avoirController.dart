import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:africars/model/my_checkout_payment.dart';
import 'package:africars/model/my_token.dart';
import 'package:africars/model/my_token_payment.dart';
import 'package:http/http.dart' as http;

import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class avoirController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeAvoir();
  }

}

class homeAvoir extends State<avoirController>{
  String uid;
  utilisateur globalUser;
  TextEditingController controllerMontant= new TextEditingController();
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
    return Container(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 15,),
          Card(
            elevation: 5.0,
            child: ListTile(
              leading: Icon(Icons.credit_card_rounded),
              title: (globalUser.avoir==null)?Text('0 CFA'):Text('${formatchiffre.format(globalUser.avoir)} CFA'),
              trailing: RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.orangeAccent,
                icon: Icon(Icons.upload_rounded),
                onPressed: ()=>addAvoir(),
                label: Text('Recharger'),

              ),
            ),
          ),

          SizedBox(height: 15,),


          TextField(

            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,


              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              hintText: 'Taper le montant',
              labelStyle: TextStyle(color: Colors.black),
              hoverColor: Colors.black,


            ),
            controller: controllerMontant,
            onChanged: (text){
              setState(() {
                controllerMontant.text=text;

              });
            },

          ),
          SizedBox(height: 15,),
          Image.asset('assets/money_with_wings.gif'),




        ],
      ),
      padding: EdgeInsets.all(15),
      
    );
      

  }


  addAvoir() async{


    int avoirTotal=0;
    int avoirPrecedent=0;
    if(globalUser==null){
      avoirPrecedent=0;
    }
    else
      {
        avoirPrecedent=globalUser.avoir;
      }

    int avoirenregsitre=int.parse(controllerMontant.text);

    avoirTotal=avoirPrecedent+ int.parse(controllerMontant.text);


    //Récupération du token pour le paiement
    var credentials= globalCredentials;
    Map<String,String>headerToken={
      HttpHeaders.authorizationHeader :'Basic $credentials',
    };
    Map<String,dynamic> bodyToken ={
      "grant_type":"client_credentials",
      "token_type": "Bearer",
      "expires_in": "777600",
      "access_token": ""

    };
    var response =await http.post('https://api.orange.com/oauth/v2/token',headers: headerToken,body: bodyToken);

    Token body = Token.fromJson(jsonDecode(response.body));



    ///////////////////////////////////
    //activation payment
    Map <String,String> headerpayment={
      HttpHeaders.authorizationHeader :"${body.token_type} ${body.access_token}",
      HttpHeaders.acceptHeader:"application/json",
      HttpHeaders.hostHeader:"api.orange.com",
      HttpHeaders.contentTypeHeader:"application/json"
      //"Postman-Token": "e18f3aac-9bd7-ddc5-a3a4-668e6089a0d5"
    };
    DateTime orderid = DateTime.now();
    String number_order ="Account${orderid.day}${orderid.month}${orderid.year}${orderid.hour}${orderid.minute}${orderid.second}${orderid.millisecond}";


    Map <String,dynamic> bodypayment ={
      "Content-Type":"application/json",
      "merchant_key":"bd77ff4d",
      "currency":"OUV",
      "order_id":number_order,
      "amount": avoirenregsitre.toString(),
      "return_url": "http://www.koko0017.odns.fr",
      "cancel_url": "http://www.koko0017.odns.fr",
      "notif_url":"http://www.koko0017.odns.fr/notifications",
      "lang": "fr",
      "reference":"Africar",

    };

    http.Response paymentResponse = await http.post(
        urlPaiement,
        headers: headerpayment,
        body: jsonEncode(bodypayment)

    );
    TokenPayment paymenttoken = TokenPayment.fromJson(jsonDecode(paymentResponse.body));


    //headerverification
    Map<String,String>headerverification ={
      HttpHeaders.authorizationHeader:"${body.token_type} ${body.access_token}",
      HttpHeaders.acceptHeader:"application/json",
      HttpHeaders.hostHeader:"api.orange.com",
      //HttpHeaders.contentTypeHeader:"application/json; charset=UTF-8"


    };
    Map<String,dynamic>bodynotification={
      "status":"SUCCESS",
      "notif_token":paymenttoken.notif_token,
      "txnid": ""

    };
    http.Response notificationpage = await http.post("http://www.koko0017.odns.fr/notifications",body: bodynotification);



    //Lancement de la page paiement
    Map<String,dynamic> bodyverification ={
      "order_id":number_order,
      "amount":avoirenregsitre.toString(),
      "pay_token":paymenttoken.pay_token,
      "payment_url":paymenttoken.payment_url,
      "notif_token":paymenttoken.notif_token,
      "txnid": "",
      "content-type":"application/json; charset=UTF-8"


    };
    if (await canLaunch(paymenttoken.payment_url)) {
      await launch(paymenttoken.payment_url);


    } else {
      throw 'Could not launch ${paymenttoken.payment_url}';
    }
    int counter=0;
    Timer(Duration(seconds:30), () async {
      http.Response verificationPaiement = await http.post(
          "https://api.orange.com/orange-money-webpay/dev/v1/transactionstatus"
          ,body: json.encode(bodyverification),headers: headerverification);
      CheckoutPayment paymentcheck = CheckoutPayment.fromJson(jsonDecode(verificationPaiement.body));

      if(verificationPaiement.statusCode==201)
      {

        print(paymentcheck.status);
        if(paymentcheck.status=='INITIATED'){
          Timer.periodic(Duration(seconds: 30), (timer) async {
            if(counter<10)
            {
              counter++;
              print(counter);
              verificationPaiement = await http.post(
                  "https://api.orange.com/orange-money-webpay/dev/v1/transactionstatus"
                  ,body: json.encode(bodyverification),headers: headerverification);
              paymentcheck = CheckoutPayment.fromJson(jsonDecode(verificationPaiement.body));
              print(paymentcheck.status);
              if(paymentcheck.status=='SUCCESS')
              {
                print('enregistrement dans timer');
                Map <String,dynamic>mapUser ={
                  'nom':globalUser.nom,
                  'prenom':globalUser.prenom,
                  'id':globalUser.id,
                  'compagnie':globalUser.compagnie,
                  'telephone':globalUser.telephone,
                  'image':globalUser.image,
                  'typeUtilisateur':globalUser.type_utilisateur,
                  'login':globalUser.pseudo,
                  'mail':globalUser.mail,
                  'sexe':globalUser.sexe,
                  'naissance':globalUser.naissance,
                  'avoir':avoirTotal,

                };
                firebaseHelper().addUser(globalUser.id, mapUser);


                timer.cancel();
              }
              if(paymentcheck.status=="FAILED")
              {
                timer.cancel();
              }

            }
            else
            {
              timer.cancel();
              print('fini');
            }

          });
        }

        if(paymentcheck.status=='SUCCESS')
        {
          print("enregistrement");
          print('enregistrement dans timer');
          Map <String,dynamic>mapUser ={
            'nom':globalUser.nom,
            'prenom':globalUser.prenom,
            'id':globalUser.id,
            'compagnie':globalUser.compagnie,
            'telephone':globalUser.telephone,
            'image':globalUser.image,
            'typeUtilisateur':globalUser.type_utilisateur,
            'login':globalUser.pseudo,
            'mail':globalUser.mail,
            'sexe':globalUser.sexe,
            'naissance':globalUser.naissance,
            'avoir':avoirTotal,

          };
          firebaseHelper().addUser(globalUser.id, mapUser);

        }
        if(paymentcheck.status=='FAILED')
        {
          print('non timer');

        }


      }
      else
      {
        print('non');
      }



    });
  }




}