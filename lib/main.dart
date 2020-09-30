import 'dart:async';
import 'dart:io';

import 'package:africars/controller/dateController.dart';
import 'package:africars/controller/informationController.dart';
import 'package:africars/controller/profilController.dart';
import 'package:africars/controller/registerController.dart';
import 'package:africars/controller/settingsProfilController.dart';
import 'package:africars/controller/trajetController.dart';
import 'package:africars/fonction/pushNotification.dart';
import 'package:africars/view/my_material.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'controller/avoirController.dart';
import 'controller/modificationProfil.dart';
import 'fonction/firebaseHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: authentification(),
      debugShowCheckedModeBanner: false,
    );
  }


  Widget authentification(){
    PageController pageController=PageController(initialPage: 0);
    int BottomSelectedIndex=0;


    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context,snapshot){
          if(snapshot.hasData){

            return MyHomePage();
          }
          else
          {
            return MyHomePage();
          }

        }
    );

  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);




  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  PageController pageController = PageController(initialPage: 0);
  int bottomSelectedIndex = 0;
  pushNotification _notification;
  FirebaseMessaging fcm = FirebaseMessaging();
  String identifiant;
  int selectedindex=0;



  pageIndex(int pos){
    switch(pos){
      case 0: return pageBody();
      case 1:return registerController();


    };

  }


  pageIndexConnexion(int pos){
    switch(pos){
      case 0: return pageBody();
      case 1:return print('profil');
      case 2: return avoirController();
      case 3:return modificationProfil();



    };

  }





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
        print('IOS settings register');
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
    initialisation();
  }




  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR');
    firebaseHelper().myId().then((uid)
    {
      setState(() {
        identifiant=uid;
      });
      firebaseHelper().getUser(identifiant).then((user)
      {
        setState(() {
          globalUser=user;
        });

      });
    });


    if (Theme
        .of(context)
        .platform == TargetPlatform.iOS) {
      return Configuration();
    }
    else {
      return Configuration();
    }
  }


  Widget Configuration() {





    return Scaffold(
      drawer: (globalUser==null)?Drawervide():Drawerpresent(),
        appBar: new AppBar(
          actions: <Widget>[
            (globalUser==null)?Container():Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.credit_card),
                Text(" ${globalUser.avoir} CFA")
                
              ], 
              
            ),

          ],


          centerTitle: true,
          flexibleSpace: Image.asset(
            "assets/newlogo.jpg", height: 800, width: 800,),

          backgroundColor: Colors.black,


        ),
        body: (globalUser==null)?pageIndex(selectedindex):pageIndexConnexion(selectedindex),












        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.black,

              primaryColor: Colors.orange,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(
                  caption: TextStyle(color: Colors.orange)
              )
          ),
          child: BottomNavigationBar(


            currentIndex: bottomSelectedIndex,
            selectedItemColor: Colors.orangeAccent,


            onTap: (index) {
              bottomTapped(index);
            },
            items: [
              new BottomNavigationBarItem(icon: new Icon(Icons.departure_board),
                title: new Text("Trajet", style: TextStyle(fontSize: 18),),),
              new BottomNavigationBarItem(icon: new Icon(Icons.bookmark),
                  title: new Text(
                    'Réservation', style: TextStyle(fontSize: 18),)),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.add_alert_rounded),
                  title: new Text(
                    'Notification', style: TextStyle(fontSize: 18),)),

            ],
            backgroundColor: Colors.black,

          ),


        )

    );
  }


  Widget pageBody()
  {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },

      children: [
        trajetController(),
        dateController(),
        informationController(),
      ],
    );
  }


  Future initialisation() async {
    String token = await fcm.getToken();
    print("Firebase messaging: $token");
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }


  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(
          index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }


  Widget Drawervide(){

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Text('Profil'),

            ),
            decoration: BoxDecoration(

              color: Colors.orangeAccent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Menu'),
            selected: (selectedindex==0),
            onTap: () {
              setState(() {
                selectedindex=0;
              });

              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:Icon(Icons.login_rounded),
            title: Text("S'enregistrer"),
            selected: (selectedindex==1),
            onTap: () {
              setState(() {
                selectedindex=1;

              });

              Navigator.pop(context);
            },
          ),




        ],
      ),
    );

  }




  Widget Drawerpresent(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  (globalUser==null)?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 4,
                      )
                    ],
                  ):Text('${globalUser.prenom} ${globalUser.nom}'),
                  (globalUser.image==null)? Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/userIcon.png"),
                        )
                    ),
                  ): Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(globalUser.image)
                        )
                    ),
                  ),

                ],

              ),

            ),
            decoration: BoxDecoration(

              color: Colors.orangeAccent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Menu'),
            selected: (selectedindex==0),
            onTap: () {
              setState(() {
                selectedindex=0;
              });

              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:Icon(Icons.account_circle),
            title: Text('Profil'),
            selected: (selectedindex==1),
            onTap: () {
              setState(() {
                selectedindex=1;

              });

              Navigator.push(context,MaterialPageRoute(
                builder: (BuildContext context){
                  return settingsProfilController();
                }
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.credit_card_rounded),
            title: Text('Porte-Monnaie'),
            selected: (selectedindex==2),
            onTap: () {
              setState(() {
                selectedindex=2;
              });

              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètre'),
            selected: (selectedindex==3),
            onTap: () {
              setState(() {
                selectedindex=3;
              });
              Navigator.pop(context);
            },
          ),



        ],
      ),

    );

  }



}







