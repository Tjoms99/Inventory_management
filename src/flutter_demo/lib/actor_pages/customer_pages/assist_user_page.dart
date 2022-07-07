import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/account_service.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/page_route.dart';
import 'package:flutter_demo/services/totem_service.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where a customer or admin can assist an [Account].
class AssistUserPage extends StatefulWidget {
  final Account currentAccount;
  const AssistUserPage({required this.currentAccount});

  @override
  State<AssistUserPage> createState() => _AssistUserPageState();
}

class _AssistUserPageState extends State<AssistUserPage> {
  //Controller.
  final TextEditingController _emailController = TextEditingController();
  //Focus node.
  final FocusNode _focusEmail = FocusNode();
  //Keyboard checker.
  bool _isKeyboardEnabled = false;

  //Error.
  String _errorText = "";
  bool _isError = false;

  //Others.
  Account account = createDefaultAccount();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  ///Signs in [account] using [account.rfid].
  void _signInRFID() async {
    account.rfid = await getRFIDorNFC();
    _signIn();
  }

  ///Signs in [Account] using [_emailController].
  Future _signIn() async {
    String username = _emailController.text.trim();
    account = await getAccountFromName(username);

    debugPrint("Trying to log in ${account.accountName}");

    _isError = false;
    _errorText = "";
    if (isDefualt(account)) {
      _errorText = "Account does not exist";
      _isError = true;
    }

    debugPrint(_errorText);
    setState(() {});
    if (_isError) return;

    Navigator.of(context).push(PageRouter(
      child: UserPage(currentAccount: account),
      direction: AxisDirection.down,
    ));
  }

  ///Builds the help user page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //ICON.
                GestureDetector(
                  onTap: _signInRFID,
                  child: const ImageIcon(
                    AssetImage("assets/images/rfid_transparent.png"),
                    color: Color.fromARGB(255, 37, 174, 53),
                    size: 100,
                  ),
                ),

                //INFO TEXT.
                const Text(
                  'TAP ICON TO SCAN',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: secondFontSize),
                ),
                const SizedBox(height: firstBoxHeight),

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
                //EMAIL.
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
                      hintText: 'Username',
                      fillColor: textfieldBackgroundColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //SIGN-IN
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: standardPadding),
                  child: GestureDetector(
                    onTap: _signIn,
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
