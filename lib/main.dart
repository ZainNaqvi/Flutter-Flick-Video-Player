import 'package:flutter_application_2/animation_player/animation_player.dart';
import 'package:flutter_application_2/custom_orientation_player/custom_orientation_player.dart';
import 'package:flutter_application_2/feed_player/feed_player.dart';
import 'package:flutter_application_2/short_video_player/homepage/short_video_homepage.dart';
import 'package:flutter_application_2/web_video_player/web_video_player.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import './landscape_player/landscape_player.dart';

import 'default_player/default_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flick player example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.red.withOpacity(0.2),
        body: SafeArea(child: Examples()),
      ),
    );
  }
}

class Examples extends StatefulWidget {
  const Examples({Key? key}) : super(key: key);

  @override
  _ExamplesState createState() => _ExamplesState();
}

class _ExamplesState extends State<Examples> {
  final List<Map<String, dynamic>> samples = [
    {'name': 'Default player', 'widget': DefaultPlayer()},
    {'name': 'Animation player', 'widget': Expanded(child: AnimationPlayer())},
    {'name': 'Feed player', 'widget': Expanded(child: FeedPlayer())},
    {'name': 'Custom orientation player', 'widget': CustomOrientationPlayer()},
    {'name': 'Landscape player', 'widget': LandscapePlayer()},
    {
      'name': 'Short Video Player',
      'widget': const Expanded(child: ShortVideoHomePage())
    },
  ];

  int selectedIndex = 0;

  changeSample(int index) {
    if (samples[index]['widget'] is LandscapePlayer) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LandscapePlayer(),
      ));
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMobileView();
  }

  Widget _buildMobileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: samples[selectedIndex]['widget'],
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.09),
          ),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: samples.asMap().keys.map((index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      changeSample(index);
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          samples.asMap()[index]?['name'],
                          style: TextStyle(
                            color: index == selectedIndex
                                ? Colors.white
                                : const Color.fromRGBO(173, 176, 183, 1),
                            fontWeight:
                                index == selectedIndex ? FontWeight.bold : null,
                            fontSize: index == selectedIndex ? 16 : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),
      ],
    );
  }
}
