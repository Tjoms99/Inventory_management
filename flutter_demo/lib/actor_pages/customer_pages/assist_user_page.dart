import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/account_service.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/totem_service.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class AssistUserPage extends StatefulWidget {
  final Account currentAccount;
  const AssistUserPage({required this.currentAccount});

  @override
  State<AssistUserPage> createState() => _AssistUserPageState();
}

class _AssistUserPageState extends State<AssistUserPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusEmail = FocusNode();
  bool _isKeyboardEnabled = false;

  List<Item> items = [];
  List<Account> accounts = [];
  String infoText = "";
  String rfidTag = "";

  @override
  void dispose() {
    super.dispose();
  }

  Future signInButton() async {
    accounts = await getAccounts();
    String email = _emailController.text.trim();
    Account account = await getAccountFromName(email);

    if (!isAccountRegistered(accounts, email)) {
      debugPrint("Account does not exist");
      return;
    }

    debugPrint("Trying to log in ${account.accountName}");
    if (isDefualt(account)) {
      debugPrint("Account is defualt and does not exist");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserPage(
                currentAccount: account,
              )),
    );
  }

  Future signInUser() async {
    accounts = await getAccounts();
    rfidTag = await getRFIDorNFC();

    Account currentAccount = getAccountUsingRFID(accounts, rfidTag);

    if (isDefualt(currentAccount)) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserPage(
                currentAccount: currentAccount,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _isKeyboardEnabled ? FocusScope.of(context).unfocus() : "";
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon
                GestureDetector(
                  onTap: signInUser,
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
                      fontWeight: FontWeight.bold, fontSize: secondFontSize),
                ),
                const SizedBox(height: firstBoxHeight),
                //Email
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
                  child: TextField(
                    controller: _emailController,
                    focusNode: _focusEmail,
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

                //Sign-in
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: standardPadding),
                  child: GestureDetector(
                    onTap: signInButton,
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

                              textController: _emailController,
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
