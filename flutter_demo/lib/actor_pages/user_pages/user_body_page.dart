import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/item_service.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/totem_service.dart';

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
  Future updateAction() async {
    items = await getItemsForUser(widget.currentAccount);
    Item item = createDefaultItem();

    rfid_tag = await getRFIDorNFC();
    if (rfid_tag.isEmpty) {
      setState(() {
        infoText = 'You have not scanned anything';
      });
      return;
    }

    item = getItemFromRFID(items, rfid_tag);

    //Return if no item is found
    if (item.rfid == "rfid") {
      setState(() {
        infoText = 'This item does not exist';
      });
      return;
    }

    switch (item.status) {
      case 'unassigned':
        item.status = 'borrowed';
        item.location = widget.currentAccount.accountName;
        break;

      case 'borrowed':
        if (item.location != widget.currentAccount.accountName) {
          setState(() {
            infoText = 'This item is not yours to return';
          });
          return;
        }

        item.status = 'returned';
        item.location = widget.currentAccount.accountName + ' (returned)';

        break;

      case 'returned':
        if (isUser(widget.currentAccount)) {
          setState(() {
            infoText =
                'You can not borrow this item \n Customer action  is needed';
          });
          return;
        }
        item.status = 'unassigned';
        item.location = 'inventory (defualt)';
        break;
      default:
        item.status = 'unknown';
    }

    setState(() {
      infoText = 'You have ' + item.status + ' this item';
      updateItem(item);
    });
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
                onTap: updateAction,
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

              const SizedBox(height: firstBoxHeight),

              Text(
                'ID:' + rfid_tag,
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
