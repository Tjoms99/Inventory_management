import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/item_service.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/account_service.dart';
import 'package:flutter_demo/services/totem_service.dart';

///This is a page where a user can be borrow and return items.
class UserBodyPage extends StatefulWidget {
  Account currentAccount;
  UserBodyPage({required this.currentAccount});

  @override
  State<UserBodyPage> createState() => _UserBodyPageState();
}

class _UserBodyPageState extends State<UserBodyPage> {
  String infoText = '';
  String rfidTag = "";
  // ignore: prefer_typing_uninitialized_variables.
  var info;
  List<Item> items = [];

  ///Updates the current [item.status] of an item depending on its previous [item.status].
  ///
  ///Updates [item.location] when [item.status] changes.
  Future updateAction() async {
    items = await getItems();
    Item item = createDefaultItem();

    rfidTag = await getRFIDorNFC();
    if (rfidTag.isEmpty) {
      setState(() {
        infoText = 'You have not scanned anything';
      });
      return;
    }

    item = getItemFromRFID(items, rfidTag);

    //Return if no item is found.
    if (item.rfid == "rfid") {
      setState(() {
        infoText = 'This item does not exist';
      });
      return;
    }

    //Update item status and location.
    switch (item.status) {
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
                'You can not borrow this item \n Customer action is needed';
          });
          return;
        }
        item.status = 'unassigned';
        item.location = 'inventory (defualt)';
        break;
      default:
        item.status = 'borrowed';
        item.location = widget.currentAccount.accountName;

        //Update current user and assign them to the customer of the item.
        widget.currentAccount.registeredCustomerId = getNewRegisteredCustomerID(
            widget.currentAccount.registeredCustomerId,
            item.registeredCustomerId);

        updateAccountRegisteredCustomerID(widget.currentAccount);
    }

    setState(() {
      infoText = 'You have ' + item.status + ' this item';
      updateItem(item);
    });
  }

  ///Builds the user page.
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
                'ID:' + rfidTag,
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