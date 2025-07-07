
class Weather {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final String weatherCode;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['data']['values']['temperature']?.toDouble() ?? 0.0,
      humidity: json['data']['values']['humidity']?.toDouble() ?? 0.0,
      windSpeed: json['data']['values']['windSpeed']?.toDouble() ?? 0.0,
      weatherCode: json['data']['values']['weatherCode']?.toString() ?? '',
    );
  }
}