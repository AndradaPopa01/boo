import 'package:flutter/material.dart';
import 'package:boo/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Water extends StatefulWidget {
  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  @override
  bool isVisible = true;
  late int counter_initial_text;
  late int counter_glass_add;
  late int counter_glass_read;
  late int counter_picture;
  late String count;
  late DateTime now;
  late String currentDate;
  late SharedPreferences preferences;
  late Map<DateTime, List<dynamic>> _water;
  late Map<DateTime, List<dynamic>> _water2;

  Map<DateTime, dynamic> decode(Map<String, dynamic> map1) {
    Map<DateTime, dynamic> map2 = {};
    map1.forEach((key, value) {
      map2[DateTime.parse(key)] = map1[key];
    });
    return map2;
  }

  Map<String, dynamic> encode(Map<DateTime, dynamic> map1) {
    Map<String, dynamic> map2 = {};
    map1.forEach((key, value) {
      map2[key.toString()] = map1[key];
    });
    return map2;
  }

  getPreferencesWater() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _water = Map<DateTime, List<dynamic>>.from(
          decode(json.decode(preferences.getString("water") ?? "{}")));
    });
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    currentDate = now.toString().split(' ')[0] + ' 12:00:00.000Z';
    _water = {};
    _water2 = {};
    counter_initial_text = 0;
    counter_glass_add = 0;
    counter_glass_read = 0;
    counter_picture = 0;
    count = "";
    getPreferencesWater();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Image.asset(
          'assets/Logo.png',
          fit: BoxFit.fitWidth,
          height: 40,
        ),
        backgroundColor: Color.fromARGB(255, 174, 136, 207),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                counter_picture == 0
                    ? 'assets/glass_1.png'
                    : counter_picture == 1
                        ? 'assets/glass_2.png'
                        : 'assets/glass_3.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: MaterialButton(
                color: Color.fromARGB(255, 174, 136, 207),
                child: Text('Drink',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                minWidth: 200,
                height: 70,
                onPressed: () {
                  setState(() {
                    if (Map<DateTime, List<dynamic>>.from(decode(json.decode(
                                preferences.getString("water") ??
                                    "{}")))[DateTime.parse(currentDate)] !=
                            null &&
                        Map<DateTime, List<dynamic>>.from(decode(json.decode(
                                preferences.getString("water") ??
                                    "{}")))[DateTime.parse(currentDate)]!
                            .isNotEmpty) {
                      counter_glass_read = Map<DateTime, List<dynamic>>.from(
                          decode(json.decode(preferences.getString("water") ??
                              "{}")))[DateTime.parse(currentDate)]![0];
                    } else {
                      counter_glass_read = 0;
                    }
                  });

                  counter_initial_text++;
                  if (counter_picture == 1) counter_glass_read++;
                  if (_water[DateTime.parse(currentDate)] != null) {
                    _water[DateTime.parse(currentDate)]![0] =
                        counter_glass_read;
                  } else {
                    _water[DateTime.parse(currentDate)] = [counter_glass_read];
                  }
                  if (counter_picture < 2)
                    counter_picture++;
                  else
                    counter_picture = 0;

                  preferences.setString("water", json.encode(encode(_water)));

                  setState(() {
                    _water2 = Map<DateTime, List<dynamic>>.from(decode(
                        json.decode(preferences.getString("water") ?? "{}")));
                    if (_water2[DateTime.parse(currentDate)] != null &&
                        _water2[DateTime.parse(currentDate)]!.isNotEmpty) {
                      counter_glass_add =
                          _water2[DateTime.parse(currentDate)]![0];
                    } else {
                      counter_glass_add = 0;
                    }
                  });
                },
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                child: Text(
                  counter_initial_text == 0
                      ? "Let's drink a glass of water."
                      : "You drank " +
                          (counter_glass_add).toString() +
                          " glasses of water today. Good job!",
                  maxLines: 15,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
