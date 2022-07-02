import 'dart:convert';
import 'dart:math';
import 'package:boo/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wheel extends StatefulWidget {
  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late SharedPreferences preferences;
  late Map<DateTime, int> _activities;
  int selected = 0;
  List<String> activities = [
    "Take a walk",
    "Watch a movie",
    "Take a break",
    "Take a nap",
    "Read a book",
    "Grab a snack",
  ];
  bool visibility = false;

  Map<String, dynamic> encode(Map<DateTime, dynamic> map1) {
    Map<String, dynamic> map2 = {};
    map1.forEach((key, value) {
      map2[key.toString()] = map1[key];
    });
    return map2;
  }

  Map<DateTime, dynamic> decode(Map<String, dynamic> map1) {
    Map<DateTime, dynamic> map2 = {};
    map1.forEach((key, value) {
      map2[DateTime.parse(key)] = map1[key];
    });
    return map2;
  }

  getPreferencesWheel() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _activities = Map<DateTime, int>.from(
          decode(json.decode(preferences.getString("wheel") ?? "{}")));
    });
  }

  @override
  void initState() {
    super.initState();
    _activities = {};
    getPreferencesWheel();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: Menu(),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 174, 136, 207),
          title: Image.asset(
            'assets/Logo.png',
            fit: BoxFit.fitWidth,
            height: 40,
          ),
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                height: 500,
                width: 350,
                child: FortuneWheel(
                  selected: selected,
                  animateFirst: false,
                  indicators: const <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment.topCenter,
                      child: TriangleIndicator(
                        color: Color.fromARGB(255, 59, 58, 58),
                      ),
                    ),
                  ],
                  onFling: () {
                    setState(() {
                      selected = Random().nextInt(4);
                      visibility = false;
                    });
                  },
                  items: [
                    for (int i = 0;
                        i < activities.length;
                        i++) ...<FortuneItem>{
                      FortuneItem(
                        child: Text(activities[i].toString(),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Open Sans',
                                fontSize: 16)),
                        style: i % 2 == 0
                            ? const FortuneItemStyle(
                                color: Color.fromARGB(255, 189, 170, 206),
                                borderColor: Color.fromARGB(255, 189, 170, 206),
                              )
                            : const FortuneItemStyle(
                                color: Color.fromARGB(255, 174, 136, 207),
                                borderColor: Color.fromARGB(255, 174, 136, 207),
                              ),
                      ),
                    },
                  ],
                  onAnimationEnd: () {
                    setState(() {
                      DateTime now = new DateTime.now();
                      DateTime date =
                          new DateTime(now.year, now.month, now.day);

                      if (_activities[date] != null) {
                        _activities.update(date, (value) => selected);
                      } else {
                        _activities[date] = selected;
                      }
                      print(_activities);
                      preferences.setString(
                          "wheel", json.encode(encode(_activities)));
                    });
                    visibility = true;
                  },
                ),
              ),
            ),
            Visibility(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  "Your self-care activity for today is: " +
                      activities[selected],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 174, 136, 207),
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      fontSize: 25),
                ),
              ),
              visible: visibility,
            )
          ],
        ),
      );
}
