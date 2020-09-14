import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africars/fonction/conversion.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/main.dart';
import 'package:africars/model/billet.dart';
import 'package:africars/model/my_checkout_payment.dart';
import 'package:africars/model/my_token.dart';
import 'package:africars/model/my_token_payment.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class detailDateController extends StatefulWidget{
  billet ticket;
  bool validation;
  detailDateController({billet ticket, bool validation})
  {
    this.ticket=ticket;
    this.validation=validation;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return homeDetail();
  }

}

class homeDetail extends State<detailDateController>{
  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png",height: 225,),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),
    );
  }



  Widget bodyPage(){
    return SingleChildScrollView(
      child: (widget.validation)?Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20,),
            //Text("billet crée le ${formatjour.format(widget.ticket.emission)} à ${formatheure.format(widget.ticket.emission)}"),
            SizedBox(height: 20,),

            QrImage(
              data: widget.ticket.qrCodeAller,
              size: 100,
              version: QrVersions.auto,
            ),

            SizedBox(height: 20,),
            Text("Départ : ${formatjour.format(widget.ticket.depart)} à ${formatheure.format(widget.ticket.depart)}",style: TextStyle(fontSize: 20),),

            SizedBox(height: 20,),
            Text('${widget.ticket.lieuDepart} - ${widget.ticket.lieuArrivee}',style: TextStyle(fontSize: 25),),
            SizedBox(height: 20,),
            Text('${widget.ticket.nomPassager} ${widget.ticket.prenomPassager}',style: TextStyle(fontSize: 25)),




            (widget.ticket.logoCompagnieAller==null)?Container():Image.network(widget.ticket.logoCompagnieAller,height: 120,width: 120,),

            SizedBox(height: 20,),

            SizedBox(height: 20,),
            Text("nombre de passager: ${widget.ticket.nbPassager.toString()}",style: TextStyle(fontSize: 25),),
            SizedBox(height: 20,),
            RaisedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return MyHomePage();
                  }
              ));

            },
              color: backgroundbar,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Text('Ok',style: TextStyle(color: background),),

            )



          ],
        ),
      ):Center(
        child: RaisedButton(
            onPressed: ()=>paye(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: backgroundbar,
          child: Text('Paiement',style: TextStyle(color: background),),
        ),
      ),

    );
  }




  void billetrecording(bool validate)
  {

    //Enregistrement billet en mode provisoire
    Map <String,dynamic>map={
      'emission':DateTime.now(),
      'departAller':widget.ticket.depart,
      'telephone':globalUser.telephone,
      'retourAller':widget.ticket.depart,
      'departRetour':widget.ticket.retour,
      'retourRetour':widget.ticket.retour,
      'logoCompagnieAller':widget.ticket.logoCompagnieAller,
      'logoCompagnieRetour':(widget.ticket.billetRetour)?widget.ticket.logoCompagnieRetour:'',
      'lieuDepart': widget.ticket.lieuDepart,
      'lieuArrivee':widget.ticket.lieuArrivee,
      'nbPassager':widget.ticket.nbPassager,
      'nomPassager':globalUser.nom,
      'idvoyageur':globalUser.id,
      'prenomPassager':globalUser.prenom,
      'qrCodeAller':widget.ticket.qrCodeAller,
      'qrCodeRetour':(widget.ticket.billetRetour)?widget.ticket.qrCodeRetour:'',
      'billerRetour':widget.ticket.billetRetour,
      'validate':validate,
      'jourAller':widget.ticket.depart,
      'jourRetour':(widget.ticket.billetRetour)?widget.ticket.retour:DateTime.now(),
      'prix':widget.ticket.prix,
      'idBillet':widget.ticket.id,

    };
    firebaseHelper().addBillet(widget.ticket.id, map);

  }



  Future paye() async {
    billetrecording(false);


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
    String number_order ="${orderid.day}${orderid.month}${orderid.year}${orderid.hour}${orderid.minute}${orderid.second}${orderid.millisecond}";


    Map <String,dynamic> bodypayment ={
      "Content-Type":"application/json",
      "merchant_key":"bd77ff4d",
      "currency":"OUV",
      "order_id":number_order,
      "amount": widget.ticket.prix.toString(),
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
      "amount":widget.ticket.prix.toString(),
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
                billetrecording(true);

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
          billetrecording(true);
        }
        if(paymentcheck.status=='FAILED')
        {
          print('non timer');
          billetrecording(false);
        }


      }
      else
      {
        print('non');
      }



    });
  }






}