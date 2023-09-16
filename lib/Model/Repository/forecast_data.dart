import 'package:http/http.dart' as http;
import 'package:http/http.dart';

getForecastData({String? latitude, String? longitude, String? location}) async {
  const String apiKey = 'af04a30d1c4040ae92c60358232707';
  const String baseUrl = 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=';
  Response response;
  late String query;
  if (latitude != null && longitude != null) {
    query = '$latitude,$longitude&days=10&aqi=no&alerts=no';
    response = await http.get(Uri.parse(baseUrl + query));
  } else if (location != null && location.isNotEmpty) {
    query = '$location&days=10&aqi=no&alerts=no';
    response = await http.get(Uri.parse(baseUrl + query));
  } else {
    response = await http.get(Uri.parse('${baseUrl}auto:ip&days=10&aqi=no&alerts=no'));
  }
  return response;
}