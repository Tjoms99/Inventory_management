import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';


class RegisterPage extends StatefulWidget {
  final bool doRegister;
  final String email;

  RegisterPage(this.doRegister, this.email);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  //Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =  TextEditingController();

  String getEmail() {
    return _emailController.text.trim();
  }
  
  String getPassword() {
    return _passwordController.text.trim();
  }

  String getConfirmPassword() {
    return _passwordConfirmController.text.trim();
  }

  //TODO: get rfid tag from database
  String getTag(){
    return '1234567890';
  }


  @override
  void initState() {
    super.initState();
    initializeControllers();
    
  }

  void initializeControllers(){
    _emailController.text = widget.email;
  }

    @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }


  Future login() async {
    Navigator.pop(context);
  }

  //Should register/update the user
  // TODO: Store info in database
  Future registerUser() async {
    String email = getEmail();
    String password = getPassword();
    String confirmPassword = getConfirmPassword();
    
    if (true) {


      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
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
                  padding: EdgeInsets.symmetric(horizontal: standardPadding),
                  child: Text(
                    widget.doRegister? 'Scan your RFID tag' : 'Scan to update RFID\nCurrent: ${getTag()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: secondFontSize,
                    ),
                  ),
                ),
                const SizedBox(height: firstBoxHeight),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: standardPadding),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
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
                    enabled: widget.doRegister, 

                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //Password
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
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
                      hintText: widget.doRegister? 'Password' : 'New Password',
                      fillColor: textfieldBackgroundColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //Password confirm
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
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

                //Sign-in
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: standardPadding),
                  child: GestureDetector(
                    onTap: registerUser,
                    child: Container(
                      padding: const EdgeInsets.all(buttonPadding),
                      decoration: const BoxDecoration(
                        color: secondaryBackgroundColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.doRegister? 'Register' : 'Update',
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

                //Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.doRegister? 'Already a member?' : '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: forthFontSize,
                      ),
                    ),
                    GestureDetector(
                      onTap: login,
                      child: Text(
                        widget.doRegister? ' Login here' : ' Cancel here',
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
            ),
          ),
        ),
      ),
    );
  }
}
