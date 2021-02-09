import 'dart:async';
import 'dart:io';
import 'package:africars/controller/dateController.dart';
import 'package:africars/controller/informationController.dart';
import 'package:africars/controller/registerController.dart';
import 'package:africars/controller/settingsProfilController.dart';
import 'package:africars/controller/trajetController.dart';
import 'package:africars/fonction/pushNotification.dart';
import 'package:africars/model/affichage_billet_validate.dart';
import 'package:africars/model/affichage_messagerie.dart';
import 'package:africars/view/my_material.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
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
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
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
      case 0 :return pageBody();
      break;
      case 7:return print('profil');
      break;
      case 1:return billetValidateController();
      break;
      case 2: return avoirController();
      break;
      case 3:return chatController(globalUser, serviceClient);
      break;
      case 4:return modificationProfil();
      break;
      case 5:return print('quitter');
      break;
      case 6:return print('se decconnecter');
      break;



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


    firebaseHelper().getUser(idServiceClient).then((user)
    {
      setState(() {
        serviceClient=user;
      });

    });
  }




  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR');



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
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: backgroundbar,
                    onPressed: (){
                    setState(() {
                      selectedindex=2;
                    });
                    },
                    icon: Icon(Icons.credit_card,color: Colors.white,),
                    label:  Text(" ${globalUser.avoir} CFA",style: TextStyle(color: Colors.white),)
                ),


                
              ], 
              
            ),

          ],


          centerTitle: true,
          flexibleSpace: Image.asset(
            "assets/newlogo.jpg", height: 800, width: 800,),

          backgroundColor: Colors.black,


        ),
        body: (globalUser==null)?pageIndex(selectedindex):pageIndexConnexion(selectedindex),
        bottomNavigationBar: (selectedindex==0)?Theme(
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
                  icon: new Icon(FontAwesome.bell),
                  title: new Text(
                    'Notification', style: TextStyle(fontSize: 18),)),

            ],
            backgroundColor: Colors.black,

          ),


        ):null

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
            leading:Icon(Icons.account_circle),
            title: Text('Profil'),
            selected: (selectedindex==7),
            onTap: () {
              setState(() {
                selectedindex=7;

              });

              Navigator.push(context,MaterialPageRoute(
                builder: (BuildContext context){
                  return settingsProfilController();
                }
              ));
            },
          ),
          ListTile(
            leading:Icon(Icons.departure_board_rounded),
            title: Text('Mes voyages'),
            selected: (selectedindex==1),
            onTap: () {
              setState(() {
                selectedindex=1;

              });

              Navigator.pop(context);
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
            leading: Icon(Icons.forum_rounded),
            title: Text('Service Client'),
            selected: (selectedindex==3),
            onTap: () {
              setState(() {
                selectedindex=3;
              });

              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètre'),
            selected: (selectedindex==4),
            onTap: () {
              setState(() {
                selectedindex=4;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app_rounded),
            title: Text('Quitter'),
            selected:(selectedindex==5),
            onTap: () {
              setState(() {
                selectedindex=5;
              });
              Navigator.push(context,MaterialPageRoute(
                  builder: (BuildContext context){
                    return MyHomePage();
                  }
              ));
            },
          ),
          SizedBox(height: 40,),
          Divider(
            color:Colors.black,
            thickness: 2,

          ),
          ListTile(
            leading: Icon(Icons.logout),
            selected: (selectedindex==6),
            title: Text('Se déconnecter'),
            onTap: () {
              setState(() {
                selectedindex=6;
              });
              MyDialog();


            },
          ),



        ],
      ),

    );

  }



  Future MyDialog() async{

    return showDialog(
        barrierDismissible: false,
        context:context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Suppression profil'),
            backgroundColor: background,
            content: SingleChildScrollView(
              child:ListBody(
                children: [
                  Text('Cette action supprimera toutes les informations liés à votre profil.'),
                  Text('Souhaitez-vous supprimer votre profil ?'),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton.icon(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: backgroundbar,
                      onPressed: (){
                        Navigator.pop(context);


                      },
                      icon: Icon(Icons.cancel,color: background,),
                      label: Text('NON',style: TextStyle(color: background),)
                  ),
                  SizedBox(width: 10,),
                  RaisedButton.icon(
                      color: backgroundbar,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onPressed: (){
                        FirebaseAuth.instance.signOut();
                        setState(() {
                          globalUser=null;
                        });
                        Navigator.push(context,MaterialPageRoute(
                            builder: (BuildContext context){
                              return MyApp();
                            }
                        ));

                      },
                      icon: Icon(Icons.delete_forever,color: background,),
                      label: Text('OUI',style: TextStyle(color: background),)
                  ),
                ],
              ),
            ],

          );
        }
    );


  }



}







