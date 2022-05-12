import 'package:flutter/material.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/search_page.dart';

  const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2, 
  fontStyle: FontStyle.italic,
);

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  var userInput = 0;
  var userFeedback = '';
  var userTask = '';
  int _currentIndex = 0;


  List<Widget> pages =  [
    Text("MODIFY USERS", style: _textStyle),
    Text("ADD/REMOVE ITEMS", style: _textStyle),
    Text("SCAN ITEMS FOR USER", style: _textStyle),
    //Text("PERFORM USER OPERATION", style: _textStyle),
        SingleChildScrollView(
          child: Column(
            children: [
              //Icon
              GestureDetector(
                //onTap: changeUserTask,
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
                'This is not working',//userFeedback,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: secondFontSize),
              ),
            ],
          ),
        ),
  ];

  

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
          child: pages[_currentIndex],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (int newIndex) {
            setState((){
              _currentIndex = newIndex;
            });
          }, 
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.ballot ),
              icon: Icon(Icons.ballot_outlined),
              label: 'Users',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.assignment),
              icon: Icon(Icons.assignment_outlined),
              label: 'Add/Remove',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.connect_without_contact),
              icon: Icon(Icons.connect_without_contact_outlined),
              label: 'Assign Item',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.contactless),
              icon: Icon(Icons.contactless_outlined),
              label: 'Borrow/Return',
            ),
            
          ],
        ),

    );
  }
}