import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:boo/menu.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late CalendarController _controller;
  late Map<DateTime, List<dynamic>> _events;
  late Map<DateTime, int> _moods;
  late Map<DateTime, int> _activities;
  late Map<DateTime, List<dynamic>> _water;
  late List<dynamic> _selectedEvents;
  late TextEditingController _eventController;
  late SharedPreferences preferences;
  late int dayIndexForActivity;
  List<String> activities = [
    "Take a walk",
    "Watch a movie",
    "Take a break",
    "Take a nap",
    "Read a book",
    "Grab a snack",
  ];

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _moods = {};
    _activities = {};
    _water = {};
    _selectedEvents = [];
    getPreferencesEvents();
    getPreferencesMoods();
    getPreferencesWheel();
    getPreferencesWater();
  }

  getPreferencesEvents() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decode(json.decode(preferences.getString("events") ?? "{}")));
    });
  }

  getPreferencesMoods() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _moods = Map<DateTime, int>.from(
          decode(json.decode(preferences.getString("moods") ?? "{}")));
    });
  }

  getPreferencesWheel() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _activities = Map<DateTime, int>.from(
          decode(json.decode(preferences.getString("wheel") ?? "{}")));
    });
  }

  getPreferencesWater() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _water = Map<DateTime, List<dynamic>>.from(
          decode(json.decode(preferences.getString("water") ?? "{}")));
    });
  }

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

  DateTime getDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  int getMoodCounter(DateTime date) {
    if (_moods.isNotEmpty) {
      for (MapEntry e in _moods.entries) {
        if (e.key.year == date.year &&
            e.key.month == date.month &&
            e.key.day == date.day) {
          if (e.value != null) {
            return e.value;
          } else {
            return 0;
          }
        }
      }
    } else {
      return 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    getPreferencesMoods();
    getPreferencesWheel();
    getPreferencesWater();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      drawer: Menu(),
      appBar: AppBar(
        title: Image.asset(
          'assets/Logo.png',
          fit: BoxFit.fitWidth,
          height: 40,
        ),
        backgroundColor: Color.fromARGB(255, 174, 136, 207),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 174, 136, 207),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Color.fromARGB(255, 115, 171, 235),
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events, holidays) {
                setState(() {
                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                dayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: getMoodCounter(date) == 1
                          ? Color.fromARGB(255, 244, 190, 190)
                          : getMoodCounter(date) == 2
                              ? Color.fromARGB(255, 254, 255, 196)
                              : getMoodCounter(date) == 3
                                  ? Color.fromARGB(255, 207, 255, 182)
                                  : Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                selectedDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 174, 136, 207),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                todayDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: getMoodCounter(date) == 1
                        ? Color.fromARGB(255, 248, 137, 137)
                        : getMoodCounter(date) == 2
                            ? Color.fromARGB(255, 255, 247, 103)
                            : getMoodCounter(date) == 3
                                ? Color.fromARGB(255, 164, 244, 122)
                                : Color.fromARGB(255, 162, 205, 232),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                outsideWeekendDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Color.fromARGB(255, 186, 186, 186)),
                  ),
                ),
                outsideDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Color.fromARGB(255, 186, 186, 186)),
                  ),
                ),
              ),
              calendarController: _controller,
            ),
            Column(
              children: <Widget>[
                Center(
                  child: Text(
                    _water[_controller.selectedDay] != null
                        ? _water[_controller.selectedDay]![0] != null
                            ? "Glasses of water: " +
                                _water[_controller.selectedDay]![0].toString()
                            : "Glasses of water: 0"
                        : "Glasses of water: 0",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        color: Color.fromARGB(255, 121, 163, 210),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                ),
                Center(
                  child: Text(
                    _controller.selectedDay != null
                        ? _activities[getDate(_controller.selectedDay)] != null
                            ? "Your self-care activity for the day: " +
                                activities[int.parse(_activities[
                                        getDate(_controller.selectedDay)]
                                    .toString())]
                            : "No self-care activity chosen"
                        : "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        color: Color.fromARGB(255, 192, 139, 230),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                ),
                ..._selectedEvents.map((event) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 20,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 238, 230, 242),
                            ),
                            child: Center(
                                child: Text(
                              event,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 174, 136, 207),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 174, 136, 207),
                            ),
                            onPressed: () async {
                              if (_events[_controller.selectedDay] != null) {
                                _events[_controller.selectedDay]!.remove(event);
                              }
                              preferences.setString(
                                  "events", json.encode(encode(_events)));
                              _eventController.clear();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 174, 136, 207),
        child: Icon(Icons.add),
        onPressed: _showDialog,
      ),
    );
  }

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              title: Text("Add Event"),
              content: TextFormField(
                cursorColor: Color.fromARGB(255, 174, 136, 207),
                controller: _eventController,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Color.fromARGB(255, 174, 136, 207),
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;
                    setState(() {
                      if (_events[_controller.selectedDay] != null) {
                        _events[_controller.selectedDay]!
                            .add(_eventController.text);
                      } else {
                        _events[_controller.selectedDay] = [
                          _eventController.text
                        ];
                      }
                      preferences.setString(
                          "events", json.encode(encode(_events)));
                      _eventController.clear();
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }
}
