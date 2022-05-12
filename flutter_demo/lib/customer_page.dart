import 'package:flutter/material.dart';

import 'constants.dart';
import 'search_page.dart';

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
    Text("PERFORM USER OPERATION", style: _textStyle),
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
              label: 'Items',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.backpack),
              icon: Icon(Icons.backpack_outlined),
              label: 'Assign Item',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.inventory),
              icon: Icon(Icons.inventory_outlined),
              label: 'Task',
            ),
            
          ],
        ),

    );
  }
}