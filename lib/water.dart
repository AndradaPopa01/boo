import 'package:flutter/material.dart';
import 'package:boo/drawerMenu.dart';

class Water extends StatefulWidget {
  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  @override
  bool isVisible = true;
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
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
                counter == 0
                    ? 'assets/glass_1.png'
                    : counter == 1
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
                    counter++;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
