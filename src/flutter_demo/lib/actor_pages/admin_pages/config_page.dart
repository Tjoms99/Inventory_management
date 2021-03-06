// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/page_route.dart';
import 'package:flutter_demo/services/totem_service.dart';

import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where an instance of the application can be mapeed to [totemID] using an already existing [totemID] from the database.
class ConfigPage extends StatefulWidget {
  Account currentAccount;
  int pageIndex = 3;
  ConfigPage({required this.currentAccount, required this.pageIndex});

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
  bool isKeyboardActivatedTemp = isKeyboardActivated;

  //Error.
  String _errorText = "";
  bool _isError = false;

  //RFID.
  Color _rfidColor = Colors.white;
  String _rfidText = "TAP HERE TO SCAN TOTEM ID";
  String _rfidTag = "";

  ///Changes the [Color] of the rfid icon and the info [Text].
  void _changeStateRFID() {
    _rfidColor = _rfidColor == Colors.green ? Colors.white : Colors.green;
    _rfidText = _rfidText == "TAP HERE TO SCAN TOTEM ID"
        ? "SCAN TOTEM RFID"
        : "TAP HERE TO SCAN TOTEM ID";
    setState(() {});
  }

  ///Sets the [_rfidTag] using the Totem RFID or the NFC reader.
  Future setRFID() async {
    if (_rfidColor == Colors.green) return;

    _changeStateRFID();
    await Future.delayed(const Duration(milliseconds: 50));
    _rfidTag = await getRFIDorNFC();
    _totemIdController.text = _rfidTag;
    _changeStateRFID();
  }

  ///Updates the [totemID].
  Future _update() async {
    String id = _totemIdController.text.trim();

    _isError = false;
    _errorText = "";

    isKeyboardActivated = isKeyboardActivatedTemp;
    totemID = id;
    _gotoPage();
  }

  ///Changes the page.
  void _gotoPage() {
    Navigator.of(context).push(PageRouter(
      child: AdminPage(
        currentAccount: widget.currentAccount,
        currentIndex: widget.pageIndex,
      ),
      direction: AxisDirection.up,
    ));
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

                  //RFID.
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: setRFID,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: thirdBoxHeight),
                          //ICON.
                          ImageIcon(
                            const AssetImage(
                                "assets/images/rfid_transparent.png"),
                            color: _rfidColor,
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

                                  //ACTIVATE KEYBOARD
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: standardPadding),
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        isKeyboardActivatedTemp =
                                            !isKeyboardActivatedTemp;
                                      }),
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(buttonPadding),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: isKeyboardActivatedTemp
                                                ? activatedGradient
                                                : disabledGradient),
                                        child: Center(
                                          child: Text(
                                            isKeyboardActivatedTemp
                                                ? 'Keyboard Enabled'
                                                : 'Keyboard Disabled',
                                            style: const TextStyle(
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

                                  //UPDATE
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

                                  //Cancel.
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
                              isKeyboardActivatedTemp
                                  ? SingleChildScrollView(
                                      child: _isKeyboardEnabled
                                          ? Column(
                                              children: [
                                                GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () {
                                                    setState(() {
                                                      _isKeyboardEnabled =
                                                          false;
                                                    });
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                standardPadding,
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

                                                  textController:
                                                      _openKeyboardTotemId
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
                                              behavior: HitTestBehavior.opaque,
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
                                  : const SizedBox(),
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
