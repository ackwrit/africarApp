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
import 'package:africars/view/my_widgets/my_information_avoir.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class detailDateController extends StatefulWidget{
  billet ticket;
  bool validation;
  bool useAvoir;
  detailDateController({billet ticket, bool validation,bool useAvoir})
  {
    this.ticket=ticket;
    this.useAvoir=useAvoir;
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
  GlobalKey <ScaffoldState> keyinfoValue = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: keyinfoValue,
      appBar: AppBar(

        title: Image.asset("assets/newlogo.jpg",height: 225,),
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
            onPressed: ()=>(widget.useAvoir)?paye():payewithoutAvoir(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: backgroundbar,
          child: Text('Paiement',style: TextStyle(color: background),),
        ),
      ),

    );
  }




  void billetrecording(bool validate,{String idfacture})
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
      'idCompagnieAller':widget.ticket.idCompagnieAller,
        'idCompagnieRetour':(widget.ticket.billetRetour)?widget.ticket.idCompagnieRetour:'',
      'jourAller':widget.ticket.depart,
      'jourRetour':(widget.ticket.billetRetour)?widget.ticket.retour:DateTime.now(),
      'prixAller':widget.ticket.prixAller,
      'prixRetour':widget.ticket.prixRetour,
      'idBillet':widget.ticket.id,
      'onboarding':false,
      'idfacture':idfacture,

    };
    firebaseHelper().addBillet(widget.ticket.id, map);

  }



  Future paye() async {
    billetrecording(false);
    int prixResume=0;
    int prixTotal = widget.ticket.prixAller+widget.ticket.prixRetour;
    if(globalUser.avoir>=prixTotal){
      prixResume=prixTotal-globalUser.avoir;
    }
    else
      {
        prixResume=prixTotal-globalUser.avoir;
      }



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
    if(prixResume<=0){

      setState(() {
        globalUser.avoir=globalUser.avoir-prixTotal;
      });
      Map <String, dynamic>userMap = {
        'nom': globalUser.nom,
        'prenom': globalUser.prenom,
        'id': globalUser.id,
        'compagnie': globalUser.compagnie,
        'telephone': globalUser.telephone,
        'image': globalUser.image,
        'typeUtilisateur': globalUser.type_utilisateur,
        'login': globalUser.pseudo,
        'mail': globalUser.mail,
        'sexe': globalUser.sexe,
        'naissance': globalUser.naissance,
        'avoir': globalUser.avoir,
      };
      firebaseHelper().addUser(globalUser.id, userMap);
      creationFacture(prixTotal, number_order);
      billetrecording(true,idfacture: number_order);
     affichageAvoir();


    }
    else {
      Map <String, dynamic> bodypayment = {
        "Content-Type": "application/json",
        "merchant_key": "bd77ff4d",
        "currency": "OUV",
        "order_id": number_order,
        "amount": (widget.useAvoir) ? prixResume.toString() : prixTotal
            .toString(),
        "return_url": "http://www.koko0017.odns.fr",
        "cancel_url": "http://www.koko0017.odns.fr",
        "notif_url": "http://www.koko0017.odns.fr/notifications",
        "lang": "fr",
        "reference": "Africar",

      };

      http.Response paymentResponse = await http.post(
          urlPaiement,
          headers: headerpayment,
          body: jsonEncode(bodypayment)

      );
      TokenPayment paymenttoken = TokenPayment.fromJson(
          jsonDecode(paymentResponse.body));


      //headerverification
      Map<String, String>headerverification = {
        HttpHeaders.authorizationHeader: "${body.token_type} ${body
            .access_token}",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.hostHeader: "api.orange.com",
        //HttpHeaders.contentTypeHeader:"application/json; charset=UTF-8"


      };
      Map<String, dynamic>bodynotification = {
        "status": "SUCCESS",
        "notif_token": paymenttoken.notif_token,
        "txnid": ""
      };
      http.Response notificationpage = await http.post(
          "http://www.koko0017.odns.fr/notifications", body: bodynotification);


      //Lancement de la page paiement
      Map<String, dynamic> bodyverification = {
        "order_id": number_order,
        "amount": (widget.useAvoir) ? prixResume.toString() : prixTotal
            .toString(),
        "pay_token": paymenttoken.pay_token,
        "payment_url": paymenttoken.payment_url,
        "notif_token": paymenttoken.notif_token,
        "txnid": "",
        "content-type": "application/json; charset=UTF-8"
      };
      if (await canLaunch(paymenttoken.payment_url)) {
        await launch(paymenttoken.payment_url);
      } else {
        throw 'Could not launch ${paymenttoken.payment_url}';
      }
      int counter = 0;
      Timer(Duration(seconds: 30), () async {
        http.Response verificationPaiement = await http.post(
            "https://api.orange.com/orange-money-webpay/dev/v1/transactionstatus"
            , body: json.encode(bodyverification), headers: headerverification);
        CheckoutPayment paymentcheck = CheckoutPayment.fromJson(
            jsonDecode(verificationPaiement.body));

        if (verificationPaiement.statusCode == 201) {
          print(paymentcheck.status);
          if (paymentcheck.status == 'INITIATED') {
            Timer.periodic(Duration(seconds: 30), (timer) async {
              if (counter < 10) {
                counter++;
                print(counter);
                verificationPaiement = await http.post(
                    "https://api.orange.com/orange-money-webpay/dev/v1/transactionstatus"
                    , body: json.encode(bodyverification),
                    headers: headerverification);
                paymentcheck = CheckoutPayment.fromJson(
                    jsonDecode(verificationPaiement.body));
                print(paymentcheck.status);
                if (paymentcheck.status == 'SUCCESS') {

                  print('enregistrement dans timer');
                  billetrecording(true,idfacture: number_order);
                  creationFacture(prixTotal, number_order);
                  Map <String, dynamic>userMap = {
                    'nom': globalUser.nom,
                    'prenom': globalUser.prenom,
                    'id': globalUser.id,
                    'compagnie': globalUser.compagnie,
                    'telephone': globalUser.telephone,
                    'image': globalUser.image,
                    'typeUtilisateur': globalUser.type_utilisateur,
                    'login': globalUser.pseudo,
                    'mail': globalUser.mail,
                    'sexe': globalUser.sexe,
                    'naissance': globalUser.naissance,
                    'avoir': (widget.useAvoir) ? prixResume : globalUser.avoir,
                  };
                  firebaseHelper().addUser(globalUser.id, userMap);
                  recuperationValeur(
                      idenfiantCompagnie: widget.ticket.idCompagnieAller,
                      prix: widget.ticket.prixAller);
                  (widget.ticket.billetRetour) ? recuperationValeur(
                      idenfiantCompagnie: widget.ticket.idCompagnieRetour,
                      prix: widget.ticket.prixRetour) : null;

                  timer.cancel();
                }
                if (paymentcheck.status == "FAILED") {
                  timer.cancel();
                }
              }
              else {
                timer.cancel();
                print('fini');
              }
            });
          }

          if (paymentcheck.status == 'SUCCESS') {
            print("enregistrement");
            billetrecording(true,idfacture: number_order);
            creationFacture(prixTotal, number_order);
            Map <String, dynamic>userMap = {
              'nom': globalUser.nom,
              'prenom': globalUser.prenom,
              'id': globalUser.id,
              'compagnie': globalUser.compagnie,
              'telephone': globalUser.telephone,
              'image': globalUser.image,
              'typeUtilisateur': globalUser.type_utilisateur,
              'login': globalUser.pseudo,
              'mail': globalUser.mail,
              'sexe': globalUser.sexe,
              'naissance': globalUser.naissance,
              'avoir': (widget.useAvoir) ? prixResume : globalUser.avoir,
            };
            firebaseHelper().addUser(globalUser.id, userMap);
            recuperationValeur(
                idenfiantCompagnie: widget.ticket.idCompagnieAller,
                prix: widget.ticket.prixAller);
            (widget.ticket.billetRetour) ? recuperationValeur(
                idenfiantCompagnie: widget.ticket.idCompagnieRetour,
                prix: widget.ticket.prixRetour) : null;
          }
          if (paymentcheck.status == 'FAILED') {
            print('non timer');
            billetrecording(false);
          }
        }
        else {
          print('non');
        }
      });
    }
  }




  Future payewithoutAvoir() async {
    billetrecording(false);

    int prixTotal=0;
    if(widget.ticket.billetRetour){
      setState(() {
        prixTotal = widget.ticket.prixAller + widget.ticket.prixRetour;
      });


    }
    else
    {
      setState(() {
        prixTotal=widget.ticket.prixAller;
      });


    }





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
    int prixResume=prixTotal;

    Map <String, dynamic> bodypayment = {
      "Content-Type": "application/json",
      "merchant_key": "bd77ff4d",
      "currency": "OUV",
      "order_id": number_order,
      "amount": prixTotal.toString(),
      "return_url": "http://www.koko0017.odns.fr",
      "cancel_url": "http://www.koko0017.odns.fr",
      "notif_url": "http://www.koko0017.odns.fr/notifications",
      "lang": "fr",
      "reference": "Africar",

    };


    http.Response paymentResponse = await http.post(
        urlPaiement,
        headers: headerpayment,
        body: jsonEncode(bodypayment)

    );
    TokenPayment paymenttoken = TokenPayment.fromJson(
        jsonDecode(paymentResponse.body));


    //headerverification
    Map<String, String>headerverification = {
      HttpHeaders.authorizationHeader: "${body.token_type} ${body
          .access_token}",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.hostHeader: "api.orange.com",
      //HttpHeaders.contentTypeHeader:"application/json; charset=UTF-8"


    };
    Map<String, dynamic>bodynotification = {
      "status": "SUCCESS",
      "notif_token": paymenttoken.notif_token,
      "txnid": ""
    };
    http.Response notificationpage = await http.post(
        "http://www.koko0017.odns.fr/notifications",
        body: bodynotification);


    //Lancement de la page paiement



    Map<String, dynamic> bodyverification = {
      "order_id": number_order,
      "amount": prixTotal.toString(),
      "pay_token": paymenttoken.pay_token,
      "payment_url": paymenttoken.payment_url,
      "notif_token": paymenttoken.notif_token,
      "txnid": "",
      "content-type": "application/json; charset=UTF-8"
    };
    if (await canLaunch(paymenttoken.payment_url)) {
      await launch(paymenttoken.payment_url);
    } else {
      throw 'Could not launch ${paymenttoken.payment_url}';
    }
    int counter = 0;
    Timer(Duration(seconds: 30), () async {
      http.Response verificationPaiement = await http.post(
          "https://api.orange.com/orange-money-webpay/dev/v1/transactionstatus"
          , body: json.encode(bodyverification),
          headers: headerverification);
      CheckoutPayment paymentcheck = CheckoutPayment.fromJson(
          jsonDecode(verificationPaiement.body));

      if (verificationPaiement.statusCode == 201) {
        print(paymentcheck.status);
        if (paymentcheck.status == 'INITIATED') {
          Timer.periodic(Duration(seconds: 30), (timer) async {
            if (counter < 10) {
              counter++;
              print(counter);
              verificationPaiement = await http.post(
                  "https://api.orange.com/orange-money-webpay/dev/v1/transactionstatus"
                  , body: json.encode(bodyverification),
                  headers: headerverification);
              paymentcheck = CheckoutPayment.fromJson(
                  jsonDecode(verificationPaiement.body));
              print(paymentcheck.status);
              if (paymentcheck.status == 'SUCCESS') {
                print('enregistrement dans timer');
                creationFacture(prixResume, number_order);
                billetrecording(true,idfacture: number_order);
                Map <String, dynamic>userMap = {
                  'nom': globalUser.nom,
                  'prenom': globalUser.prenom,
                  'id': globalUser.id,
                  'compagnie': globalUser.compagnie,
                  'telephone': globalUser.telephone,
                  'image': globalUser.image,
                  'typeUtilisateur': globalUser.type_utilisateur,
                  'login': globalUser.pseudo,
                  'mail': globalUser.mail,
                  'sexe': globalUser.sexe,
                  'naissance': globalUser.naissance,
                  'avoir': globalUser.avoir,
                };
                firebaseHelper().addUser(globalUser.id, userMap);
                recuperationValeur(
                    idenfiantCompagnie: widget.ticket.idCompagnieAller,
                    prix: widget.ticket.prixAller);
                (widget.ticket.billetRetour) ? recuperationValeur(
                    idenfiantCompagnie: widget.ticket.idCompagnieRetour,
                    prix: widget.ticket.prixRetour) : null;


                timer.cancel();
              }
              if (paymentcheck.status == "FAILED") {
                timer.cancel();
              }
            }
            else {
              timer.cancel();
            }
          });
        }

        if (paymentcheck.status == 'SUCCESS') {
          print("enregistrement");
          creationFacture(prixResume, number_order);
          billetrecording(true,idfacture: number_order);
          Map <String, dynamic>userMap = {
            'nom': globalUser.nom,
            'prenom': globalUser.prenom,
            'id': globalUser.id,
            'compagnie': globalUser.compagnie,
            'telephone': globalUser.telephone,
            'image': globalUser.image,
            'typeUtilisateur': globalUser.type_utilisateur,
            'login': globalUser.pseudo,
            'mail': globalUser.mail,
            'sexe': globalUser.sexe,
            'naissance': globalUser.naissance,
            'avoir': globalUser.avoir,
          };
          firebaseHelper().addUser(globalUser.id, userMap);
          recuperationValeur(
              idenfiantCompagnie: widget.ticket.idCompagnieAller,
              prix: widget.ticket.prixAller);
          (widget.ticket.billetRetour) ? recuperationValeur(
              idenfiantCompagnie: widget.ticket.idCompagnieRetour,
              prix: widget.ticket.prixRetour) : null;
        }
        if (paymentcheck.status == 'FAILED') {
          print('non timer');
          billetrecording(false);
        }
      }
      else {
        print('non');
      }
    });




  }



  creationFacture(int prix,String number) async{

      prix = widget.ticket.prixAller + widget.ticket.prixRetour;

    DateTime vendu=DateTime.now();
    String forrmatDate= DateFormat('yyyy-MM-dd').format(vendu);
    Map <String,String> headerfacture={
      HttpHeaders.authorizationHeader:'QSTCsbbtRLNYBVUhoyT3',


      HttpHeaders.acceptHeader:"application/json",
      HttpHeaders.contentTypeHeader:"application/json"
      //"Postman-Token": "e18f3aac-9bd7-ddc5-a3a4-668e6089a0d5"
    };
    print(forrmatDate);


    Map <String,dynamic> bodyfacture ={
      "Content-Type":"application/json",
      "api_token":"QSTCsbbtRLNYBVUhoyT3",
      "invoice":{
        "kind":"vat",
        "number": number,
        "sell_date": forrmatDate,
        "issue_date":forrmatDate,
        "payment_to":forrmatDate,
        "seller_name": "Africars",
        "seller_tax_no": "5252445767",
        "paid":prix,
        "buyer_name": "${globalUser.nom} ${globalUser.prenom}",
        //"buyer_tax_no": "5252445767",
        "positions":[{"name":"${widget.ticket.lieuDepart}-${widget.ticket.lieuArrivee}", "tax":23, "total_price_gross":widget.ticket.prixAller, "quantity":1},
          (widget.ticket.billetRetour)?{"name":"${widget.ticket.lieuArrivee}-${widget.ticket.lieuDepart}", "tax":23, "total_price_gross":widget.ticket.prixRetour, "quantity":1}:null]
      }
    };


    http.Response facture = await http.post("https://k-b-k-services-groupes.vosfactures.fr/invoices.json",
        headers: headerfacture,body: jsonEncode(bodyfacture));

  }





  Future recuperationValeur ({String idenfiantCompagnie,int prix}) async{
    DateTime maintenant=DateTime.now();
    int jan=0;
    int fev=0;
    int index=0;
    int mar=0;
    int avril=0;
    int mai=0;
    int juin=0;
    int juil=0;
    int aout=0;
    int sep=0;
    int oct=0;
    int nov=0;
    int dec=0;
    Stream firebaseStream;

    String uidChiffre='${maintenant.year}$idenfiantCompagnie';
    //String uidChiffre='${maintenant.year}lJ7yFzQ0nPQ3uXTXGzTLz2g8psD3';




    firebaseStream =firebaseHelper().fire_chiffre.document(uidChiffre).snapshots();
    print('affichage event');
    print(firebaseStream.runtimeType);
    print(firebaseStream.toString().length);
    firebaseStream.listen((event) {
      print('type event');
      print(event.runtimeType);
      print(event.exists);
      if(event.exists) {
        while(index<1) {
          print("uidChiffre existe");
          int ancienjan = event.data['Janvier'];
          int ancienfev = event.data['Fevrier'];
          int ancienmar = event.data['Mars'];
          int ancienavril = event.data['Avril'];
          int ancienmai = event.data['Mai'];
          int ancienjuin = event.data['Juin'];
          int ancienjuil = event.data['Juillet'];
          int ancienaout = event.data['Aout'];
          int anciensep = event.data['Septembre'];
          int ancienoct = event.data['Octobre'];
          int anciennov = event.data['Novembre'];
          int anciendec = event.data['Decembre'];
          //vérification
          if (maintenant.month == DateTime.january) {
            jan = prix + ancienjan;
          }
          if (maintenant.month == DateTime.february) {
            fev = prix + ancienfev;
          }
          if (maintenant.month == DateTime.march) {
            mar = prix + ancienmar;
          }
          if (maintenant.month == DateTime.april) {
            avril = prix + ancienavril;
          }
          if (maintenant.month == DateTime.may) {
            mai = prix + ancienmai;
          }
          if (maintenant.month == DateTime.june) {
            juin = prix + ancienjuin;
          }
          if (maintenant.month == DateTime.july) {
            juil = prix + ancienjuil;
          }
          if (maintenant.month == DateTime.august) {
            aout = prix + ancienaout;
          }
          if (maintenant.month == DateTime.september) {
            sep = prix + anciensep;
          }
          if (maintenant.month == DateTime.october) {
            oct = prix + ancienoct;
          }
          if (maintenant.month == DateTime.november) {
            nov = prix + anciennov;
          }
          if (maintenant.month == DateTime.december) {
            dec = prix + anciendec;
          }
          ////
          Map<String, dynamic> map = {
            'Janvier': jan,
            'Fevrier': fev,
            'Mars': mar,
            'Avril': avril,
            'Mai': mai,
            'Juin': juin,
            'Juillet': juil,
            'Aout': aout,
            'Septembre': sep,
            'Octobre': oct,
            'Novembre': nov,
            'Decembre': dec,
            'uidChiffre': uidChiffre,
          };
          firebaseHelper().addChiffre(uidChiffre, map);
          index++;
        }



      }
      else
      {
        print("UidChiffre n'existe pas");
        //vérification
        if(maintenant.month==DateTime.january)
        {
          jan=prix;
        }
        if(maintenant.month==DateTime.february)
        {
          fev=prix;
        }
        if(maintenant.month==DateTime.march)
        {
          mar=prix;
        }
        if(maintenant.month==DateTime.april)
        {
          avril=prix;
        }
        if(maintenant.month==DateTime.may)
        {
          mai=prix;
        }
        if(maintenant.month==DateTime.june)
        {
          juin=prix;
        }
        if(maintenant.month==DateTime.july)
        {
          juil=prix;
        }
        if(maintenant.month==DateTime.august)
        {
          aout=prix;
        }
        if(maintenant.month==DateTime.september)
        {
          sep=prix;
        }
        if(maintenant.month==DateTime.october)
        {
          oct=prix;
        }
        if(maintenant.month==DateTime.november)
        {
          nov=prix;
        }
        if(maintenant.month==DateTime.december)
        {
          dec=prix;
        }
        ////
        Map<String,dynamic> map={
          'Janvier':jan,
          'Fevrier':fev,
          'Mars':mar,
          'Avril':avril,
          'Mai':mai,
          'Juin':juin,
          'Juillet':juil,
          'Aout':aout,
          'Septembre':sep,
          'Octobre':oct,
          'Novembre':nov,
          'Decembre':dec,
          'uidChiffre':uidChiffre,
        };
        firebaseHelper().addChiffre(uidChiffre, map);
        index++;
      }
      index++;

    });
  }



  affichageAvoir()
  {
    //billetrecording(false);
    //recuperationValeur(idenfiantCompagnie: widget.voyageAller.idCompagnie,prix: widget.voyageAller.prix);
    keyinfoValue.currentState.showBottomSheet((builder)=>MyinformationAvoir(refbillet: widget.ticket.id,));
  }






}