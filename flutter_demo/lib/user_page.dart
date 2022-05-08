import 'package:flutter/material.dart';

import 'constants.dart';
import 'login_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Column(
        children: [
          Text('This is the main user page'),
        ],
      ),
    );
  }
}
