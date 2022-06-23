import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/account.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_body_page.dart';

class UserPage extends StatefulWidget {
  final Account currentAccount;
  const UserPage({required this.currentAccount});

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  Future _signOut() async {
    //Shown in debug console
    debugPrint("Signed out " + widget.currentAccount.accountName);
    Navigator.pop(context);
  }

  Future _update() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
          backgroundColor: secondaryBackgroundColor,
          title: Text(widget.currentAccount.accountName),
          leading: IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
          actions: [
            IconButton(
              onPressed: _update,
              icon: const Icon(Icons.search),
            ),
          ]),
      body: UserBodyPage(currentAccount: widget.currentAccount),
    );
  }
}
