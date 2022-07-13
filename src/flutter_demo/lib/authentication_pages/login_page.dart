import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:flutter_demo/authentication_pages/verify_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';

import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_page.dart';
import 'package:flutter_demo/page_route.dart';
import 'package:flutter_demo/services/account_service.dart';
import 'package:flutter_demo/services/totem_service.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where an account can signed in using an account from the database.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controllers.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Focus nodes.
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();

  //Keyboard checkers.
  bool _openKeyboardEmail = false;
  bool _openKeyboardPassword = false;
  bool _isKeyboardEnabled = false;

  //Error.
  String _errorText = "";
  bool _isError = false;

  //Others.
  Account currentAccount = createDefaultAccount();
  bool _isVisible = false;
  bool _isLoginPressed = false;
  String _rfidText = "TAP HERE TO LOGIN WITH RFID";

  void _changeStateRFID() {
    rfidColor = rfidColor == Colors.green ? Colors.white : Colors.green;
    _rfidText = _rfidText == "TAP HERE TO LOGIN WITH RFID"
        ? "SCAN YOUR CARD"
        : "TAP HERE TO LOGIN WITH RFID";
    setState(() {});
  }

  ///Signs in [currentAccount] using [currentAccount.rfid].
  Future<void> _signInRFID() async {
    _changeStateRFID();
    await Future.delayed(const Duration(milliseconds: 50));
    currentAccount.rfid = await getRFIDorNFC();
    _changeStateRFID();

    _signIn();
  }

  ///Signs in [currentAccount] using the [_emailController] and the [_passwordController] or just using the [currentAccount.rfid].
  Future _signIn() async {
    currentAccount.accountName = _emailController.text.trim();
    currentAccount.password = _passwordController.text.trim();
    currentAccount = await getAccount(currentAccount);

    _isError = false;
    _errorText = "";

    if (isDefualt(currentAccount)) {
      debugPrint("This is a defualt account, can not sign in");
      _errorText =
          "Unkown username and password combination\n --or--\nUnknown RFID";
      _isError = true;
      setState(() {});
      return;
    }

    debugPrint("Signed in ${currentAccount.accountName}");
    debugPrint("Privileges:  ${currentAccount.accountRole}");

    if (!_isLoginPressed) _gotoPage();
  }

  ///Changes the page depending on [widget.currentAccount.accountRole].
  ///
  ///Goes to verify page if [Account] is not verified
  void _gotoPage() async {
    _isLoginPressed = true;

    bool _isVerified = await isAccountVerified(currentAccount);
    if (!_isVerified) {
      debugPrint("Need to verify account");
      Navigator.of(context).push(PageRouter(
        child: const VerifyPage(),
        direction: AxisDirection.down,
      ));
      return;
    }

    switch (currentAccount.accountRole) {
      case "customer":
        Navigator.of(context).push(PageRouter(
          child: AdminPage(
            currentAccount: currentAccount,
            currentIndex: 0,
          ),
          direction: AxisDirection.down,
        ));
        break;

      case "admin":
        Navigator.of(context).push(PageRouter(
          child: AdminPage(
            currentAccount: currentAccount,
            currentIndex: 0,
          ),
          direction: AxisDirection.down,
        ));
        break;

      default:
        Navigator.of(context).push(PageRouter(
          child: UserPage(
            currentAccount: currentAccount,
            isHelping: false,
            isHelpingAdmin: false,
          ),
          direction: AxisDirection.down,
        ));
    }
  }

  ///Changes current page to a register page
  Future _registerUser() async {
    String _email = _emailController.text.trim();
    debugPrint("Go to register page");
    Navigator.of(context).push(PageRouter(
      child: RegisterPage(true, _email, 0, false, currentAccount),
      direction: AxisDirection.left,
    ));
  }

  ///Connects the [_emailController] to the keyboard.
  void _onFocusChangeEmail() {
    debugPrint("Focus email: ${_focusEmail.hasFocus.toString()}");
    setState(() {
      _openKeyboardEmail = true;
      _openKeyboardPassword = false;
    });
  }

  ///Connects the [_passwordController] to the keyboard.
  void _onFocusChangePassword() {
    debugPrint("Focus pass: ${_focusPassword.hasFocus.toString()}");

    setState(() {
      _openKeyboardEmail = false;
      _openKeyboardPassword = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _focusEmail.addListener(_onFocusChangeEmail);
    _focusPassword.addListener(_onFocusChangePassword);
  }

  @override
  void despose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  ///Builds the login page.
  @override
  Widget build(BuildContext context) {
    setState(() {
      currentAccount = createDefaultAccount();
    });
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(gradient: mainGradient),
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //RFID.
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _signInRFID,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: thirdBoxHeight),
                          //ICON.
                          ImageIcon(
                            const AssetImage(
                                "assets/images/rfid_transparent.png"),
                            color: rfidColor,
                            size: 100,
                          ),

                          //INFO TEXT.
                          Text(
                            _rfidText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: thirdFontSize,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: thirdBoxHeight),
                        ],
                      ),
                    ),
                  ),

                  //TEXTFIELDS & BUTTONS.
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: secondBoxHeight),
                              //INFO TEXT.
                              const Text(
                                '---OR---',
                                style: TextStyle(
                                  fontSize: thirdFontSize,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: secondBoxHeight),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: secondBoxHeight),

                                  //ERROR TEXT.
                                  _isError
                                      ? Text(
                                          _errorText,
                                          style: const TextStyle(
                                            fontSize: forthFontSize,
                                            color: Colors.red,
                                          ),
                                        )
                                      : const SizedBox(),

                                  //EMAIL
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      cursorColor: textfieldFocusedBorderColor,
                                      controller: _emailController,
                                      focusNode: _focusEmail,
                                      decoration: InputDecoration(
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldEnabledBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldFocusedBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        hintText: 'Username',
                                        fillColor: textfieldBackgroundColor,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: thirdBoxHeight),

                                  //PASSWORD
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      controller: _passwordController,
                                      focusNode: _focusPassword,
                                      obscureText: !_isVisible,
                                      decoration: InputDecoration(
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldEnabledBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldFocusedBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        hintText: 'Password',
                                        fillColor: textfieldBackgroundColor,
                                        filled: true,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            _isVisible = !_isVisible;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            _isVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            size: 24,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: thirdBoxHeight),

                                  //SIGN-IN
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: standardPadding),
                                    child: GestureDetector(
                                      onTap: _signIn,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(buttonPadding),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: mainGradient),
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

                                  //REGISTER USER
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
                                        onTap: _registerUser,
                                        child: const Text(
                                          ' Register now',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: forthFontSize,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              //KEYBOARD
                              SingleChildScrollView(
                                child: _isKeyboardEnabled
                                    ? Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isKeyboardEnabled = false;
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: standardPadding,
                                                  vertical: 30),
                                              child: Text(
                                                'TAP HERE TO CLOSE KEYBOARD',
                                                style: TextStyle(
                                                  fontSize: thirdFontSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                          VirtualKeyboard(
                                            height: 300,
                                            //width: 500,
                                            textColor: Colors.black,

                                            textController: _openKeyboardEmail
                                                ? _emailController
                                                : _openKeyboardPassword
                                                    ? _passwordController
                                                    : TextEditingController(),
                                            //customLayoutKeys: _customLayoutKeys,
                                            defaultLayouts: const [
                                              VirtualKeyboardDefaultLayouts
                                                  .English
                                            ],

                                            //reverseLayout :true,
                                            type: VirtualKeyboardType
                                                .Alphanumeric,
                                          ),
                                        ],
                                      )

                                    //TAP TO OPEN KEYBOARD
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isKeyboardEnabled = true;
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: standardPadding,
                                              vertical: 30),
                                          child: Text(
                                            'TAP HERE TO OPEN KEYBOARD',
                                            style: TextStyle(
                                              fontSize: thirdFontSize,
                                            ),
                                          ),
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
