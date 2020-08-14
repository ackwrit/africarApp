
import 'package:africars/model/utilisateur.dart';
import 'package:flutter/material.dart';


//Gloabl user
utilisateur globalUser;


//Widget
Widget imagebar = Image.asset("assets/logo.png",height: 225);


//couleur
Color background = Colors.orangeAccent;
Color backgroundbar =Colors.black;


//Gare

List <String> gares =[
  'Bamako','Bandiagara','Béma','Bla','Boni','Bougouni',
  'Diabé','Diboli','Didjan','Didjeni','Diéma','Dioïla','Djenné','Douentza',
  'Fana','Fatoma',
  'Gao','Gossi',
  'Hombori',
  'Kayes','Kéniéba','Kidal','Kita','Koffi','Kona','Konobougou','Koulikoro','Koury','Koutiala',
  'Labbezanga','Lakamani',
  'Mbessoba','Ménaka','Mopti',
  'Niéna','Niono','Nioro du Sahel',
  'San','Sandaré','Ségou','Sévaré','Sikasso',
  'Tabakoto','Taoudénit','Ténè','Tillaberry','Tombouctou','Toukoto',
  'Yangasso'
];