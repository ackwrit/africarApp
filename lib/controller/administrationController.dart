import 'package:africars/controller/donneeController.dart';
import 'package:africars/controller/professionnelSettingsController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class administrationController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return admin();
  }

}

class admin extends State<administrationController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(Theme.of(context).platform==TargetPlatform.iOS)
      {
        return iosConfig();
      }
    else
      {
        return androidConfig();
      }
  }




  Widget iosConfig(){
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.black,
            activeColor: Colors.orange,
            inactiveColor: Colors.white,
            items: [
              new BottomNavigationBarItem(icon: new Icon(Icons.info),title: new Text("information")),
              new BottomNavigationBarItem(icon: new Icon(Icons.settings),title: new Text('paramètre')),
              new BottomNavigationBarItem(icon: new Icon(Icons.pie_chart),title: new Text('données')),
            ]
        ),
        tabBuilder: (BuildContext context,int index){
          Widget controllerSelected = controller()[index];
          return Scaffold(
            appBar: AppBar(
              title: Image.asset("assets/newlogo.jpg",height: 225,),
              backgroundColor: Colors.black,

            ),
            backgroundColor: Colors.orangeAccent,
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
            title:Image.asset("assets/newlogo.jpg",height: 225,),
            backgroundColor: Colors.black,
            centerTitle: true,
            bottom: TabBar
              (
                indicatorColor: Colors.orangeAccent,

                tabs: [
                  Tab(icon: new Icon(Icons.info),child: new Text("information")),
                  Tab(icon:new Icon(Icons.settings),child: new Text('paramètre')),
                  Tab(icon: new Icon(Icons.pie_chart),child: new Text('données')),
                ]
            ),

          ),
          backgroundColor: Colors.orangeAccent,
          body: TabBarView(
              children: controller()
          ),
        )
    );

  }


  List <Widget> controller(){
    return
      [
        Text('Image'),
        professionnelSettingsController(),
        donneeController()


      ];
  }




}