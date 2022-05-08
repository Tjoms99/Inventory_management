import 'package:flutter/material.dart';

import 'constants.dart';
import 'login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  Future signOut() async {
    //Shown in debug console
    print("Register user");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: firstBoxHeight),
            Text('This is the main user page'),
            const SizedBox(height: firstBoxHeight),
            GestureDetector(
              onTap: signOut,
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
