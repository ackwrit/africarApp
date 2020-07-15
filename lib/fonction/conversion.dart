import 'package:date_format/date_format.dart';

class conversion{


  DateTime stringtoDateTime(String time){
    DateTime todayDate = DateTime.parse(time);
    print(todayDate);
    print(formatDate(todayDate, [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));
    return todayDate;
  }

  String dateTimetoString(DateTime time)
  {
    String today=time.toIso8601String();
    return today;


  }
}