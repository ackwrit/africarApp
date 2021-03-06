import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:africars/controller/facture.dart';
import 'package:africars/controller/reservationController.dart';
import 'package:africars/fonction/firebaseHelper.dart';
import 'package:africars/main.dart';
import 'package:africars/model/chiffres.dart';
import 'package:africars/model/my_checkout_payment.dart';
import 'package:africars/model/my_token.dart';
import 'package:africars/model/my_token_payment.dart';
import 'package:africars/model/trajet.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:africars/view/my_widgets/my_information.dart';
import 'package:africars/view/my_widgets/my_information_avoir.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class bookingController extends StatefulWidget{
  bool retour;
  trajet voyageAller;
  trajet voyageRetour;
  DateTime momentDepart;
  DateTime momentArrivee;
  DateTime momentDepartRetour;
  DateTime momentArriveeRetour;
  int nombrePassager;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bookingController({trajet voyageAller,trajet voyageRetour,
    DateTime momentDepart,DateTime momentDepartRetour,DateTime momentArrivee,
  DateTime momentArriveeRetour,bool retour,int nombrePassager})
  {
    this.retour=retour;
    this.voyageAller=voyageAller;
    this.voyageRetour=voyageRetour;
    this.momentDepart=momentDepart;
    this.momentArrivee=momentArrivee;
    this.momentDepartRetour=momentDepartRetour;
    this.momentArriveeRetour=momentArriveeRetour;
    this.nombrePassager=nombrePassager;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeBooking();
  }

}

class homeBooking extends State<bookingController>{
  GlobalKey <ScaffoldState> keyinfo = GlobalKey<ScaffoldState>();
  String generateQRCode=randomAlphaNumeric(20);
  String generateQRCodeRetour=randomAlphaNumeric(20);
  String refBillet=randomAlphaNumeric(13);

  utilisateur profil;
  String identifiant;
  var formatchiffre = new NumberFormat('#,###','fr_FR');
  int compteur=1;
  PhoneNumber number= PhoneNumber(isoCode: 'ML');

  DateFormat formatjour = DateFormat.yMMMMd('fr_FR');
  DateFormat formatheure = DateFormat.Hm('fr_FR');
  String nom;
  String prenom;
  FirebaseMessaging fcm =FirebaseMessaging();
  StreamSubscription iosSubscription;
  String uid;
  bool personne=false;
  bool avoir=false;
  int sommeAvoir=0;
  String tokenNotification;
  int _messageCount=0;
  String _message;

  @override

  void initState() {
    // TODO: implement initState
    super.initState();

    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
      ));
      fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      });
    }
    fcm.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message ");
      },




    );
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
      key:keyinfo,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.home,size: 35,),onPressed:(){
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context)
                  {
                    return MyHomePage();
                  }
          ));

        },),
        title: Image.asset("assets/newlogo.jpg",height: 225,),
        centerTitle: true,
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.orangeAccent,
      body: bodyPage(),
    );
  }


  Widget bodyPage(){
    return Container(
      padding: EdgeInsets.all(20),

      width: MediaQuery.of(context).size.width,
      child:SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(height: 10,),
                  (widget.retour==true)?Text("Aller"):Text("Aller simple"),
                  Container(height: 10,),
                  Text("Référence du billet : $refBillet"),
                  Container(height: 10,),
                  Text(formatjour.format(widget.momentDepart)),
                  Container(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      QrImage(
                        data: generateQRCode,
                        version: QrVersions.auto,
                        size: 80.0,
                      ),
                      Text("${widget.voyageAller.depart} - ${widget.voyageAller.destination}",style: TextStyle(fontSize: 20),),


                    ],
                  ),
                  Container(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      (widget.voyageAller.logoCompagnie==null)?Container():Image.network(widget.voyageAller.logoCompagnie,height: 100,),
                      (widget.voyageAller.nomCompagnie==null)?Container():Text(widget.voyageAller.nomCompagnie),


                    ],


                  ),


                  SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ((nom==null )||(nom==''))?Text(globalUser.nom,style: TextStyle(fontSize: 18),):Text(nom,style: TextStyle(fontSize: 18),),
                      ((prenom==null )||(prenom==''))?Text(globalUser.prenom,style: TextStyle(fontSize: 18),):Text(prenom,style: TextStyle(fontSize: 18),),

                    ],
                  ),





                  SizedBox(height: 15,),

                  Text("Départ : ${formatheure.format(widget.voyageAller.heureDepart)}",style: TextStyle(fontSize: 18),),
                  //Text("Arrivée : ${formatheure.format(widget.voyageAller.heureDestination)}",style: TextStyle(fontSize: 18)),
                  Container(height: 10,)





                ],

              ),
              elevation: 10,
            ),
            (widget.retour)?Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(height: 10,),
                  (widget.retour==true)?Text("Retour"):Text("Aller simple"),
                  Container(height: 10,),
                  Text("Référence du billet : $refBillet"),
                  Container(height: 10,),
                  Text(formatjour.format(widget.momentArrivee)),
                  Container(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      QrImage(
                        data: generateQRCodeRetour,
                        version: QrVersions.auto,
                        size: 80.0,
                      ),
                      Text("${widget.voyageRetour.depart} - ${widget.voyageRetour.destination}",style: TextStyle(fontSize: 20),),


                    ],
                  ),
                  Container(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      (widget.voyageRetour.logoCompagnie==null)?Container():Image.network(widget.voyageRetour.logoCompagnie,height: 100,),
                      (widget.voyageRetour.nomCompagnie==null)?Container():Text(widget.voyageRetour.nomCompagnie),


                    ],


                  ),
                  Text("Départ : ${formatheure.format(widget.voyageRetour.heureDepart)}",style: TextStyle(fontSize: 18),),
                  //Text("Arrivée : ${formatheure.format(widget.voyageRetour.heureDestination)}",style: TextStyle(fontSize: 18)),
                  Container(height: 10,)





                ],

              ),
              elevation: 10,
            )


                :Container(),

            SizedBox(height: 10,),
            //Choix pour l'avoir
            Text('Utilisation de votre avoir'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('NON'),
                Switch.adaptive(
                    value: avoir,
                    onChanged: (value){
                      setState(() {
                        avoir=value;
                      });
                    }),

                Text('OUI'),
              ],
            ),
            SizedBox(height: 10,),
            (avoir==true && globalUser.avoir!=null)?Text('Vous avez ${globalUser.avoir} CFA sur votre compte'):Container(),
            SizedBox(height: 10,),


            Text("Réservation pour une tierce personne"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('NON'),
                Switch.adaptive(
                    value: personne,
                    onChanged: (bool t){
                      setState(() {
                        personne =t;
                        nom='';
                        prenom='';
                      });

                    }),
                Text('OUI'),
              ],
            ),





            (personne==true)?SizedBox(height: 5,):Container(),
            (personne==true)?InternationalPhoneNumberInput(
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
            ):Container(),
            (personne==true)?SizedBox(height: 5,):Container(),
            (personne==true)?Text('Passager',style: TextStyle(fontSize: 25),):Container(),


            (personne==true)?SizedBox(height: 5,):Container(),

            (personne==true)?ajout():Container(),



           /* TextField(
              onChanged: (String text){
                setState(() {
                  nom=text;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: nom,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

            ),
            SizedBox(height: 15,),
            TextField(
              onChanged: (String text){
                setState(() {
                  prenom=text;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: prenom,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

            ),
            SizedBox(height: 15,),*/
            SizedBox(height: 15,),
           InkWell(
             onTap: ()=>(avoir)?paye():payewithoutAvoir(),
             child: Column(
             children:[
               Text('Paiement par Orange Money'),
               SizedBox(height: 5,),
               Image.asset("assets/logoorangemoney.jpeg",width: 180,),
               
             ],
             ),
           ),
            SizedBox(height: 25,),
            RaisedButton.icon(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: backgroundbar,
                onPressed:()=>affichage(),
                icon: Icon(FontAwesome.mobile_phone,color: background,size: 40,),
                label: Text('être rappeler',style: TextStyle(color: background,fontSize: 20),),),


            SizedBox(height: 15,),






          ],
        ),
      ),


    );

  }


  affichage()
  {

    billetrecording(false,'0','');
    //recuperationValeur(idenfiantCompagnie: widget.voyageAller.idCompagnie,prix: widget.voyageAller.prix);
   keyinfo.currentState.showBottomSheet((builder)=>Myinformation(refbillet: refBillet,));
  }




  affichageAvoir()
  {

    //recuperationValeur(idenfiantCompagnie: widget.voyageAller.idCompagnie,prix: widget.voyageAller.prix);
    keyinfo.currentState.showBottomSheet((builder)=>MyinformationAvoir(refbillet: refBillet,));
  }



  void billetrecording(bool validate,String idfacture,String token)
  {
    DateTime momentRetour;
    DateTime jourRetour;
    int prixtotal=0;
    if(widget.retour){
      prixtotal =widget.voyageAller.prix +widget.voyageRetour.prix;
    }
    else
    {
      prixtotal = widget.voyageAller.prix;
    }
    DateTime momentDepart=widget.momentDepart;
    if(widget.retour)
    {
      momentRetour = widget.momentArrivee;
      jourRetour=new DateTime(momentRetour.year,momentRetour.month,momentRetour.day,widget.voyageRetour.heureDepart.hour,widget.voyageRetour.heureDepart.minute);
    }

   DateTime jourDepart =new DateTime(momentDepart.year,momentDepart.month,momentDepart.day,widget.voyageAller.heureDepart.hour,widget.voyageAller.heureDepart.minute);


    //Enregistrement billet en mode provisoire
    Map <String,dynamic>map={
      'emission':DateTime.now(),
      'departAller':widget.voyageAller.depart,
      'telephone':(personne==false)?globalUser.telephone:number.toString(),
      'retourAller':(widget.retour)?widget.voyageAller.destination:'',
      'departRetour':(widget.retour)?widget.voyageRetour.depart:'',
      'retourRetour':(widget.retour)?widget.voyageRetour.destination:'',
      'logoCompagnieAller':widget.voyageAller.logoCompagnie,
      'idCompagnieAller':widget.voyageAller.idCompagnie,
      'logoCompagnieRetour':(widget.retour)?widget.voyageRetour.logoCompagnie:'',
      'idCompagnieRetour':(widget.retour)?widget.voyageRetour.idCompagnie:'',
      'lieuDepart': widget.voyageAller.depart.toString(),
      'lieuArrivee':widget.voyageAller.destination.toString(),
      'nbPassager':widget.nombrePassager,
      'nomPassager':(personne==false)?globalUser.nom:nom,
      'idvoyageur':globalUser.id,
      'prenomPassager':(personne==false)?globalUser.prenom:prenom,
      'qrCodeAller':generateQRCode,
      'qrCodeRetour':(widget.retour)?generateQRCodeRetour:'',
      'billerRetour':widget.retour,
      'validate':validate,
      'onboarding':false,
      'jourAller':jourDepart,
      'jourRetour':(widget.retour)?jourRetour:DateTime.now(),
      'prixAller':widget.voyageAller.prix,
      'prixRetour':(widget.retour)?widget.voyageRetour.prix:0,
      'idBillet':refBillet,
      'idfacture':idfacture,
      'tokenNotification':token

    };
    firebaseHelper().addBillet(refBillet, map);

  }




  Future payewithoutAvoir() async {
    tokenNotification= await fcm.getToken();
    sendPushMessage();
    print('token');
    print(tokenNotification);


    billetrecording(false,'0',tokenNotification);

    int prixTotal=0;
    if(widget.retour){
      setState(() {
        prixTotal = widget.voyageAller.prix + widget.voyageRetour.prix;
      });


    }
    else
    {
      setState(() {
        prixTotal=widget.voyageAller.prix;
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
        "amount": (avoir) ? prixResume.toString() : prixTotal.toString(),
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
        "amount": (avoir) ? prixResume.toString() : prixTotal.toString(),
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
                  billetrecording(true,number_order,tokenNotification);
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
                    'avoir': sommeAvoir,
                  };
                  firebaseHelper().addUser(globalUser.id, userMap);
                  recuperationValeur(
                      idenfiantCompagnie: widget.voyageAller.idCompagnie,
                      prix: widget.voyageAller.prix);
                  (widget.retour) ? recuperationValeur(
                      idenfiantCompagnie: widget.voyageRetour.idCompagnie,
                      prix: widget.voyageRetour.prix) : null;


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
            billetrecording(true,number_order,tokenNotification);
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
              'avoir': sommeAvoir,
            };
            firebaseHelper().addUser(globalUser.id, userMap);
            recuperationValeur(
                idenfiantCompagnie: widget.voyageAller.idCompagnie,
                prix: widget.voyageAller.prix);
            (widget.retour) ? recuperationValeur(
                idenfiantCompagnie: widget.voyageRetour.idCompagnie,
                prix: widget.voyageRetour.prix) : null;
          }
          if (paymentcheck.status == 'FAILED') {
            print('non timer');
            billetrecording(false,'0',tokenNotification);
          }
        }
        else {
          print('non');
        }
      });




  }



  String constructFCMPayload(String token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'Africars',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Africars',
        'body': 'Votre billet n° $refBillet est en cours de réservation ...',
      },
    });
  }


  Future sendPushMessage() async{
    if (tokenNotification == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        'https://api.rnfirebase.io/messaging/send',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(tokenNotification),
      );
      print('FCM request for device sent!');


    } catch (e) {
      print(e);
    }
  }



  Future paye() async {
    tokenNotification= await fcm.getToken();
    billetrecording(false,'0',tokenNotification);
    if(globalUser.avoir==null){
      sommeAvoir=0;
    }
    int prixTotal=0;
    if(widget.retour){
      prixTotal = widget.voyageAller.prix + widget.voyageRetour.prix;

    }
    else
      {
        prixTotal=widget.voyageAller.prix;

      }




    if(globalUser.avoir>=prixTotal){
      sommeAvoir=globalUser.avoir-prixTotal;

    }
    else {
      sommeAvoir = 0;
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
        int prixResume=prixTotal-globalUser.avoir;
        if(prixResume<=0)
          {
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
            billetrecording(true,number_order,tokenNotification);
            creationFacture(0, number_order);
            //Affichage qu'il y'a bien ernregistrement du billet dans la base de donnée.
            affichageAvoir();
          }
        else {
          Map <String, dynamic> bodypayment = {
            "Content-Type": "application/json",
            "merchant_key": "bd77ff4d",
            "currency": "OUV",
            "order_id": number_order,
            "amount": (avoir) ? prixResume.toString() : prixTotal.toString(),
            "return_url": "http://www.koko0017.odns.fr",
            "cancel_url": "http://www.koko0017.odns.fr",
            "notif_url": "http://www.koko0017.odns.fr/notifications",
            "lang": "fr",
            "reference": "Africar",

          };
          creationFacture(prixTotal, number_order);

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
          print('création de la facture');
          creationFacture(prixResume, number_order);
          print('fin de la création');


          Map<String, dynamic> bodyverification = {
            "order_id": number_order,
            "amount": (avoir) ? prixResume.toString() : prixTotal.toString(),
            "pay_token": paymenttoken.pay_token,
            "payment_url": paymenttoken.payment_url,
            //"notif_token": paymenttoken.notif_token,
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
                      billetrecording(true,number_order,tokenNotification);
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
                        'avoir': sommeAvoir,
                      };
                      firebaseHelper().addUser(globalUser.id, userMap);
                      recuperationValeur(
                          idenfiantCompagnie: widget.voyageAller.idCompagnie,
                          prix: widget.voyageAller.prix);
                      (widget.retour) ? recuperationValeur(
                          idenfiantCompagnie: widget.voyageRetour.idCompagnie,
                          prix: widget.voyageRetour.prix) : null;


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
                billetrecording(true,number_order,tokenNotification);
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
                  'avoir': sommeAvoir,
                };
                firebaseHelper().addUser(globalUser.id, userMap);
                recuperationValeur(
                    idenfiantCompagnie: widget.voyageAller.idCompagnie,
                    prix: widget.voyageAller.prix);
                (widget.retour) ? recuperationValeur(
                    idenfiantCompagnie: widget.voyageRetour.idCompagnie,
                    prix: widget.voyageRetour.prix) : null;
              }
              if (paymentcheck.status == 'FAILED') {
                print('non timer');
                billetrecording(false,number_order,tokenNotification);
              }
            }
            else {
              print('non');
            }
          });
        }



  }


  creationFacture(int prix,String number) async{
    if(widget.retour) {
      prix = widget.voyageAller.prix + widget.voyageRetour.prix;
    }
    else
      {
        prix=widget.voyageAller.prix;
      }
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
        "positions":[{"name":"${widget.voyageAller.depart}-${widget.voyageAller.destination}", "tax":23, "total_price_gross":widget.voyageAller.prix, "quantity":1},
              (widget.retour)?{"name":"${widget.voyageRetour.depart}-${widget.voyageRetour.destination}", "tax":23, "total_price_gross":widget.voyageRetour.prix, "quantity":1}:null]
      }
    };


    http.Response facture = await http.post("https://k-b-k-services-groupes.vosfactures.fr/invoices.json",
        headers: headerfacture,body: jsonEncode(bodyfacture));

  }

  Widget ajout()
  {


    return ListView.builder(
      itemCount: widget.nombrePassager,
        shrinkWrap: true,
        itemBuilder: (BuildContext context,int index){
        return Column(
          children: [
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2-30,
                  child:  TextField(
                    onChanged: (text){
                      setState(() {
                        nom=text;
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: nom,
                      labelText: 'Nom',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2-30,
                  child: TextField(
                    onChanged: (text){
                      setState(() {
                        prenom=text;
                        print(prenom);
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: prenom,
                      labelText: 'Prénom',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                  ),
                ),





              ],
            ),
            SizedBox(height: 15,),
          ],


        );


        }
    );

  }


  Future recuperationValeur ({String idenfiantCompagnie,int prix,String nomCompagnie}) async{
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
            'nomCompagnie':nomCompagnie
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
            'nomCompagnie':nomCompagnie
          };
          firebaseHelper().addChiffre(uidChiffre, map);
          index++;
        }
      index++;

    });
  }






}