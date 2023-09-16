import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:weatherapp/Model/Class/forecast.dart';
import '../Model/Repository/forecast_data.dart';

Stream<MyForecast> fetchForecastResult({String? longitude, String? latitude, String? location}) async* {
  try {
    Response response = await getForecastData(
      latitude: latitude,
      longitude: longitude,
      location: location,
    );
    if (response.statusCode == 200) {
      yield MyForecast.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }

  StreamController<MyForecast> forecastController = StreamController<MyForecast>();
  Timer.periodic(const Duration(minutes: 5), (_) async {
    try {
      Response response = await getForecastData(
        latitude: longitude,
        longitude: latitude,
        location: location,
      );
      if (response.statusCode == 200) {
        forecastController.add(MyForecast.fromJson(jsonDecode(response.body)));
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      forecastController.addError(Exception('Failed to fetch data: $e'));
    }
  });
  yield* forecastController.stream;
}
