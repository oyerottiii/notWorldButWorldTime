import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart';

class WorldTime {
  String location;
  late String time;
  String flag;
  String url;
  late bool isDaytime;

  WorldTime({
    required this.location,
    required this.flag,
    required this.url,
  });

  Future<void> getTime() async {
    try {
      Response myret =
          await get(Uri.parse("http://worldtimeapi.org/api/timezone/$url"));
      Map data = jsonDecode(myret.body);

      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(0, 3);
      String plusOrMinus = data['utc_offset'].substring(0, 1);
      DateTime now = DateTime.parse(datetime);
      if (plusOrMinus == '-') {
        now = now.subtract(Duration(hours: int.parse(offset)));
      } else {
        now = now.add(Duration(hours: int.parse(offset)));
      }

      // DateTime now = DateTime.parse(datetime);
      // now.add(Duration(hours: int.parse(offset)));

      isDaytime = now.hour > 6 && now.hour < 19 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('caught error: $e');
      time = 'could not get time data';
    }
  }
}
