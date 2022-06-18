import 'package:flutter/material.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/search_page.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';

import 'package:flutter_demo/actor_pages/user_pages/user_body_page.dart';

import 'package:flutter_demo/actor_pages/customer_pages/assist_user_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/add_item_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/users_list_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/items_list_page.dart';

import '../../authentication_pages/login_page.dart';
import '../../classes/account.dart';

class CustomerPage extends StatefulWidget {
  Account currentAccount;
  CustomerPage({required this.currentAccount});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  var userInput = 0;
  var userFeedback = '';
  var userTask = '';
  int _currentIndex = 3;
  List<Widget> pages = [];

  Future signOut() async {
    //Shown in debug console
    print("Signed out user");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future search() async {
    showSearch(
      context: context,
      delegate: MySearchDelegate(),
    );
  }

  Future _addItem() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemPage(true)),
    );
  }

  Future _addUser() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegisterPage(true, "", '0', true, widget.currentAccount)),
    );
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      UsersListPage(widget.currentAccount),
      const ItemsListPage(),
      const AssistUserPage(),
      const UserBodyPage(),
    ];

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
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int newIndex) {
          setState(() {
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
            label: 'User',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: _currentIndex == 1 || _currentIndex == 0,
        child: FloatingActionButton(
          backgroundColor: Colors.orange[400],
          onPressed: _currentIndex == 1 ? _addItem : _addUser,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
