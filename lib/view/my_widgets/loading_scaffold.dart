import 'package:africars/view/my_material.dart';
import 'package:flutter/material.dart';


class LoadingScaffold extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: imagebar,
        backgroundColor: backgroundbar,
      ),
      backgroundColor: background,
      body:LoadingCenter()

    );
  }




}