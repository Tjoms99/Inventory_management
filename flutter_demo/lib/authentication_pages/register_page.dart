import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/account_service.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/customer_page.dart';
import 'package:flutter_demo/authentication_pages/login_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/totem_service.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class RegisterPage extends StatefulWidget {
  final bool _doRegister;
  final String _email;
  final int _index;
  final bool _isLoggedIn;
  Account currentAccount;

  RegisterPage(this._doRegister, this._email, this._index, this._isLoggedIn,
      this.currentAccount);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  //Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _accountRoleController = TextEditingController();
  final TextEditingController _customerIDController = TextEditingController();
  final TextEditingController _registeredCustomerIDController =
      TextEditingController();

  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();
  final FocusNode _focusPasswordConfirm = FocusNode();
  final FocusNode _focusRole = FocusNode();
  final FocusNode _focusCustomerID = FocusNode();
  final FocusNode _focusRegisteredCustomerID = FocusNode();

  bool _openKeyboardEmail = false;
  bool _openKeyboardPassword = false;
  bool _openKeyboardConfirm = false;
  bool _openKeyboardRole = false;
  bool _openKeyboardCustomerID = false;
  bool _openKeyboardRegisteredCustomerID = false;

  bool _isKeyboardEnabled = false;

  List<Account> accounts = [];
  bool firstReload = false;
  bool _isRegistered = false;
  String rfid_tag = "";

  String getEmail() {
    return _emailController.text.trim();
  }

  String getPassword() {
    return _passwordController.text.trim();
  }

  String getConfirmPassword() {
    return _passwordConfirmController.text.trim();
  }

  String getRole() {
    String role = "user";
    if (isAdmin(widget.currentAccount)) {
      role = _accountRoleController.text.trim();
    }
    return role;
  }

  String getRFID() {
    return rfid_tag;
  }

  Future setRFID() async {
    var info;
    rfid_tag = await getTotemRFID();

    if (rfid_tag.isNotEmpty) {
      print("got rfid!!!");
      print(rfid_tag);
      setState(() {
        rfid_tag;
      });
    } else {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        print("rfid not working");
        return;
      } else {
        print("rfid working");
        try {
          var tag = await FlutterNfcKit.poll();
          info = jsonEncode(tag);
          info = jsonDecode(info);

          setState(() {
            rfid_tag = info['id'];
          });
        } catch (e) {}
      }
    }
  }

  String getCustomerID() {
    String customerId = _customerIDController.text.trim();
    //Should be length of 200
    while (customerId.length < 200) {
      customerId = customerId + "0";
    }
    return customerId;
  }

  String getReigstedCustomerId() {
    String registeredCustomerId = _registeredCustomerIDController.text.trim();
    //Should be length of 200
    while (registeredCustomerId.length < 200) {
      registeredCustomerId = registeredCustomerId + "0";
    }

    return registeredCustomerId;
  }

  void setTag(String rfidString) {
    rfid_tag = rfidString;
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

  void initializeControllers() {
    _emailController.text = widget._email;
    if (isAdmin(widget.currentAccount)) {}
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

  void _checkAccount() {
    print("check for user");
    _isRegistered = false;
    for (int index = 0; index < accounts.length; index++) {
      if (accounts[index].accountName == (getEmail())) {
        _isRegistered = true;
        _accountRoleController.text = accounts[index].accountRole;
        _customerIDController.text = accounts[index].customerId;
        _registeredCustomerIDController.text =
            accounts[index].registeredCustomerId;
        rfid_tag = accounts[index].rfid;
        firstReload = true;
        break;
      }
    }
  }

  Future gotoPage() async {
    if (widget._isLoggedIn) {
      if (widget.currentAccount.accountRole == "admin") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminPage(
                    currentAccount: widget.currentAccount,
                    currentIndex: 0,
                  )),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerPage(
                    currentAccount: widget.currentAccount,
                    currentIndex: 0,
                  )),
        );
      }
    } else {
      print("goto login");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  //Should register/update the user
  // TODO: Store info in database
  Future registerUser() async {
    String email = getEmail();
    String password = getPassword();
    String confirmPassword = getConfirmPassword();
    String accountRole = getRole();
    String rfid = getRFID();
    String customerId = getCustomerID();
    String registeredCustomerId = getReigstedCustomerId();

    Account account = Account(
        id: widget._index,
        accountName: email,
        accountRole: accountRole,
        password: password,
        rfid: rfid,
        customerId: customerId,
        registeredCustomerId: registeredCustomerId);

    if (confirmPassword != password && password.isEmpty) {
      print("incorrect password");
      return;
    }

    //Will be unable to add accounts in web
    /*if (rfid.isEmpty) {
      print("No rfid tag detected");
      return;
    } */

    if (email.isEmpty) {
      print("No email");
      return;
    }

    if (widget._doRegister) {
      if (_isRegistered) {
        print("returns");
        return;
      }

      addAccount(account);
      print("registered");
    } else {
      updateAccount(account);
      print("updated");
    }
    gotoPage();
  }

  void _resetSelectedTextfield() {
    _openKeyboardEmail = false;
    _openKeyboardPassword = false;
    _openKeyboardConfirm = false;
    _openKeyboardRole = false;
    _openKeyboardCustomerID = false;
    _openKeyboardRegisteredCustomerID = false;
  }

  void _onFocusChangeEmail() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardEmail = true;
    });
  }

  void _onFocusChangePassword() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardPassword = true;
    });
  }

  void _onFocusChangePasswordConfirm() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardConfirm = true;
    });
  }

  void _onFocusChangeRole() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardRole = true;
    });
  }

  void _onFocusChangeCustomerID() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardCustomerID = true;
    });
  }

  void _onFocusChangeRegisteredCustomerID() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardRegisteredCustomerID = true;
    });
  }

  void _hideKeyboard() {
    setState(() {
      _openKeyboardEmail = false;
      _openKeyboardPassword = false;
      _openKeyboardConfirm = false;
    });
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
                          print("Error");
                        }
                        if (snapshot.hasData) {
                          accounts = snapshot.data!;
                          if (!firstReload) _checkAccount();

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: firstBoxHeight),
                              //Icon
                              GestureDetector(
                                onTap: setRFID,
                                child: const ImageIcon(
                                  AssetImage(
                                      "assets/images/rfid_transparent.png"),
                                  color: Color.fromARGB(255, 37, 174, 53),
                                  size: 100,
                                ),
                              ),
                              //Info text
                              //TODO add compatibility with RFID
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: standardPadding),
                                child: Text(
                                  'ID: ' + getRFID(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: secondFontSize,
                                  ),
                                ),
                              ),
                              const SizedBox(height: firstBoxHeight),

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
                                  //enabled: widget._doRegister,
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
                                    hintText: widget._doRegister
                                        ? 'Password'
                                        : 'New Password',
                                    fillColor: textfieldBackgroundColor,
                                    filled: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: thirdBoxHeight),

                              //Password confirm
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
                                      borderRadius: BorderRadius.circular(
                                          texfieldBorderRadius),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: textfieldFocusedBorderColor),
                                      borderRadius: BorderRadius.circular(
                                          texfieldBorderRadius),
                                    ),
                                    hintText: 'Confirm Password',
                                    fillColor: textfieldBackgroundColor,
                                    filled: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: thirdBoxHeight),

                              //Account role'
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
                                                    color:
                                                        textfieldEnabledBorderColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        texfieldBorderRadius),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        textfieldFocusedBorderColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        texfieldBorderRadius),
                                              ),
                                              hintText: 'Account role',
                                              fillColor:
                                                  textfieldBackgroundColor,
                                              filled: true,
                                            ),
                                          ),
                                        ),
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
                                                    color:
                                                        textfieldEnabledBorderColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        texfieldBorderRadius),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        textfieldFocusedBorderColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        texfieldBorderRadius),
                                              ),
                                              hintText: 'Customer ID',
                                              fillColor:
                                                  textfieldBackgroundColor,
                                              filled: true,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: thirdBoxHeight),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: texfieldPadding),
                                          child: TextField(
                                            controller:
                                                _registeredCustomerIDController,
                                            focusNode:
                                                _focusRegisteredCustomerID,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        textfieldEnabledBorderColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        texfieldBorderRadius),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color:
                                                        textfieldFocusedBorderColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        texfieldBorderRadius),
                                              ),
                                              hintText:
                                                  'Registered Customer ID',
                                              fillColor:
                                                  textfieldBackgroundColor,
                                              filled: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  :
                                  //Display nothing
                                  const SizedBox(),

                              const SizedBox(height: thirdBoxHeight),

                              //Sign-up
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: standardPadding),
                                child: GestureDetector(
                                  onTap: registerUser,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(buttonPadding),
                                    decoration: const BoxDecoration(
                                      color: secondaryBackgroundColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget._doRegister
                                            ? 'Register'
                                            : 'Update',
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

                              //Cancle
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
                          );
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
