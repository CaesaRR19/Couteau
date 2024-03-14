import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgePredictor extends StatefulWidget {
  const AgePredictor({Key? key}) : super(key: key);

  @override
  AgePredictorState createState() => AgePredictorState();
}

class AgePredictorState extends State<AgePredictor> {
  final TextEditingController _nameController = TextEditingController();
  String _age = "";
  bool _isLoading = false;
  String _imagePath = '';

  Future<void> _getAge() async {
    setState(() {
      _isLoading = true;
    });

    String name = _nameController.text.trim().toLowerCase();
    final response =
        await http.get(Uri.parse('https://api.agify.io/?name=$name'));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _age = data['age'].toString();
          _setImagePath();
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

  void _setImagePath() {
    int age = int.tryParse(_age) ?? 0;

    if (age < 21) {
      _imagePath = 'assets/joven.jpg';
    } else if (age >= 22 && age <= 50) {
      _imagePath = 'assets/adulto.jpg';
    } else {
      _imagePath = 'assets/anciano.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción de edad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingrese un nombre',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getAge,
              child: const Text('Predecir edad'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _age.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(children: <Widget>[
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(_imagePath),
                            ),
                            const SizedBox(height: 20),
                            Text('Edad: $_age años',
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
