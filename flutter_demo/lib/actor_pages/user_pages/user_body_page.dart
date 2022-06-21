import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/item_service.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import '../../classes/item.dart';

class UserBodyPage extends StatefulWidget {
  Account currentAccount;
  UserBodyPage({required this.currentAccount});

  @override
  State<UserBodyPage> createState() => _UserBodyPageState();
}

class _UserBodyPageState extends State<UserBodyPage> {
  var userInput = 0;
  var infoText = '';
  var rfid_tag = "";
  var info;
  List<Item> items = [];

  //Should update the database when a user scans an item
  Future changeUserTask() async {
    items = await getItemsForUser(widget.currentAccount);
    Item item = createDefaultItem();
    var info;
    rfid_tag = "";
    NFCTag tag;

    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      print("rfid not working");
      return;
    } else {
      print("rfid working");
      try {
        tag = await FlutterNfcKit.poll();
        info = jsonEncode(tag);
        info = jsonDecode(info);
        rfid_tag = info['id'];

        item = getItemFromRFID(items, rfid_tag);

        print(item.status);
        switch (item.status) {
          case 'unassigned':
            item.status = 'borrowed';
            item.location = widget.currentAccount.accountName;
            break;

          case 'borrowed':
            item.status = 'returned';
            item.location = widget.currentAccount.accountName + ' (returned)';

            break;

          case 'returned':
            item.status = 'unassigned';
            item.location = 'inventory (defualt)';
            break;
          default:
            item.status = 'unknown';
        }

        print(item.rfid);
        setState(() {
          infoText =
              'You have ' + item.status + ' \nitem with id: ' + item.rfid;
          updateItem(item);
        });
      } catch (e) {
        print("waited too long to scan RFID");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Icon
              GestureDetector(
                onTap: changeUserTask,
                child: const ImageIcon(
                  AssetImage("assets/images/rfid_transparent.png"),
                  color: Color.fromARGB(255, 37, 174, 53),
                  size: 100,
                ),
              ),
              //Hello
              const Text(
                'SCAN AND TAP',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: secondFontSize),
              ),
              const SizedBox(height: thirdBoxHeight),
              const Text('The system knows what you want to do!'),

              const SizedBox(height: firstBoxHeight * 3),

              Text(
                infoText,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: secondFontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
