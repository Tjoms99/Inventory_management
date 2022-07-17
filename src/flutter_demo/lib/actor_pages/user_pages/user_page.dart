import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/authentication_pages/login_page.dart';
import 'package:flutter_demo/classes/account.dart';

import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_body_page.dart';
import 'package:flutter_demo/page_route.dart';

///This is a page where a user can be borrow and return items.
class UserPage extends StatefulWidget {
  final Account currentAccount;
  final Account helpAccount;
  final bool isCustomer;
  const UserPage(
      {required this.currentAccount,
      required this.isCustomer,
      required this.helpAccount});

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  ///Signs out [widget.currentAccount].
  Future _signOut() async {
    debugPrint("Signed out " + widget.currentAccount.accountName);

    ///Changes the page depending on [widget.currentAccount.accountRole].
    if (isAdmin(widget.helpAccount) || isCustomer(widget.helpAccount)) {
      Navigator.of(context).push(PageRouter(
        child: AdminPage(
          currentAccount: widget.helpAccount,
          currentIndex: 2,
        ),
        direction: AxisDirection.up,
      ));
    } else {
      debugPrint("Go to login page");

      Navigator.of(context).push(PageRouter(
        child: const LoginPage(),
        direction: AxisDirection.right,
      ));
    }
  }

  ///Updates current widget.
  Future _update() async {
    Navigator.of(context).push(PageRouter(
      child: UserPage(
        currentAccount: widget.currentAccount,
        helpAccount: widget.helpAccount,
        isCustomer: widget.isCustomer,
      ),
      direction: null,
    ));
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
        body: UserBodyPage(
          currentAccount: widget.currentAccount,
          isCustomerHelping: widget.isCustomer,
        ),
      ),
    );
  }
}
