import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GenderPredictor extends StatefulWidget {
  const GenderPredictor({super.key});

  @override
  GenderPredictorState createState() => GenderPredictorState();
}

class GenderPredictorState extends State<GenderPredictor> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = "";
  bool _isLoading = false;
  String _spgender = "";

  Future<void> _getGender() async {
    setState(() {
      _isLoading = true;
    });

    String name = _nameController.text.trim().toLowerCase();
    final response =
        await http.get(Uri.parse('https://api.genderize.io/?name=$name'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _gender = data['gender'];
        _spgender = _gender == 'male' ? 'Hombre' : 'Mujer';
      });
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
        title: const Text('Predicción de género'),
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
              onPressed: _getGender,
              child: const Text('Predecir género'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _gender.isNotEmpty
                    ? Container(
                        color: _gender == 'male' ? Colors.blue : Colors.pink,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Genero: $_spgender',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
