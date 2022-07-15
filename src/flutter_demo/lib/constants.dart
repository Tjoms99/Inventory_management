import 'package:flutter/material.dart';

//Addresses
const ipAddress = "192.168.1.201"; //192.168.43.90"
const fromEmail = "inventorymanagement.verify@gmail.com";
String totemID = "default totem ID";

//Keyboard
bool isKeyboardActivated = false;
// Colors
Color primaryBackgroundColor = Colors.white;
const Color secondaryBackgroundColor = Colors.orangeAccent;

const Color buttonBackgroundColor = Colors.orangeAccent;
const Color buttonSecondaryColor = Colors.grey;
const Color buttonTextColor = Colors.white;

const Color textfieldBackgroundColor = Color.fromARGB(255, 238, 238, 238);
const Color textfieldEnabledBorderColor = Colors.white;
const Color textfieldFocusedBorderColor = Colors.orangeAccent;
const Color textfieldTextColor = Color.fromARGB(225, 224, 224, 224);

LinearGradient mainGradient = LinearGradient(
  begin: Alignment.topCenter,
  colors: [
    Colors.orange[800]!,
    Colors.orange[500]!,
    Colors.orange[300]!,
  ],
);

LinearGradient disabledGradient = LinearGradient(
  begin: Alignment.topCenter,
  colors: [
    Colors.grey[800]!,
    Colors.grey[500]!,
    Colors.grey[300]!,
  ],
);

LinearGradient activatedGradient = LinearGradient(
  begin: Alignment.topCenter,
  colors: [
    Colors.green[800]!,
    Colors.green[500]!,
    Colors.green[300]!,
  ],
);
//Text sizes
const double firstFontSize = 36;
const double secondFontSize = 24;
const double thirdFontSize = 16;
const double forthFontSize = 14;

const double buttonFontSize = 16;

//Padding
const double standardPadding = 25;

const double firstBoxHeight = 50;
const double secondBoxHeight = 25;
const double thirdBoxHeight = 10;

const double texfieldPadding = 20;
const double texfieldBorderRadius = 20;

const double buttonPadding = 20;
