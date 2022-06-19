import 'package:bubble/bubble.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:boo/drawerMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  late SharedPreferences prefs;
  late Map<DateTime, List<dynamic>> _events;
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/service.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });

    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  final messageInsert = TextEditingController();
  var messsages = <Map>[];

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        /*title: const Text(
          "Chat bot",
        ),*/
        title: Image.asset(
          'assets/Logo.png',
          fit: BoxFit.fitWidth,
          height: 40,
        ),
        backgroundColor: Color.fromARGB(255, 174, 136, 207),
      ),
      body: Container(
        color: Color.fromARGB(255, 189, 170, 206),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                "Today, ${DateFormat("Hm").format(DateTime.now())}",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 5.0,
              color: Color.fromARGB(255, 174, 136, 207),
            ),
            Container(
              child: ListTile(
                title: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageInsert,
                    decoration: InputDecoration(
                      hintText: "Enter a message...",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (value) {},
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30.0,
                      color: Color.fromARGB(255, 174, 136, 207),
                    ),
                    onPressed: () {
                      if (messageInsert.text.isEmpty) {
                        print("empty message");
                      } else if (messageInsert.text.toLowerCase() ==
                          "tell me my events for today") {
                        setState(() {
                          messsages.insert(
                              0, {"data": 1, "message": messageInsert.text});
                        });
                        messageInsert.clear();
                        DateTime now = DateTime.now();
                        String currentDate =
                            now.toString().split(' ')[0] + ' 12:00:00.000Z';
                        _events = Map<DateTime, List<dynamic>>.from(decodeMap(
                            json.decode(prefs.getString("events") ?? "{}")));
                        String message = 'You have the following events: ';
                        if (_events[DateTime.parse(currentDate)] != null &&
                            _events[DateTime.parse(currentDate)]!.isNotEmpty) {
                          for (var event
                              in _events[DateTime.parse(currentDate)]!) {
                            message += event + ' ';
                          }
                        } else {
                          message = 'You do not have any events.';
                        }

                        setState(() {
                          messsages.insert(0, {
                            "data": 0,
                            "message": message,
                          });
                        });
                        print("ok");
                      } else if (messageInsert.text.toLowerCase() ==
                          "tell me my events for tomorrow") {
                        setState(() {
                          messsages.insert(
                              0, {"data": 1, "message": messageInsert.text});
                        });
                        messageInsert.clear();
                        DateTime tomorrow =
                            DateTime.now().add(const Duration(days: 1));
                        String currentDate = tomorrow.toString().split(' ')[0] +
                            ' 12:00:00.000Z';
                        _events = Map<DateTime, List<dynamic>>.from(decodeMap(
                            json.decode(prefs.getString("events") ?? "{}")));
                        String message = 'You have the following events: ';
                        if (_events[DateTime.parse(currentDate)] != null &&
                            _events[DateTime.parse(currentDate)]!.isNotEmpty) {
                          for (var event
                              in _events[DateTime.parse(currentDate)]!) {
                            message += event + ' ';
                          }
                        } else {
                          message = 'You do not have any events.';
                        }

                        setState(() {
                          messsages.insert(0, {
                            "data": 0,
                            "message": message,
                          });
                        });
                        print("ok");
                      } else {
                        setState(() {
                          messsages.insert(
                              0, {"data": 1, "message": messageInsert.text});
                        });
                        response(messageInsert.text);
                        messageInsert.clear();
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    }),
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 189, 170, 206),
                    backgroundImage: AssetImage("assets/boo.png"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
                radius: Radius.circular(15.0),
                color: data == 0
                    ? Color.fromARGB(255, 115, 171, 235)
                    : Color.fromARGB(255, 203, 192, 110),
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/smiley.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
