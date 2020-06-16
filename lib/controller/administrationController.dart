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
              title: Image.asset("assets/logo.png",height: 225,),
              backgroundColor: Colors.black,

            ),
            backgroundColor: Colors.orange,
            body: controllerSelected,
          );
        }
    );

  }



  Widget androidConfig(){

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