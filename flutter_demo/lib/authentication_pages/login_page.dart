import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/account_service.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';

import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/customer_page.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_page.dart';
import 'package:flutter_demo/services/totem_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String rfid_tag = "";
  //Accounts
  List<Account> accounts = [];
  Account currentAccount = createDefaultAccount();

  Future signInRFID() async {
    accounts = await getAccounts();
    currentAccount = createDefaultAccount();
    rfid_tag = await getRFIDorNFC();
    currentAccount = getAccountUsingRFID(accounts, rfid_tag);

    //Update page
    setState(() {});

    //Login if user exist
    print(currentAccount.accountName);
    if (!isDefualt(currentAccount)) {
      gotoPage();
    }
  }

  Future signIn() async {
    currentAccount.accountName = _emailController.text.trim();
    currentAccount.password = _passwordController.text.trim();

    if (isAccountRegistered(accounts, currentAccount.accountName)) {
      currentAccount = await getAccount(currentAccount);
    }

    //getAccountFromList(accounts, _emailController.text.trim(),
    //_passwordController.text.trim());

    print("account role ${currentAccount.accountRole}");

    //Show approriate window depending on account role
    if (isDefualt(currentAccount)) {
      print("no account");
      return;
    }

    print("Signed in ${currentAccount.accountName}");

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
    String _email = _emailController.text.trim();
    print("Register user");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegisterPage(true, _email, 0, false, currentAccount)),
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
            child: FutureBuilder<List<Account>>(
                future: getAccounts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error");
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
                            AssetImage("assets/images/rfid_transparent.png"),
                            color: Color.fromARGB(255, 37, 174, 53),
                            size: 100,
                          ),
                        ),
                        //Hello
                        const Text(
                          'TAP ICON TO SCAN RFID AND LOGIN',
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
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
      ),
    );
  }
}
