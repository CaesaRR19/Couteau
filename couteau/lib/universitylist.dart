import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UniversityList extends StatefulWidget {
  const UniversityList({Key? key}) : super(key: key);

  @override
  UniversityListState createState() => UniversityListState();
}

class UniversityListState extends State<UniversityList> {
  final TextEditingController _countryController = TextEditingController();
  List<Map<String, dynamic>> _universities = [];
  bool _isLoading = false;

  Future<void> _getUniversities() async {
    setState(() {
      _isLoading = true;
    });

    String country = _countryController.text.trim().toLowerCase();
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=$country'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> universitiesList = [];
        for (var uni in data) {
          universitiesList.add({
            'name': uni['name'],
            'web_pages': uni['web_pages'].isNotEmpty ? uni['web_pages'][0] : '',
            'domains': uni['domains'] != null ? uni['domains'][0] : ''
          });
        }
        setState(() {
          _universities = universitiesList;
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

  Widget _buildUniversityContainer(Map<String, dynamic> university) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Nombre: ${university['name']}',
            style: const TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Página web: ${university['web_pages']}',
            style: const TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Dominio: ${university['domains']}',
            style: const TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades por País'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el nombre del país en inglés',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getUniversities,
                child: const Text('Buscar Universidades'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : _universities.isNotEmpty
                      ? Column(
                          children: [
                            for (var uni in _universities)
                              _buildUniversityContainer(uni),
                          ],
                        )
                      : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
