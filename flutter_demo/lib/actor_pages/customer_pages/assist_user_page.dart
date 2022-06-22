import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/account_service.dart';
import 'package:flutter_demo/actor_pages/user_pages/user_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/totem_service.dart';

class AssistUserPage extends StatefulWidget {
  const AssistUserPage({Key? key}) : super(key: key);

  @override
  State<AssistUserPage> createState() => _AssistUserPageState();
}

class _AssistUserPageState extends State<AssistUserPage> {
  final bool _isUserScanned = false;
  Account currentAccount = createDefaultAccount();
  List<Item> items = [];
  List<Account> accounts = [];
  String infoText = "";
  var rfid_tag;

  @override
  void dispose() {
    super.dispose();
  }

  Future signInUser() async {
    accounts = await getAccounts();
    rfid_tag = await getRFIDorNFC();

    currentAccount = getAccountUsingRFID(accounts, rfid_tag);

    if (isDefualt(currentAccount)) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserPage(
                currentAccount: currentAccount,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon
                GestureDetector(
                  onTap: signInUser,
                  child: const ImageIcon(
                    AssetImage("assets/images/rfid_transparent.png"),
                    color: Color.fromARGB(255, 37, 174, 53),
                    size: 100,
                  ),
                ),
                //Hello
                const Text(
                  'TAP TO SCAN RFID',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: secondFontSize),
                ),
                const SizedBox(height: firstBoxHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
