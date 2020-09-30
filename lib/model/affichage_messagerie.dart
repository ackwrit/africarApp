import 'package:africars/controller/Messagecontroller.dart';
import 'package:africars/model/utilisateur.dart';
import 'package:africars/view/my_widgets/constants.dart';
import 'package:africars/view/my_widgets/my_zone_text.dart';
import 'package:flutter/material.dart';


class chatController extends StatefulWidget{
  utilisateur moi;
  utilisateur partenaire;
  chatController(@required this.moi,@required this.partenaire);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return chatControllerState();
  }

}

class chatControllerState extends State<chatController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: background,
      body: bodyPage(),
    );
  }



  Widget bodyPage(){
    return Container(
      child: InkWell(
        onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
        child: Column(
          children: [
            //Zone de chat
            new Flexible(child: Container(
              height: MediaQuery.of(context).size.height,
              child: Messagecontroller(widget.moi,widget.partenaire),
            )),
            //Divider
            new Divider(height: 1.5,),
            //Zone de text
            ZoneText(widget.partenaire,widget.moi),
          ],
        ),
      ),
    );
  }

}