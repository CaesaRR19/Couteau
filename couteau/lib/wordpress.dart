import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class WordPress extends StatefulWidget {
  const WordPress({Key? key}) : super(key: key);

  @override
  WordPressState createState() => WordPressState();
}

class WordPressState extends State<WordPress> {
  bool _isLoading = false;
  List<Map<String, String>> _news = [];

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  Future<void> _getNews() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://wakamiguatemala.com/wp-json/wp/v2/posts?per_page=3'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = jsonDecode(response.body);
        List<Map<String, String>> news = [];
        for (var item in data) {
          news.add({
            'title': item['title']['rendered'],
            'excerpt': item['excerpt']['rendered'],
            'link': item['link']
          });
        }
        setState(() {
          _news = news;
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
        title: const Text('Últimas Noticias'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _news.map((newsItem) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/Wakami.png',
                                  width: 417, height: 75, fit: BoxFit.cover),
                              const SizedBox(height: 20),
                              Text(
                                newsItem['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${newsItem['excerpt']!.substring(3, newsItem['excerpt']!.length - 12)}...',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (newsItem['link'] != null) {
                                    launch(newsItem['link']!);
                                  }
                                },
                                child: const Text('Leer Más'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
