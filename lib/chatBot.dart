import 'package:bubble/bubble.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:boo/menu.dart';
import 'package:boo/messageList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBot extends StatefulWidget {
  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  late SharedPreferences preferences;
  late Map<DateTime, List<dynamic>> _events;
  late Map<DateTime, List<dynamic>> _messages;
  final messageController = TextEditingController();
  var messsages = <Map>[];

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

  getPreferencesMessages() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _messages = Map<DateTime, List<dynamic>>.from(
          decode(json.decode(preferences.getString("messages") ?? "{}")));
    });
  }

  void reply(query) async {
    AuthGoogle authentication =
        await AuthGoogle(fileJson: "assets/service.json").build();
    Dialogflow bot =
        Dialogflow(authGoogle: authentication, language: Language.english);
    AIResponse aiResponse = await bot.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "user": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });

      if (_messages[DateTime.now()] != null) {
        _messages[DateTime.now()]!.add("0 " +
            aiResponse.getListMessage()[0]["text"]["text"][0].toString());
      } else {
        _messages[DateTime.now()] = [
          "0 " + aiResponse.getListMessage()[0]["text"]["text"][0].toString()
        ];
      }
      preferences.setString("messages", json.encode(encode(_messages)));
    });
  }

  @override
  void initState() {
    super.initState();
    _messages = {};
    getPreferencesMessages();
  }

  @override
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
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MessageList()));
              },
              child: Icon(
                Icons.search,
                size: 26.0,
              ),
            ),
          ),
        ],
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
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: messsages[index]["user"] == 1
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      messsages[index]["user"] == 0
                          ? Container(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 189, 170, 206),
                                backgroundImage: AssetImage("assets/boo.png"),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Bubble(
                            radius: Radius.circular(15.0),
                            color: messsages[index]["user"] == 0
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
                                      messsages[index]["message"].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                                ],
                              ),
                            )),
                      ),
                      messsages[index]["user"] == 1
                          ? Container(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/smiley.jpg"),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
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
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Say something...",
                      hintStyle: TextStyle(color: Colors.black26),
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
                      if (messageController.text.isEmpty) {
                        print("empty message");
                      } else if (messageController.text.toLowerCase() ==
                          "tell me my events for today") {
                        setState(() {
                          messsages.insert(0,
                              {"user": 1, "message": messageController.text});

                          if (_messages[DateTime.now()] != null) {
                            _messages[DateTime.now()]!
                                .add("1 " + messageController.text);
                          } else {
                            _messages[DateTime.now()] = [
                              "1 " + messageController.text
                            ];
                          }
                          preferences.setString(
                              "messages", json.encode(encode(_messages)));
                        });

                        messageController.clear();
                        DateTime now = DateTime.now();
                        String currentDate =
                            now.toString().split(' ')[0] + ' 12:00:00.000Z';
                        _events = Map<DateTime, List<dynamic>>.from(decode(json
                            .decode(preferences.getString("events") ?? "{}")));
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
                            "user": 0,
                            "message": message,
                          });

                          if (_messages[DateTime.now()] != null) {
                            _messages[DateTime.now()]!.add("0 " + message);
                          } else {
                            _messages[DateTime.now()] = ["0 " + message];
                          }
                          preferences.setString(
                              "messages", json.encode(encode(_messages)));
                        });
                        print("ok");
                      } else if (messageController.text.toLowerCase() ==
                          "tell me my events for tomorrow") {
                        setState(() {
                          messsages.insert(0,
                              {"user": 1, "message": messageController.text});

                          if (_messages[DateTime.now()] != null) {
                            _messages[DateTime.now()]!
                                .add("0 " + messageController.text);
                          } else {
                            _messages[DateTime.now()] = [
                              "0 " + messageController.text
                            ];
                          }
                          preferences.setString(
                              "messages", json.encode(encode(_messages)));
                        });
                        messageController.clear();
                        DateTime tomorrow =
                            DateTime.now().add(const Duration(days: 1));
                        String currentDate = tomorrow.toString().split(' ')[0] +
                            ' 12:00:00.000Z';
                        _events = Map<DateTime, List<dynamic>>.from(decode(json
                            .decode(preferences.getString("events") ?? "{}")));
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
                            "user": 0,
                            "message": message,
                          });

                          if (_messages[DateTime.now()] != null) {
                            _messages[DateTime.now()]!.add("0 " + message);
                          } else {
                            _messages[DateTime.now()] = ["0 " + message];
                          }
                          preferences.setString(
                              "messages", json.encode(encode(_messages)));
                        });
                        print("ok");
                      } else {
                        setState(() {
                          messsages.insert(0,
                              {"user": 1, "message": messageController.text});

                          if (_messages[DateTime.now()] != null) {
                            _messages[DateTime.now()]!
                                .add("1 " + messageController.text);
                          } else {
                            _messages[DateTime.now()] = [
                              "1 " + messageController.text
                            ];
                          }
                          preferences.setString(
                              "messages", json.encode(encode(_messages)));
                        });
                        reply(messageController.text);
                        messageController.clear();
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
}
