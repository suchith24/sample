import 'package:flutter/material.dart';
import 'package:project/weather_modal.dart';
import 'package:project/weather_services.dart';
import 'package:project/user_list_page.dart';
import 'background_container.dart';
import 'package:project/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Weather> _weatherFuture;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService.fetchWeather();
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    try {
      _weatherFuture = WeatherService.fetchWeather();
      await _weatherFuture;
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erode Weather'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserListScreen()),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundContainer(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: FutureBuilder<Weather>(
            future: _weatherFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 60, color: Colors.white),
                      const SizedBox(height: 20),
                      const Text(
                        'Failed to load weather data',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _refreshData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final weather = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  children: [
                    WeatherCard(
                      title: 'Temperature',
                      value: '${weather.temperature} °C',
                      icon: Icons.thermostat,
                      color: Colors.orange,
                    ),
                    WeatherCard(
                      title: 'Humidity',
                      value: '${weather.humidity} %',
                      icon: Icons.water_drop,
                      color: Colors.blue,
                    ),
                    WeatherCard(
                      title: 'Wind Speed',
                      value: '${weather.windSpeed} m/s',
                      icon: Icons.air,
                      color: Colors.green,
                    ),
                    WeatherCard(
                      title: 'Conditions',
                      value: weather.weatherCode,
                      icon: Icons.cloud,
                      color: Colors.purple,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        child: _isRefreshing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.refresh),
      ),
    );
  }
}