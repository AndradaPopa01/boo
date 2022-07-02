import 'package:boo/calendar.dart';
import 'package:boo/main.dart';
import 'package:flutter/material.dart';
import 'package:boo/chatBot.dart';
import 'package:boo/water.dart';
import 'package:boo/wheel.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromARGB(255, 174, 136, 207),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.white),
                    title: Text('Home', style: TextStyle(color: Colors.white)),
                    hoverColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.chat, color: Colors.white),
                    title: Text('Chat', style: TextStyle(color: Colors.white)),
                    hoverColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatBot(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: Colors.white),
                    title:
                        Text('Calendar', style: TextStyle(color: Colors.white)),
                    hoverColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Calendar(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.water_drop, color: Colors.white),
                    title: Text('Drink some water',
                        style: TextStyle(color: Colors.white)),
                    hoverColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Water(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.circle_rounded, color: Colors.white),
                    title: Text('Self-care wheel',
                        style: TextStyle(color: Colors.white)),
                    hoverColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Wheel(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
