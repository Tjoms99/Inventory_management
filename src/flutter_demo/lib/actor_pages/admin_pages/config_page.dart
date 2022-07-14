// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';

import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where an instance of the application can be mapeed to [totemID] using an already existing [totemID] from the database.
class ConfigPage extends StatefulWidget {
  Account currentAccount;
  ConfigPage({required this.currentAccount});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  //Controllers.
  final TextEditingController _totemIdController = TextEditingController();

  //Focus nodes.
  final FocusNode _focusTotemId = FocusNode();

  //Keyboard checkers.
  bool _openKeyboardTotemId = false;
  bool _isKeyboardEnabled = false;

  //Error.
  String _errorText = "";
  bool _isError = false;

  ///Updates the [totemID].
  Future _update() async {
    String id = _totemIdController.text.trim();

    _isError = false;
    _errorText = "";

    totemID = id;
    _gotoPage();
  }

  ///Changes the page.
  void _gotoPage() {
    Navigator.of(context).pop();
  }

  ///Connects the [_totemIdController] to the keyboard.
  void _onFocusChangePassword() {
    setState(() {
      _openKeyboardTotemId = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _totemIdController.text = totemID;
    _focusTotemId.addListener(_onFocusChangePassword);
  }

  @override
  void dispose() {
    _totemIdController.dispose();
    super.dispose();
  }

  ///Builds the config page.
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
                      'CONFIGURATION',
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
                                      controller: _totemIdController,
                                      focusNode: _focusTotemId,
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
                                        hintText: 'TOTEM ID',
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
                                      onTap: _update,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(buttonPadding),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: mainGradient),
                                        child: const Center(
                                          child: Text(
                                            'Update',
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

                                            textController: _openKeyboardTotemId
                                                ? _totemIdController
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
