import 'package:flutter/material.dart';
import 'constants.dart';

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
                  'Hello again!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: firstFontSize),
                ),
                const SizedBox(height: thirdBoxHeight),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: standardPadding),
                  child: Text(
                    'Welcome back, you\'ve been missed!',
                    style: TextStyle(
                      fontSize: secondFontSize,
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
                        borderSide:
                            BorderSide(color: textfieldEnabledBorderColor),
                        borderRadius:
                            BorderRadius.circular(texfieldBorderRadius),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: textfieldFocusedBorderColor),
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
                  child: GestureDetector(
                    onTap: signIn,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textfieldEnabledBorderColor),
                          borderRadius:
                              BorderRadius.circular(texfieldBorderRadius),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textfieldFocusedBorderColor),
                          borderRadius:
                              BorderRadius.circular(texfieldBorderRadius),
                        ),
                        hintText: 'Password',
                        fillColor: textfieldBackgroundColor,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //Sign-in
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: standardPadding),
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
                const SizedBox(height: secondBoxHeight),

                //Not a member
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: forthFontSize,
                      ),
                    ),
                    Text(
                      ' Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: forthFontSize,
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
