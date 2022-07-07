import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/customer_page.dart';
import 'package:flutter_demo/authentication_pages/login_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/page_route.dart';
import 'package:flutter_demo/services/account_service.dart';
import 'package:flutter_demo/services/totem_service.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where an [Account] can be inserted or updated into the database
class RegisterPage extends StatefulWidget {
  final bool _doRegister;
  final String _email;
  final int _index;
  final bool _isLoggedIn;
  final Account currentAccount;

  const RegisterPage(this._doRegister, this._email, this._index,
      this._isLoggedIn, this.currentAccount);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  //Controllers.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _accountRoleController = TextEditingController();
  final TextEditingController _customerIDController = TextEditingController();
  final TextEditingController _registeredCustomerIDController =
      TextEditingController();

  //Focus nodes.
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();
  final FocusNode _focusPasswordConfirm = FocusNode();
  final FocusNode _focusRole = FocusNode();
  final FocusNode _focusCustomerID = FocusNode();
  final FocusNode _focusRegisteredCustomerID = FocusNode();

  //Keyboard checkers.
  bool _openKeyboardEmail = false;
  bool _openKeyboardPassword = false;
  bool _openKeyboardConfirm = false;
  bool _openKeyboardRole = false;
  bool _openKeyboardCustomerID = false;
  bool _openKeyboardRegisteredCustomerID = false;

  bool _isKeyboardEnabled = false;

  //Error
  String _errorText = "";
  bool _isError = false;

  //Others.
  String _rfidTag = "";

  ///Returns the [String] located in the email textfield.
  String getEmail() {
    return _emailController.text.trim();
  }

  ///Returns the [String] located in the password textfield.
  String getPassword() {
    return _passwordController.text.trim();
  }

  ///Returns the [String] located in the confirm password textfield.
  String getConfirmPassword() {
    return _passwordConfirmController.text.trim();
  }

  ///Returns the [String] located in the role textfield.
  String getRole() {
    String role = "user";
    if (isAdmin(widget.currentAccount)) {
      role = _accountRoleController.text.trim();
    }
    return role;
  }

  ///Returns the [String] of the RFID.
  String getRFID() {
    return _rfidTag;
  }

  ///Sets the [_rfidTag] using the Totem RFID or the NFC reader.
  Future setRFID() async {
    _rfidTag = await getRFIDorNFC();
    setState(() {});
  }

  ///Returns the [String] located in the customerID textfield.
  String getCustomerID() {
    String customerId = _customerIDController.text.trim();
    //Should be length of 200
    while (customerId.length < 200) {
      customerId = customerId + "0";
    }
    return customerId;
  }

  ///Returns the [String] located in the registeredCustomerID textfield.
  String getReigstedCustomerId() {
    String registeredCustomerId = _registeredCustomerIDController.text.trim();
    //Should be length of 200
    while (registeredCustomerId.length < 200) {
      registeredCustomerId = registeredCustomerId + "0";
    }

    return registeredCustomerId;
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    _focusEmail.addListener(_onFocusChangeEmail);
    _focusPassword.addListener(_onFocusChangePassword);
    _focusPasswordConfirm.addListener(_onFocusChangePasswordConfirm);
    _focusRole.addListener(_onFocusChangeRole);
    _focusCustomerID.addListener(_onFocusChangeCustomerID);
    _focusRegisteredCustomerID.addListener(_onFocusChangeRegisteredCustomerID);
  }

  ///Populates the [TextEditingController]s with information if account exists.
  void initializeControllers() async {
    debugPrint("Initialize textfields");

    Account account = await getAccountFromName(widget._email);

    if (isDefualt(account)) return;

    _emailController.text = account.accountName;
    _accountRoleController.text = account.accountRole;
    _customerIDController.text = account.customerId;
    _registeredCustomerIDController.text = account.registeredCustomerId;
    _rfidTag = account.rfid;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _accountRoleController.dispose();
    _customerIDController.dispose();
    _registeredCustomerIDController.dispose();
    super.dispose();
  }

  ///Changes the page depending on [widget.currentAccount.accountRole].
  Future gotoPage() async {
    if (widget._isLoggedIn) {
      if (widget.currentAccount.accountRole == "admin") {
        Navigator.of(context).push(PageRouter(
          child: AdminPage(
            currentAccount: widget.currentAccount,
            currentIndex: 0,
          ),
          direction: AxisDirection.up,
        ));
      } else {
        Navigator.of(context).push(PageRouter(
          child: CustomerPage(
            currentAccount: widget.currentAccount,
            currentIndex: 0,
          ),
          direction: AxisDirection.up,
        ));
      }
    } else {
      debugPrint("Go to login page");

      Navigator.of(context).push(PageRouter(
        child: const LoginPage(),
        direction: AxisDirection.right,
      ));
    }
  }

  ///Inserts or updates [account] in the database.
  ///
  ///Checks if [TextEditingController] has information before registering [Account].
  Future registerUser() async {
    String email = getEmail();
    String password = getPassword();
    String confirmPassword = getConfirmPassword();
    String accountRole = getRole();
    String rfid = getRFID();
    String customerId = getCustomerID();
    String registeredCustomerId = getReigstedCustomerId();

    String _errorPHP = "-1";

    Account account = Account(
        id: widget._index,
        accountName: email,
        accountRole: accountRole,
        password: password,
        rfid: rfid,
        customerId: customerId,
        registeredCustomerId: registeredCustomerId);

    _errorText = "";
    _isError = false;

    if (email.isEmpty) {
      debugPrint("No email");
      _errorText = "No username entered\n";
      _isError = true;
    }

    if (confirmPassword != password) {
      debugPrint("incorrect password");
      _errorText = _errorText + "Password is not matching\n";
      _isError = true;
    }

    if (password.isEmpty) {
      debugPrint("incorrect password");
      _errorText = _errorText + "No password entered\n";
      _isError = true;
    }

    //Will be unable to add accounts in web.
    if (rfid.isEmpty) {
      debugPrint("No rfid tag detected");
      account.rfid = "NO RFID ASSIGNED";
      //return;
    }

    //Insert or update account
    if (widget._doRegister) {
      debugPrint("Trying to add user");
      _errorPHP = await addAccount(account);
    } else {
      debugPrint("Trying to update user");
      _errorPHP = await updateAccount(account);
    }

    _errorPHP = jsonDecode(_errorPHP);
    debugPrint("Error  = $_errorPHP");

    if (_errorPHP != "0") _isError = true;
    if (_errorPHP == "-1") _errorText = _errorText + "Failed http request\n";
    if (_errorPHP == "1") _errorText = _errorText + "Account already exists\n";
    if (_errorPHP == "2") _errorText = _errorText + "RFID already exists\n";

    setState(() {});
    if (_isError) return;

    debugPrint("Added/Updated completed");
    gotoPage();
  }

  ///Resets keyboard checkers.
  void _resetSelectedTextfield() {
    _openKeyboardEmail = false;
    _openKeyboardPassword = false;
    _openKeyboardConfirm = false;
    _openKeyboardRole = false;
    _openKeyboardCustomerID = false;
    _openKeyboardRegisteredCustomerID = false;
  }

  ///Connects the [_emailController] to the keyboard.
  void _onFocusChangeEmail() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardEmail = true;
    });
  }

  ///Connects the [_passwordController] to the keyboard.
  void _onFocusChangePassword() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardPassword = true;
    });
  }

  ///Connects the [_passwordConfirmController] to the keyboard.
  void _onFocusChangePasswordConfirm() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardConfirm = true;
    });
  }

  ///Connects the [_accountRoleController] to the keyboard.
  void _onFocusChangeRole() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardRole = true;
    });
  }

  ///Connects the [_customerIDController] to the keyboard.
  void _onFocusChangeCustomerID() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardCustomerID = true;
    });
  }

  ///Connects the [_registeredCustomerIDController] to the keyboard.
  void _onFocusChangeRegisteredCustomerID() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardRegisteredCustomerID = true;
    });
  }

  ///Builds the register page.
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: firstBoxHeight),

                      //RFID ICON.
                      GestureDetector(
                        onTap: setRFID,
                        child: const ImageIcon(
                          AssetImage("assets/images/rfid_transparent.png"),
                          color: Color.fromARGB(255, 37, 174, 53),
                          size: 100,
                        ),
                      ),

                      //INFO TEXT.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: standardPadding),
                        child: Text(
                          widget._doRegister
                              ? 'TAP ICON TO SCAN RFID'
                              : 'TAP ICON TO UPDATE RFID',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: secondFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: thirdBoxHeight),

                      //RFID ID.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: standardPadding),
                        child: Text(
                          'ID: ' + _rfidTag,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: secondFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: firstBoxHeight),

                      //INFO TEXT.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: standardPadding),
                        child: Text(
                          widget._doRegister ? '---AND---' : '---OR---',
                          style: const TextStyle(
                            fontSize: forthFontSize,
                          ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: texfieldPadding),
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
                          //enabled: widget._doRegister,
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
                            hintText: widget._doRegister
                                ? 'Password'
                                : 'New Password',
                            fillColor: textfieldBackgroundColor,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: thirdBoxHeight),

                      //PASSWORD CONFIRM
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: texfieldPadding),
                        child: TextField(
                          controller: _passwordConfirmController,
                          focusNode: _focusPasswordConfirm,
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
                            hintText: 'Confirm Password',
                            fillColor: textfieldBackgroundColor,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: thirdBoxHeight),

                      //ACCOUNT ROLE
                      //Show if the user is admin
                      widget.currentAccount.accountRole == "admin"
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: texfieldPadding),
                                  child: TextField(
                                    controller: _accountRoleController,
                                    focusNode: _focusRole,
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
                                      hintText: 'Account role',
                                      fillColor: textfieldBackgroundColor,
                                      filled: true,
                                    ),
                                  ),
                                ),

                                //CUSTOMER ID
                                const SizedBox(height: thirdBoxHeight),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: texfieldPadding),
                                  child: TextField(
                                    controller: _customerIDController,
                                    focusNode: _focusCustomerID,
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
                                      hintText: 'Customer ID',
                                      fillColor: textfieldBackgroundColor,
                                      filled: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: thirdBoxHeight),

                                //REGISTERED CUSTOMER ID
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: texfieldPadding),
                                  child: TextField(
                                    controller: _registeredCustomerIDController,
                                    focusNode: _focusRegisteredCustomerID,
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
                                      hintText: 'Registered Customer ID',
                                      fillColor: textfieldBackgroundColor,
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          :
                          //display nothing if user is not admin
                          const SizedBox(),

                      const SizedBox(height: thirdBoxHeight),

                      //SIGN-UP
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: standardPadding),
                        child: GestureDetector(
                          onTap: registerUser,
                          child: Container(
                            padding: const EdgeInsets.all(buttonPadding),
                            decoration: const BoxDecoration(
                              color: secondaryBackgroundColor,
                            ),
                            child: Center(
                              child: Text(
                                widget._doRegister ? 'Register' : 'Update',
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

                      //CANCEL
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: gotoPage,
                            child: const Text(
                              ' Cancel',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: thirdFontSize,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
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
                                      : _openKeyboardConfirm
                                          ? _passwordConfirmController
                                          : _openKeyboardRole
                                              ? _accountRoleController
                                              : _openKeyboardCustomerID
                                                  ? _customerIDController
                                                  : _openKeyboardRegisteredCustomerID
                                                      ? _registeredCustomerIDController
                                                      : TextEditingController(),
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
