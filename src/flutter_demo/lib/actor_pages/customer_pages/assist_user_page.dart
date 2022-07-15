import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/page_route.dart';
import 'package:flutter_demo/services/account_service.dart';
import 'package:flutter_demo/services/totem_service.dart';
// ignore: import_of_legacy_library_into_null_safe
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

  //RFID
  Color _rfidColor = Colors.orange;
  String _rfidText = "TAP HERE TO LOGIN WITH RFID";

  //Others.
  Account account = createDefaultAccount();

  ///Changes the [Color] of the rfid icon and the info [Text].
  void _changeStateRFID() {
    _rfidColor = _rfidColor == Colors.green ? Colors.orange : Colors.green;
    _rfidText = _rfidText == "TAP HERE TO LOGIN WITH RFID"
        ? "SCAN YOUR CARD"
        : "TAP HERE TO LOGIN WITH RFID";
    setState(() {});
  }

  ///Signs in [Account] using [Account.rfid].
  void _signInRFID() async {
    account = createDefaultAccount();

    _changeStateRFID();
    await Future.delayed(const Duration(milliseconds: 50));
    account.rfid = await getRFIDorNFC();
    _changeStateRFID();

    account = await getAccount(account);
    _signIn();
  }

  ///Signs in [Account] using [Account.accountName].
  Future<void> _signInName() async {
    account = createDefaultAccount();
    account.accountName = _emailController.text.trim();
    account = await getAccountFromName(account.accountName);
    _signIn();
  }

  ///Signs in [Account] using [_emailController].
  Future _signIn() async {
    debugPrint("Trying to log in ${account.accountName}");
    account.customerId = widget.currentAccount.customerId;

    _isError = false;
    _errorText = "";

    if (isDefualt(account)) {
      _errorText = _errorText + "Account does not exist";
      _isError = true;
    }

    debugPrint(_errorText);
    setState(() {});
    if (_isError) return;

    Navigator.of(context).push(PageRouter(
      child: UserPage(
        currentAccount: account,
        isCustomer: isCustomer(widget.currentAccount),
      ),
      direction: AxisDirection.down,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  ///Builds the help user page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _signInRFID,
                  child: Column(
                    children: [
                      //ICON.
                      ImageIcon(
                        const AssetImage("assets/images/rfid_transparent.png"),
                        color: _rfidColor,
                        size: 100,
                      ),

                      //INFO TEXT.
                      Text(
                        _rfidText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: thirdFontSize,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
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
                //EMAIL
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
                  child: TextField(
                    cursorColor: textfieldFocusedBorderColor,
                    controller: _emailController,
                    focusNode: _focusEmail,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.grey),
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
                    onTap: _signInName,
                    child: Container(
                      padding: const EdgeInsets.all(buttonPadding),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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

                //KEYBOARD
                isKeyboardActivated
                    ? SingleChildScrollView(
                        child: Container(
                          color: Colors.white,
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
                                            vertical: 10),
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
                                        horizontal: standardPadding,
                                        vertical: 10),
                                    child: Text(
                                      'TAP HERE TO OPEN KEYBOARD',
                                      style: TextStyle(
                                        fontSize: thirdFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
