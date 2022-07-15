import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/admin_pages/config_page.dart';
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
import 'package:flutter_demo/page_route.dart';

///This is a page where an admin can navigate between 4 action pages.
class AdminPage extends StatefulWidget {
  Account currentAccount;
  int currentIndex = 3;
  AdminPage({required this.currentAccount, required this.currentIndex});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Widget> pages = [];

  ///Signs out [widget.currentAccount].
  Future _signOut() async {
    debugPrint("Signed out " + widget.currentAccount.accountName);

    Navigator.of(context).push(PageRouter(
      child: const LoginPage(),
      direction: AxisDirection.up,
    ));
  }

  ///Updates current widget.
  void _update() {
    setState(() {});
  }

  ///Goes to add [Item] page.
  Future _addItem() async {
    Navigator.of(context).push(PageRouter(
      child: AddItemPage(
        doAddItem: true,
        currentAccount: widget.currentAccount,
        item: createDefaultItem(),
      ),
      direction: AxisDirection.down,
    ));
  }

  ///Goes to add [Account] page.
  Future _addUser() async {
    Navigator.of(context).push(PageRouter(
      child: RegisterPage(true, "", 0, true, widget.currentAccount),
      direction: AxisDirection.down,
    ));
  }

  ///Changes the page.
  void _gotoConfig() {
    Navigator.of(context).push(PageRouter(
      child: ConfigPage(
        currentAccount: widget.currentAccount,
        pageIndex: widget.currentIndex,
      ),
      direction: AxisDirection.down,
    ));
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
      UserBodyPage(
        currentAccount: widget.currentAccount,
        isCustomerHelping: false,
      ),
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
            backgroundColor: secondaryBackgroundColor,
            title: Text(widget.currentAccount.accountName),
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: mainGradient),
            ),

            //SIGN OUT.
            leading: IconButton(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
            ),

            //UPDATE STATE.
            actions: [
              IconButton(
                onPressed: _gotoConfig,
                icon: const Icon(Icons.settings),
              ),
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
          backgroundColor: Colors.white,
          selectedIndex: widget.currentIndex,
          onDestinationSelected: (int newIndex) {
            setState(() {
              widget.currentIndex = newIndex;
            });
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.ballot, color: secondaryBackgroundColor),
              icon:
                  Icon(Icons.ballot_outlined, color: secondaryBackgroundColor),
              label: 'Accounts',
            ),
            NavigationDestination(
              selectedIcon:
                  Icon(Icons.assignment, color: secondaryBackgroundColor),
              icon: Icon(Icons.assignment_outlined,
                  color: secondaryBackgroundColor),
              label: 'Items',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.connect_without_contact,
                  color: secondaryBackgroundColor),
              icon: Icon(Icons.connect_without_contact_outlined,
                  color: secondaryBackgroundColor),
              label: 'Help User',
            ),
            NavigationDestination(
              selectedIcon:
                  Icon(Icons.contactless, color: secondaryBackgroundColor),
              icon: Icon(Icons.contactless_outlined,
                  color: secondaryBackgroundColor),
              label: 'User',
            ),
          ],
        ),

        //ACTION BUTTON.
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: widget.currentIndex == 1 || widget.currentIndex == 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: widget.currentIndex == 1 ? _addItem : _addUser,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: const Alignment(0.7, -0.5),
                    end: const Alignment(0.6, 0.5),
                    colors: [
                      Colors.orange[200]!,
                      Colors.orange,
                    ],
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
