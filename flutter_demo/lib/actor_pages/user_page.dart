import 'package:flutter/material.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/search_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  var userInput = 0;
  var userFeedback = '';
  var userTask = '';


  Future signOut() async {
    //Shown in debug console
    print("Signed out user");
    Navigator.pop(context);
  }

  Future search() async {
    showSearch(
      context: context,
      delegate: MySearchDelegate(),
    );
  }

  //Should update the database when a user scans an item
  Future changeUserTask() async {
    print('RFID detected');

    setState(() {
      userTask = userTask.contains('BORROWED') ? 'RETURNED' : 'BORROWED';
      userFeedback = 'You have ' + userTask + ' this item';
    });

    print(userFeedback);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
          backgroundColor: secondaryBackgroundColor,
          leading: IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
          actions: [
            IconButton(
              onPressed: search,
              icon: const Icon(Icons.search),
            ),
          ]),
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
