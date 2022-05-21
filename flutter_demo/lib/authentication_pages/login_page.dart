import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';

import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:flutter_demo/actor_pages/customer_page.dart';
import 'package:flutter_demo/actor_pages/user_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future signIn() async {
    //Check email and password using the controllers
    //_emailController.text.trim()
    //_passwordController.text.trim()

    //Shown in debug console
    print("Signed in user");

    if(_emailController.text.trim() == "customer" || _emailController.text.trim() == "marcus.alex@live.no"){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerPage()),
    );
    } else {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserPage()),
    );
    }
  }

  Future registerUser() async {
    //Shown in debug console
    String _email = '${_emailController.text.trim()}';
    print("Register user");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage(true, _email)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
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
                      fontWeight: FontWeight.bold, fontSize: secondFontSize),
                ),
                const SizedBox(height: firstBoxHeight),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: standardPadding),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: standardPadding),
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
            ),
          ),
        ),
      ),
    );
  }
}
