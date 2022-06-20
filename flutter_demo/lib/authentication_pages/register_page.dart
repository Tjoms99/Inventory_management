import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/customer_page.dart';
import 'package:flutter_demo/authentication_pages/login_page.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/server/account_service.dart';

import '../classes/account.dart';

//TODO Add filed for account type for admin, add user does not work
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

  List<Account> accounts = [];
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

  //TODO: get rfid tag from database
  void setTag(String rfidString) {
    rfid_tag = rfidString;
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
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
        setTag(accounts[index].rfid);
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

    if (confirmPassword != password) {
      print("incorrect password");
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
                    accounts = snapshot.data!;
                    _checkAccount();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: firstBoxHeight),
                        //Icon
                        const ImageIcon(
                          AssetImage("assets/images/rfid_transparent.png"),
                          color: Color.fromARGB(255, 37, 174, 53),
                          size: 100,
                        ),
                        //Info text
                        //TODO add compatibility with RFID
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: standardPadding),
                          child: Text(
                            widget._doRegister
                                ? 'Scan your RFID tag'
                                : 'Scan to update RFID\nCurrent: ${getRFID()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: secondFontSize,
                            ),
                          ),
                        ),
                        const SizedBox(height: firstBoxHeight),

                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: standardPadding),
                          child: Text(
                            '---AND---',
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

                        //Password confirm
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: texfieldPadding),
                          child: TextField(
                            controller: _passwordConfirmController,
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

                        //Account role'
                        widget.currentAccount.accountRole == "admin"
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      controller: _accountRoleController,
                                      decoration: InputDecoration(
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
                                        hintText: 'Account role',
                                        fillColor: textfieldBackgroundColor,
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
                                      decoration: InputDecoration(
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
                                        hintText: 'Customer ID',
                                        fillColor: textfieldBackgroundColor,
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
                                      decoration: InputDecoration(
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
                                        hintText: 'Registered Customer ID',
                                        fillColor: textfieldBackgroundColor,
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
                                  fontSize: forthFontSize,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: thirdBoxHeight),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ),
      ),
    );
  }
}
