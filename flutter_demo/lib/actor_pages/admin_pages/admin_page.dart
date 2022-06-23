import 'package:flutter/material.dart';
import 'package:flutter_demo/authentication_pages/login_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/search_page.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';

import 'package:flutter_demo/actor_pages/user_pages/user_body_page.dart';

import 'package:flutter_demo/actor_pages/customer_pages/assist_user_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/add_item_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/users_list_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/items_list_page.dart';

class AdminPage extends StatefulWidget {
  Account currentAccount;
  int currentIndex = 3;
  AdminPage({required this.currentAccount, required this.currentIndex});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var userInput = 0;
  var userFeedback = '';
  var userTask = '';

  List<Widget> pages = [];

  Future signOut() async {
    //Shown in debug console
    debugPrint("Signed out " + widget.currentAccount.accountName);
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
      MaterialPageRoute(
          builder: (context) => AddItemPage(
                doAddItem: true,
                currentAccount: widget.currentAccount,
                item: createDefaultItem(),
              )),
    );
  }

  Future _addUser() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegisterPage(true, "", 0, true, widget.currentAccount)),
    );
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      UsersListPage(currentAccount: widget.currentAccount),
      ItemsListPage(currentAccount: widget.currentAccount),
      AssistUserPage(currentAccount: widget.currentAccount),
      UserBodyPage(currentAccount: widget.currentAccount),
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
        index: widget.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.currentIndex,
        onDestinationSelected: (int newIndex) {
          setState(() {
            widget.currentIndex = newIndex;
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
        visible: widget.currentIndex == 1 || widget.currentIndex == 0,
        child: FloatingActionButton(
          backgroundColor: Colors.orange[400],
          onPressed: widget.currentIndex == 1 ? _addItem : _addUser,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
