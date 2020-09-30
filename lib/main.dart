import 'dart:async';
import 'dart:io';

import 'package:africars/controller/dateController.dart';
import 'package:africars/controller/informationController.dart';
import 'package:africars/controller/profilController.dart';
import 'package:africars/controller/trajetController.dart';
import 'package:africars/fonction/pushNotification.dart';
import 'package:africars/view/my_material.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        appBar: new AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.account_circle, size: 40,), onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return profilController();
                  }
              ));
            }
            )

          ],


          centerTitle: true,
          flexibleSpace: Image.asset(
            "assets/newlogo.jpg", height: 800, width: 800,),

          backgroundColor: Colors.black,


        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            pageChanged(index);
          },

          children: [
            trajetController(),
            dateController(),
            informationController(),
          ],
        ),


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
                  icon: new Icon(Icons.info_outline_rounded),
                  title: new Text(
                    'Information', style: TextStyle(fontSize: 18),)),

            ],
            backgroundColor: Colors.black,

          ),


        )

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
}







