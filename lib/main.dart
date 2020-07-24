import 'package:africars/controller/dateController.dart';
import 'package:africars/controller/profilController.dart';
import 'package:africars/controller/registerController.dart';
import 'package:africars/controller/trajetController.dart';
import 'package:africars/controller/trajetInternationalController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: ''),
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


  @override
  Widget build(BuildContext context) {
  if(Theme.of(context).platform==TargetPlatform.iOS)
    {
      return iosConfig();
    }
    else{
    return androidConfig();
    }







  }



  Widget iosConfig()
  {
    return new CupertinoTabScaffold(
        tabBar: new CupertinoTabBar(
            backgroundColor: Colors.black,
            activeColor: Colors.orange,
            inactiveColor: Colors.white,
            items:[
              new BottomNavigationBarItem(icon: new Icon(Icons.map),title: new Text("National",style: TextStyle(fontSize: 18),),),
              new BottomNavigationBarItem(icon: new Icon(Icons.map),title: new Text("International",style: TextStyle(fontSize: 18),),),
              new BottomNavigationBarItem(icon: new Icon(Icons.bookmark),title: new Text('Réservation',style: TextStyle(fontSize: 18),)),







            ]),
        tabBuilder: (BuildContext context,int index){
          Widget controllerSelected= controllers()[index];
          return new Scaffold(
            appBar: new AppBar(
              actions: [
                IconButton(icon:Icon(Icons.account_circle,size: 40,), onPressed:()
                {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context)
                      {
                        return profilController();
                      }
                  ));

                }
                )
              ],

              title:Image.asset("assets/logo.png",height: 225,),
              backgroundColor: Colors.black,),
            body: controllerSelected,


          );
        }
    );
  }



  Widget androidConfig(){
    
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:Image.asset("assets/logo.png",height: 225,),
          backgroundColor: Colors.black,
          actions: [
            IconButton(icon:Icon(Icons.account_circle,size: 40,), onPressed:()
            {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context)
                  {
                    return profilController();
                  }
              ));

            }
            )

          ],
          centerTitle: true,
          bottom: TabBar
            (
            indicatorColor: Colors.orange,

              tabs: [
              Tab(icon:new Icon(Icons.map),child: new Text("National") ,),
                Tab(icon:new Icon(Icons.map),child: new Text("Interational") ,),
            Tab(icon:new Icon(Icons.bookmark),child: new Text("Réservation") ,),
          ]
          ),

        ),
        body: TabBarView(
            children: controllers()
        ),
      )
    );

  }




  List <Widget> controllers (){
    return [
      trajetController(),
      trajetInternationalController(),
     dateController(),







    ];

  }
}
