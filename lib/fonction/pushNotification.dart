

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class pushNotification {

  FirebaseMessaging fcm =FirebaseMessaging();
  StreamSubscription iosSubscription;

  Future initialise()async{


    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }




}