import 'package:flutter/material.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/search_page.dart';
import 'package:flutter_demo/actor_pages/user_body_page.dart';
import 'package:flutter_demo/actor_pages/users_list_page.dart';
import 'package:flutter_demo/actor_pages/items_list_page.dart';



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
  int _currentIndex = 3;


  List<Widget> pages =  [
    UsersListPage(),
    ItemsListPage(),
    Text("SCAN ITEMS FOR USER", style: _textStyle),
    UserBodyPage(),  
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
        body:IndexedStack(
            index: _currentIndex,
            children: pages,
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
              selectedIcon: Icon(Icons.ballot),
              icon: Icon(Icons.ballot_outlined),
              label: 'Accounts',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.assignment),
              icon: Icon(Icons.assignment_outlined),
              label: 'Items',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.connect_without_contact),
              icon: Icon(Icons.connect_without_contact_outlined),
              label: 'Help User',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.contactless),
              icon: Icon(Icons.contactless_outlined),
              label: 'Play User',
            ),
            
          ],
        ),

    );
  }
}