import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/authentication_pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ///Disables action the back button executes.
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  /// This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
