import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boo/drawerMenu.dart';

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
  var quotes = [
    "It is during our darkest moments that we must focus to see the light.",
    "Always laugh when you can, it is cheap medicine.",
    "Today’s opportunities erase yesterday’s failures.",
    "When life brings big winds of change that almost blow you over, close your eyes, hang on tight, and believe.",
    "When life puts you in a tough situation, don’t say 'Why me?', say 'Try me'.",
    "Be who you are and say what you feel, because those who mind don’t matter and those who matter don’t mind.",
    "Life isn’t finding shelter in the storm. It’s about learning to dance in the rain.",
    "It takes less time to do things right than to explain why you did it wrong.",
    "Failure is the condiment that gives success its flavor.",
    "The world is full of magical things patiently waiting for our wits to grow sharper."
  ];
  final _random = new Random();

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
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
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/chat_background.jpg"),
                fit: BoxFit.cover),
          ),
          padding: EdgeInsets.fromLTRB(110, 180, 10, 30),
          child: Text(
            quotes[_random.nextInt(quotes.length)],
            maxLines: 15,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 25),
          ),
        ),
      );
}
