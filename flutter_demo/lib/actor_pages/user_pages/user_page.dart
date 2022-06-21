import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/account.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/search_page.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_body_page.dart';

class UserPage extends StatefulWidget {
  Account currentAccount;
  UserPage({required this.currentAccount});

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
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
      body: UserBodyPage(currentAccount: widget.currentAccount),
    );
  }
}
