import 'package:flutter/material.dart';
import 'package:flutter_demo/authentication_pages/login_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_body_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/assist_user_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/add_item_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/users_list_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/items_list_page.dart';

///This is a page where a customer can navigate between 4 action pages.
class CustomerPage extends StatefulWidget {
  final Account currentAccount;
  int currentIndex;
  CustomerPage({required this.currentAccount, required this.currentIndex});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Widget> pages = [];

  ///Signs out [widget.currentAccount].
  Future _signOut() async {
    debugPrint("Signed out " + widget.currentAccount.accountName);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  ///Updates current widget.
  Future _update() async {
    setState(() {});
  }

  ///Goes to add [Item] page.
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

  ///Goes to add [Account] page.
  Future _addUser() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegisterPage(true, "", 0, true, widget.currentAccount)),
    );
  }

  ///Builds 4 pages.
  ///
  ///[Account] list, [Item] list, help [Account] and play [Account].
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
          title: Text(widget.currentAccount.accountName),

          //SIGN OUT.
          leading: IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),

          //UPDATE STATE.
          actions: [
            IconButton(
              onPressed: _update,
              icon: const Icon(Icons.update),
            ),
          ]),
      body: IndexedStack(
        index: widget.currentIndex,
        children: pages,
      ),

      //NAVIGATION BAR.
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

      //ACTION BUTTON.
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