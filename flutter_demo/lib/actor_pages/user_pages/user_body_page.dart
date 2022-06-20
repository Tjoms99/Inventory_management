import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class UserBodyPage extends StatefulWidget {
  const UserBodyPage({Key? key}) : super(key: key);

  @override
  State<UserBodyPage> createState() => _UserBodyPageState();
}

class _UserBodyPageState extends State<UserBodyPage> {
  var userInput = 0;
  var userFeedback = '';
  var userTask = '';
  var info;

  //Should update the database when a user scans an item
  Future changeUserTask() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      print("rfid not working");
      return;
    } else {
      print("rfid working");
      var tag = await FlutterNfcKit.poll();
      info = jsonEncode(tag);
      info = jsonDecode(info);
    }

    print(info['id']);

    setState(() {
      userTask = userTask.contains('BORROWED') ? 'RETURNED' : 'BORROWED';
      userFeedback =
          'You have ' + userTask + ' this item with id: ' + '${info['id']}';
    });

    print(userFeedback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Icon
              GestureDetector(
                onTap: changeUserTask,
                child: const ImageIcon(
                  AssetImage("assets/images/rfid_transparent.png"),
                  color: Color.fromARGB(255, 37, 174, 53),
                  size: 100,
                ),
              ),
              //Hello
              const Text(
                'Scan the item RFID tag',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: secondFontSize),
              ),
              const SizedBox(height: thirdBoxHeight),
              const Text('The system knows what you want to do!'),

              const SizedBox(height: firstBoxHeight * 3),

              Text(
                userFeedback,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: secondFontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
