import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boo/menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  static final String title = 'Home';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<Color> colorList = [
    Color.fromARGB(255, 248, 137, 137),
    Color.fromARGB(255, 255, 247, 103),
    Color.fromARGB(255, 164, 244, 122),
  ];
  var quotes = [
    "“Keep your face always toward the sunshine, and shadows will fall behind you.” - Walt Whitman",
    "“Success is not final, failure is not fatal: it is the courage to continue that counts.” - Winston Churchill",
    "“It is during our darkest moments that we must focus to see the light.” - Aristotle",
    "“Try to be a rainbow in someone’s cloud.” - Maya Angelou",
    "“Always laugh when you can, it is cheap medicine.” - Lord Byron",
    "“Today’s opportunities erase yesterday’s failures.” - Gene Brown",
    "“Out of the mountain of despair, a stone of hope.” - Martin Luther King, Jr.",
    "“You do not find the happy life. You make it.” - Camilla Eyring Kimball",
    "“Clouds come floating into my life, no longer to carry rain or usher storm, but to add color to my sunset sky.” - Rabindranath Tagore",
    "“Be who you are and say what you feel, because those who mind don’t matter and those who matter don’t mind.” -Bernard Baruch",
    "“Life isn’t finding shelter in the storm. It’s about learning to dance in the rain.” - Sherrilyn Kenyon",
    "“Failure is the condiment that gives success its flavor.” - Truman Capote",
    "“The world is full of magical things patiently waiting for our wits to grow sharper.” - Bertrand Russell"
  ];
  final _random = new Random();
  late SharedPreferences preferences;
  late Map<DateTime, int> _moods;

  Map<DateTime, dynamic> decode(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  Map<String, dynamic> encode(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  getPreferencesMoods() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _moods = Map<DateTime, int>.from(
          decode(json.decode(preferences.getString("moods") ?? "{}")));
    });
  }

  @override
  void initState() {
    _moods = {};
    getPreferencesMoods();
    super.initState();
  }

  _openLink() async {
    const link = 'https://www.la-psiholog.ro/';
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  Map<String, double> moodChartMap() {
    Map<String, double> m = {"Sad": 0, "In-between": 0, "Happy": 0};
    for (MapEntry e in _moods.entries) {
      if (e.key.month == DateTime.now().month) {
        if (e.value == 1) {
          if (m["Sad"] != null) {
            m["Sad"] = m["Sad"]! + 1;
          }
        } else if (e.value == 2) {
          if (m["In-between"] != null) {
            m["In-between"] = m["In-between"]! + 1;
          }
        } else if (e.value == 3) {
          if (m["Happy"] != null) {
            m["Happy"] = m["Happy"]! + 1;
          }
        }
      }
    }
    return m;
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
        body: Container(
          constraints: BoxConstraints.expand(),
          color: Color.fromARGB(255, 189, 170, 206),
          padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
          child: Column(
            children: [
              Text(
                quotes[_random.nextInt(quotes.length)],
                textAlign: TextAlign.center,
                maxLines: 15,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: MaterialButton(
                  color: Color.fromARGB(255, 174, 136, 207),
                  child: Text('Track your mood',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Open Sans',
                          fontSize: 20)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  minWidth: 250,
                  height: 70,
                  onPressed: _showDialog,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: MaterialButton(
                  color: Color.fromARGB(255, 174, 136, 207),
                  child: Text('Check your mood chart',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Open Sans',
                          fontSize: 20)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  minWidth: 250,
                  height: 70,
                  onPressed: _showDialog2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: MaterialButton(
                  color: Color.fromARGB(255, 174, 136, 207),
                  child: Text('Get proffesional help',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Open Sans',
                          fontSize: 20)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  minWidth: 250,
                  height: 70,
                  onPressed: _openLink,
                ),
              ),
            ],
          ),
        ),
      );

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color.fromARGB(255, 203, 184, 208),
              title: Text(
                "How are you feeling today? ",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Center(
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.faceFrown),
                    tooltip: 'Sad',
                    color: Color.fromARGB(255, 248, 137, 137),
                    onPressed: () {
                      setState(() {
                        DateTime now = new DateTime.now();
                        DateTime date =
                            new DateTime(now.year, now.month, now.day);

                        if (_moods[date] != null) {
                          _moods.update(date, (value) => 1);
                        } else {
                          _moods[date] = 1;
                        }
                        print(_moods);
                        preferences.setString(
                            "moods", json.encode(encode(_moods)));
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.faceMeh),
                    tooltip: 'Not too good, not too bad',
                    color: Color.fromARGB(255, 255, 247, 103),
                    onPressed: () {
                      setState(() {
                        DateTime now = new DateTime.now();
                        DateTime date =
                            new DateTime(now.year, now.month, now.day);
                        print(date);

                        if (_moods[date] != null) {
                          _moods.update(date, (value) => 2);
                        } else {
                          _moods[date] = 2;
                        }
                        print(_moods);
                        preferences.setString(
                            "moods", json.encode(encode(_moods)));
                        print(_moods);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.faceSmile),
                    tooltip: 'Happy',
                    color: Color.fromARGB(255, 164, 244, 122),
                    onPressed: () {
                      setState(() {
                        DateTime now = new DateTime.now();
                        DateTime date =
                            new DateTime(now.year, now.month, now.day);
                        print(date);

                        if (_moods[date] != null) {
                          _moods.update(date, (value) => 3);
                        } else {
                          _moods[date] = 3;
                        }

                        preferences.setString(
                            "moods", json.encode(encode(_moods)));
                        print(_moods);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ));
  }

  _showDialog2() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color.fromARGB(255, 203, 184, 208),
              title: Text(
                "Your mood chart for " + months[DateTime.now().month - 1],
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Center(
                    child: Container(
                  child: PieChart(
                    dataMap: moodChartMap(),
                    colorList: colorList,
                    chartType: ChartType.disc,
                    baseChartColor: Colors.grey[300]!,
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  ),
                )),
              ],
            ));
  }
}
