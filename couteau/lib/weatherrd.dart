import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherRD extends StatefulWidget {
  const WeatherRD({super.key});

  @override
  WeatherRDState createState() => WeatherRDState();
}

class WeatherRDState extends State<WeatherRD> {
  bool _isLoading = false;
  String _weather = '';

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  Future<void> _getWeather() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=18.735693&lon=-70.162651&appid=febb21687a6b39ceca3afa8ecb085a14&units=metric&lang=es'));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _weather = data['weather'][0]['description'];
        });
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Error: ${response.statusCode}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima RD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : _weather.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(children: <Widget>[
                            Text('Clima: $_weather',
                                style: const TextStyle(
                                  fontSize: 16,
                                ))
                          ]),
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
