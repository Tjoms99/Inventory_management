import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/account_service.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';

import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/customer_page.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_page.dart';
import 'package:flutter_demo/services/totem_service.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();

  bool _openKeyboardEmail = false;
  bool _openKeyboardPassword = false;
  bool _isKeyboardEnabled = false;

  String rfidTag = "";
  //Accounts
  List<Account> accounts = [];
  Account currentAccount = createDefaultAccount();

  Future signInRFID() async {
    setState(() {});
    accounts = await getAccounts();
    currentAccount = createDefaultAccount();
    rfidTag = await getRFIDorNFC();
    currentAccount = getAccountUsingRFID(accounts, rfidTag);

    //Update page
    setState(() {});

    //Login if user exist
    debugPrint("Login user if it exists:" + currentAccount.accountName);
    if (!isDefualt(currentAccount)) {
      gotoPage();
    }
  }

  Future signIn() async {
    setState(() {});
    currentAccount.accountName = _emailController.text.trim();
    currentAccount.password = _passwordController.text.trim();

    if (isAccountRegistered(accounts, currentAccount.accountName)) {
      currentAccount = await getAccount(currentAccount);
    }

    //getAccountFromList(accounts, _emailController.text.trim(),
    //_passwordController.text.trim());

    debugPrint("The role of this account is:  ${currentAccount.accountRole}");

    //Show approriate window depending on account role
    if (isDefualt(currentAccount)) {
      debugPrint("This is a defualt account, cannot sign in");
      return;
    }

    debugPrint("Signed in ${currentAccount.accountName}");

    gotoPage();
  }

  void gotoPage() {
    switch (currentAccount.accountRole) {
      case "customer":
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerPage(
                    currentAccount: currentAccount,
                    currentIndex: 3,
                  )),
        );

        break;

      case "admin":
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminPage(
                    currentAccount: currentAccount,
                    currentIndex: 3,
                  )),
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
    setState(() {});
    String _email = _emailController.text.trim();
    debugPrint("Go to register page");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegisterPage(true, _email, 0, false, currentAccount)),
    );
  }

  void _onFocusChangeEmail() {
    debugPrint("Focus email: ${_focusEmail.hasFocus.toString()}");
    setState(() {
      _openKeyboardEmail = true;
      _openKeyboardPassword = false;
    });
  }

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
              children: [
                SingleChildScrollView(
                  child: FutureBuilder<List<Account>>(
                      future: getAccounts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          debugPrint("Error loading accounts");
                        }
                        if (snapshot.hasData) {
                          accounts = snapshot.data as List<Account>;
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Icon
                                GestureDetector(
                                  onTap: signInRFID,
                                  child: const ImageIcon(
                                    AssetImage(
                                        "assets/images/rfid_transparent.png"),
                                    color: Color.fromARGB(255, 37, 174, 53),
                                    size: 100,
                                  ),
                                ),
                                //Hello
                                const Text(
                                  'TAP ICON TO SCAN',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: secondFontSize),
                                ),
                                const SizedBox(height: firstBoxHeight),

                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: standardPadding),
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
                                    focusNode: _focusEmail,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: textfieldEnabledBorderColor),
                                        borderRadius: BorderRadius.circular(
                                            texfieldBorderRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: textfieldFocusedBorderColor),
                                        borderRadius: BorderRadius.circular(
                                            texfieldBorderRadius),
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
                                    focusNode: _focusPassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: textfieldEnabledBorderColor),
                                        borderRadius: BorderRadius.circular(
                                            texfieldBorderRadius),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: textfieldFocusedBorderColor),
                                        borderRadius: BorderRadius.circular(
                                            texfieldBorderRadius),
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
                                      padding:
                                          const EdgeInsets.all(buttonPadding),
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
                                ),
                              ]);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
                //TAP TO OPEN KEYBOARD
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
                                    horizontal: standardPadding, vertical: 30),
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
                                VirtualKeyboardDefaultLayouts.English
                              ],

                              //reverseLayout :true,
                              type: VirtualKeyboardType.Alphanumeric,
                            ),
                          ],
                        ) //TAP TO OPEN KEYBOARD
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isKeyboardEnabled = true;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: standardPadding, vertical: 30),
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
    );
  }
}
