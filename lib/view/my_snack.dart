import 'package:africars/view/my_material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';


class Mysnackbar extends StatefulWidget{
  DateTime momentDepart;
  DateTime momentArrivee;
  String periode;
  Mysnackbar({DateTime this.momentDepart,DateTime this.momentArrivee,String this.periode});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SnackbarState();
  }

}

class SnackbarState extends State<Mysnackbar>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: MediaQuery.of(context).size.height/1.43,
      color: background,
      child:Container(

        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CalendarStrip(
                containerHeight: 100,


                onDateSelected: (heure)
                {
                  if(widget.periode=='depart')
                  {
                    setState(() {
                      widget.momentDepart=heure;
                    });

                  }
                  else
                  {
                    setState(() {
                      widget.momentArrivee=heure;
                    });
                  }

                }
            ),
            Text('Horaire',style: TextStyle(fontSize: 20),),
            TimePickerSpinner(
              isForce2Digits: true,
              minutesInterval: 15,
              highlightedTextStyle: TextStyle(color: background,fontSize: 20),
              normalTextStyle: TextStyle(color: Colors.black,fontSize: 10),
              onTimeChange: (time)
              {
                if(widget.periode=='depart')
                {
                  DateTime hour = new DateTime(widget.momentDepart.year,widget.momentDepart.month,widget.momentDepart.day,time.hour,time.minute);
                  setState(() {
                    momentDepartNational=hour;
                    momentDepartInternational=hour;
                  });
                }
                else
                {
                  DateTime houre = new DateTime(widget.momentArrivee.year,widget.momentArrivee.month,widget.momentArrivee.day,time.hour,time.minute);
                  setState(() {
                    momentArriveeNational=houre;
                    momentArriveeInternational=houre;
                  });

                }
              },

            ),
            RaisedButton(
                onPressed: (){
                  print(widget.momentDepart);
                  Navigator.pop(context,widget.momentDepart);
                },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: backgroundbar,
              child: Text("Valider",style: TextStyle(color: background),),
            )

          ],
        ),
      )
    );

  }

}