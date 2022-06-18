import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';

import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/customer_page.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_page.dart';

import 'package:http/http.dart' as http;

import '../classes/account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List accounts = [];
  //Default account
  Account currentAccount = createDefaultAccount();

  Future signIn() async {
    currentAccount = getAccountFromList(accounts, _emailController.text.trim(),
        _passwordController.text.trim());

    print("account role ${currentAccount.accountRole}");

    //Show approriate window depending on account role
    if (accountIndex == -1) {
      print("no account");
      return;
    }

    if (accounts[accountIndex]['password'] != _passwordController.text.trim()) {
      print("wrong password");
      return;
    }

    print("Signed in ${_emailController.text.trim()}");

    switch (accounts[accountIndex]['account_role']) {
      case "customer":
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CustomerPage(currentAccount: currentAccount)),
        );

        break;

      case "admin":
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminPage(currentAccount: currentAccount)),
        );
        break;

      default:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserPage(currentAccount: currentAccount)),
        );
    }
  }

  Future registerUser() async {
    //Shown in debug console
    String _email = _emailController.text.trim();
    print("Register user");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegisterPage(true, _email, '0', false, currentAccount)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<List> getAccounts() async {
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/getAccounts.php");
    final response = await http.get(uri);

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FutureBuilder<List>(
                future: getAccounts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error");
                  }
                  if (snapshot.hasData) {
                    accounts = snapshot.data as List;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Icon
                        const ImageIcon(
                          AssetImage("assets/images/rfid_transparent.png"),
                          color: Color.fromARGB(255, 37, 174, 53),
                          size: 100,
                        ),
                        //Hello
                        const Text(
                          'Scan to sign in',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: secondFontSize),
                        ),
                        const SizedBox(height: firstBoxHeight),

                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: standardPadding),
                          child: Text(
                            '---OR---',
                            style: TextStyle(
                              fontSize: forthFontSize,
                            ),
                          ),
                        ),
                        const SizedBox(height: firstBoxHeight),

                        //Email
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: texfieldPadding),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: textfieldEnabledBorderColor),
                                borderRadius:
                                    BorderRadius.circular(texfieldBorderRadius),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: textfieldFocusedBorderColor),
                                borderRadius:
                                    BorderRadius.circular(texfieldBorderRadius),
                              ),
                              hintText: 'Email',
                              fillColor: textfieldBackgroundColor,
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: thirdBoxHeight),

                        //Password
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: texfieldPadding),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: textfieldEnabledBorderColor),
                                borderRadius:
                                    BorderRadius.circular(texfieldBorderRadius),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: textfieldFocusedBorderColor),
                                borderRadius:
                                    BorderRadius.circular(texfieldBorderRadius),
                              ),
                              hintText: 'Password',
                              fillColor: textfieldBackgroundColor,
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: thirdBoxHeight),

                        //Sign-in
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: standardPadding),
                          child: GestureDetector(
                            onTap: signIn,
                            child: Container(
                              padding: const EdgeInsets.all(buttonPadding),
                              decoration: const BoxDecoration(
                                color: secondaryBackgroundColor,
                              ),
                              child: const Center(
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: buttonTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: buttonFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: thirdBoxHeight),

                        //Not a member
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Not a member?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: forthFontSize,
                              ),
                            ),
                            GestureDetector(
                              onTap: registerUser,
                              child: const Text(
                                ' Register now',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: forthFontSize,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ),
      ),
    );
  }
}
