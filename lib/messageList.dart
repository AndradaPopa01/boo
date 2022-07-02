import 'package:flutter/material.dart';
import 'package:boo/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:core';

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final controller = TextEditingController();
  late SharedPreferences preferences;
  late Map<DateTime, List<dynamic>> _messages;
  late List<String> messages;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Map<DateTime, dynamic> decode(Map<String, dynamic> map1) {
    Map<DateTime, dynamic> map2 = {};
    map1.forEach((key, value) {
      map2[DateTime.parse(key)] = map1[key];
    });
    return map2;
  }

  @override
  void initState() {
    super.initState();
    _messages = {};
    messages = [];

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      preferences = await SharedPreferences.getInstance();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            ListTile(
              title: Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Write the word you want to find...',
                  ),
                  cursorColor: Color.fromARGB(255, 174, 136, 207),
                  controller: controller,
                ),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 30.0,
                    color: Color.fromARGB(255, 174, 136, 207),
                  ),
                  onPressed: () {
                    setState(() {
                      _messages = Map<DateTime, List<dynamic>>.from(decode(json
                          .decode(preferences.getString("messages") ?? "{}")));
                      print(_messages);
                    });
                    messages.clear();
                    String parsed_message;
                    int counter = 0;
                    String message_without_id = "";
                    if (_messages.isNotEmpty) {
                      for (MapEntry e in _messages.entries) {
                        for (var message in e.value) {
                          if (message
                              .toLowerCase()
                              .contains(controller.text.toLowerCase())) {
                            counter++;
                            if (message != null && message.length >= 1)
                              message_without_id = message.substring(1);

                            if (message[0] == "0") {
                              parsed_message = "Boo: " +
                                  message_without_id +
                                  " at " +
                                  e.key.toString();
                            } else {
                              parsed_message = "Me: " +
                                  message_without_id +
                                  " at " +
                                  e.key.toString();
                            }

                            if (messages.isNotEmpty) {
                              messages.add(parsed_message);
                            } else {
                              messages = [parsed_message];
                            }
                          }
                        }
                      }
                    } else {
                      messages.clear();
                      messages = ["No messages found."];
                    }
                    if (counter == 0) {
                      messages.clear();
                      messages = ["No messages found."];
                    }
                  }),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 230, 242),
                      ),
                      child: Text(messages[index],
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 82, 85),
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Open Sans',
                              fontSize: 15)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
