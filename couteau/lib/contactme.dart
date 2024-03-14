import 'package:flutter/material.dart';

class ContactMe extends StatelessWidget {
  const ContactMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  radius: 75,
                  backgroundImage:
                      NetworkImage('https://i.imgur.com/7bw7xUC.jpg')),
              SizedBox(height: 20),
              Text('César Omar Ramos Nolasco',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
              SizedBox(height: 10),
              Text('cesarcorn19@gmail.com', style: TextStyle(fontSize: 15)),
            ],
          ),
        )));
  }
}
