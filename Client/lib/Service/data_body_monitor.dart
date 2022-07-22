import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Pages/settings_page.dart';
import '../globals.dart';

List<double> systolicPressure = <double>[];
List<double> dyastolicPressure = <double>[];
List<double> heartRate = <double>[];
List<double> saturation = <double>[];
List<DateTime> measurementDates = <DateTime>[];

Future fetchSystolic() async {
  systolicPressure = <double>[];
  measurementDates = <DateTime>[];
  var response = await http.get(
      Uri.parse(
          'https://students.measurify.org/v1/measurements?filter={"thing":"mario.rossi"}&limit=$valueMeasu'),
      headers: <String, String>{
        'Authorization': Globals.measurifyToken,
      });
  // print("data response body");
  // print(response.body);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    List samples = jsonResponse["docs"];
    // List temp = [];

    for (int i = 0; i < samples.length; i++) {
      // temp.add(samples[i]["samples"]);
      String value = convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['samples']
          .toString();
      value = value.substring((value.indexOf(": [") + 3), value.indexOf(","));
      value = value.replaceAll(RegExp(","), '');
      systolicPressure.add(double.parse(value));

      measurementDates.add(DateTime.parse(convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['startDate']
          .toString()));
      measurementDates[i] = DateTime.parse(DateFormat('yyyy-MM-dd').format(measurementDates[i]));
    }

    print("systolic Pressure");
    print(systolicPressure);

    return jsonResponse;
  } else if (response.statusCode == 401) {
    fetchSystolic();
  } else {
    return "error";
  }
}

Future fetchDyastolic() async {
  dyastolicPressure = <double>[];
  measurementDates = <DateTime>[];
  var response = await http.get(
      Uri.parse(
          'https://students.measurify.org/v1/measurements?filter={"thing":"mario.rossi"}&limit=$valueMeasu'),
      headers: <String, String>{
        'Authorization': Globals.measurifyToken,
      });
  // print("data response body");
  // print(response.body);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    List samples = jsonResponse["docs"];

    for (int i = 0; i < samples.length; i++) {
      String value = convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['samples']
          .toString();
      value = value.substring((value.indexOf(",") + 1), value.lastIndexOf(","));
      value = value.substring(value.indexOf(" "), value.indexOf(","));
      value = value.replaceAll(RegExp(","), '');
      dyastolicPressure.add(double.parse(value));
      measurementDates.add(DateTime.parse(convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['startDate']
          .toString()));
     
    }

    print("Dyastolic Pressure");
    print(dyastolicPressure);

    return jsonResponse;
  } else if (response.statusCode == 401) {
    fetchDyastolic();
  } else {
    return "error";
  }
}

Future fetchHeartRate() async {
  heartRate = <double>[];
  measurementDates = <DateTime>[];
  var response = await http.get(
      Uri.parse(
          'https://students.measurify.org/v1/measurements?filter={"thing":"mario.rossi"}&limit=$valueMeasu'),
      headers: <String, String>{
        'Authorization': Globals.measurifyToken,
      });
  // print("data response body");
  // print(response.body);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    List samples = jsonResponse["docs"];

    for (int i = 0; i < samples.length; i++) {
      String value = convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['samples']
          .toString();
      value = value.substring((value.indexOf(",") + 1), value.lastIndexOf(","));
      value = value.substring(value.lastIndexOf(","));
      value = value.replaceAll(RegExp(","), '');
      heartRate.add(double.parse(value));
      measurementDates.add(DateTime.parse(convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['startDate']
          .toString()));
    }

    print("heart Rate");
    print(heartRate);

    return jsonResponse;
  } else if (response.statusCode == 401) {
    fetchHeartRate();
  } else {
    return "error";
  }
}

Future fetchSaturation() async {
  saturation = <double>[];
  measurementDates = <DateTime>[];
  var response = await http.get(
      Uri.parse(
          'https://students.measurify.org/v1/measurements?filter={"thing":"mario.rossi"}&limit=$valueMeasu'),
      headers: <String, String>{
        'Authorization': Globals.measurifyToken,
      });
  // print("data response body");
  // print(response.body);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    List samples = jsonResponse["docs"];

    for (int i = 0; i < samples.length; i++) {
      String value = convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['samples']
          .toString();
      value = value.substring(value.lastIndexOf(",") + 1);
      value = value.replaceAll(RegExp("]}]"), '');
      saturation.add(double.parse(value));
      measurementDates.add(DateTime.parse(convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['startDate']
          .toString()));

    }

    print("Saturation");
    print(saturation);

    return jsonResponse;
  } else if (response.statusCode == 401) {
    fetchSaturation();
  } else {
    return "error";
  }
}
