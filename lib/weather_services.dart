import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_modal.dart';

class WeatherService {
  static const String _apiKey = 'HEbfYKPTp6fMORnBr1BwOfGOQXjop667';
  static const String _baseUrl =
      'https://api.tomorrow.io/v4/weather/realtime?location=erode&apikey=$_apiKey';

  static Future<Weather> fetchWeather() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}