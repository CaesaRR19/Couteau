import 'package:couteau/agepredictor.dart';
import 'package:couteau/genderpredictor.dart';
import 'package:couteau/universitylist.dart';
import 'package:couteau/weatherrd.dart';
import 'wordpress.dart';
import 'package:couteau/contactme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabsControl extends StatelessWidget {
  const TabsControl({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(tabs: [
            Tab(icon: FaIcon(FontAwesomeIcons.toolbox)),
            Tab(icon: FaIcon(FontAwesomeIcons.venusMars)),
            Tab(icon: FaIcon(FontAwesomeIcons.hashtag)),
            Tab(icon: FaIcon(FontAwesomeIcons.buildingColumns)),
            Tab(icon: FaIcon(FontAwesomeIcons.cloud)),
            Tab(icon: FaIcon(FontAwesomeIcons.wordpress)),
            Tab(icon: FaIcon(FontAwesomeIcons.addressCard)),
          ])),
          body: const TabBarView(children: [
            Center(child: FaIcon(FontAwesomeIcons.toolbox, size: 100)),
            GenderPredictor(),
            AgePredictor(),
            UniversityList(),
            WeatherRD(),
            WordPress(),
            ContactMe()

          ]),
        ));
  }
}
