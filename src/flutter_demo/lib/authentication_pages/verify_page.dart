import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/account_service.dart';

import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where an account can signed in using an account from the database.
class VerifyPage extends StatefulWidget {
  const VerifyPage();

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  //Controllers.
  final TextEditingController _verifyController = TextEditingController();

  //Focus nodes.
  final FocusNode _focusVerify = FocusNode();

  //Keyboard checkers.
  bool _openKeyboardVerify = false;
  bool _isKeyboardEnabled = false;

  //Error.
  String _errorText = "";
  bool _isError = false;

  Future _verify() async {
    String verificationCode = _verifyController.text.trim();

    _isError = false;
    _errorText = "";

    bool _verificationCompleted = await verifyAccount(verificationCode);

    if (!_verificationCompleted) {
      _isError = true;
      _errorText = "Wrong verification code";
      setState(() {});
      return;
    }

    _gotoPage();
  }

  ///Changes the page.
  void _gotoPage() {
    Navigator.of(context).pop();
  }

  ///Connects the [_verifyController] to the keyboard.
  void _onFocusChangePassword() {
    setState(() {
      _openKeyboardVerify = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _verifyController.text = "";
    _focusVerify.addListener(_onFocusChangePassword);
  }

  @override
  void dispose() {
    _verifyController.dispose();
    super.dispose();
  }

  ///Builds the login page.
  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: firstBoxHeight),

                  //INFO TEXT.
                  const Center(
                    child: Text(
                      'ENTER VERIFICATION CODE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: firstFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: firstBoxHeight),

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

                                  //TOTEM_ID.
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      controller: _verifyController,
                                      focusNode: _focusVerify,
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
                                        hintText: 'Verification code',
                                        fillColor: textfieldBackgroundColor,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: thirdBoxHeight),

                                  //SIGN-IN
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: standardPadding),
                                    child: GestureDetector(
                                      onTap: _verify,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(buttonPadding),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: mainGradient),
                                        child: const Center(
                                          child: Text(
                                            'Verify',
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

                                  GestureDetector(
                                    onTap: _gotoPage,
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: forthFontSize,
                                      ),
                                    ),
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

                                            textController: _openKeyboardVerify
                                                ? _verifyController
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
