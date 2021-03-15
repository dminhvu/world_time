import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time;
  String flag;
  String url;
  bool isDaytime = false;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      Response response = await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
      // print(Uri.parse('https://worldtimeapi.org/api/timezone/${url.toString()}'));
      Map data = jsonDecode(response.body);
      // print(data);
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1,3);
      String moffset = data['utc_offset'].substring(4,6);
      // print(datetime);
      // print(offset);
      // print(moffset);
      DateTime now = DateTime.parse(datetime);
      if (data['utc_offset'][0] == '+') now = now.add(Duration(hours: int.parse(offset), minutes: int.parse(moffset)));
      else now = now.add(Duration(hours: 24 - int.parse(offset), minutes: int.parse(moffset)));
      time = DateFormat.jm().format(now);
      isDaytime = (now.hour >= 6 && now.hour < 20);
    }
    catch (e) {
      print('caught error: $e');
      time = 'N/A';
    }
  }
}