import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/account.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_body_page.dart';

///This is a page where a user can be borrow and return items.
class UserPage extends StatefulWidget {
  final Account currentAccount;
  const UserPage({required this.currentAccount});

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  ///Signs out [widget.currentAccount].
  Future _signOut() async {
    debugPrint("Signed out " + widget.currentAccount.accountName);
    Navigator.pop(context);
  }

  ///Updates current widget.
  Future _update() async {
    setState(() {});
  }

  ///Builds the user page.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
            backgroundColor: secondaryBackgroundColor,
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: mainGradient),
            ),
            title: Text(widget.currentAccount.accountName),
            leading: IconButton(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
            ),
            actions: [
              IconButton(
                onPressed: _update,
                icon: const Icon(Icons.update),
              ),
            ]),
        body: UserBodyPage(currentAccount: widget.currentAccount),
      ),
    );
  }
}
