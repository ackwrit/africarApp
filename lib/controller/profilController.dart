import 'package:africars/controller/registerController.dart';
import 'package:africars/controller/settingsProfilController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profilController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeSettingsProfil();
  }

}


class homeSettingsProfil extends State<profilController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return handleAuth();
  }


  Widget handleAuth() {
    return StreamBuilder <FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          //Si on a des datas , on est authentifié
          return settingsProfilController();
        }
        else {
          //on est n'est pas off page sans connexion
          return registerController();
        }
      },

    );
  }
}