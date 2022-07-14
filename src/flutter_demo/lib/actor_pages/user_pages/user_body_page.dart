import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/account_service.dart';
import 'package:flutter_demo/services/item_service.dart';
import 'package:flutter_demo/services/totem_service.dart';

///This is a page where a user can be borrow and return items.
class UserBodyPage extends StatefulWidget {
  final Account currentAccount;
  final bool isHelping;
  final bool isHelpingAdmin;
  const UserBodyPage(
      {required this.currentAccount,
      required this.isHelping,
      required this.isHelpingAdmin});

  @override
  State<UserBodyPage> createState() => _UserBodyPageState();
}

class _UserBodyPageState extends State<UserBodyPage> {
  String infoText = '';
  String rfidTag = "";
  // ignore: prefer_typing_uninitialized_variables.
  dynamic info;
  List<Item> items = [];

  ///Updates the current [Item.status] of an item depending on its previous [Item.status].
  ///
  ///Updates [Item.location] when [Item.status] changes.
  Future _updateAction() async {
    //Get items belonging only to customer if customer is helping user
    //Or get all items
    items = widget.isHelping
        ? widget.isHelpingAdmin
            ? await getItems()
            : await getItemsForCustomer(widget.currentAccount)
        : await getItems();

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

    updateItem(item);
    infoText =
        "You have ${item.status} this item\n\n\nDescription: ${item.description}\nRFID: ${item.rfid}\n";
    setState(() {});
  }

  ///Builds the user page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _updateAction,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      //ICON.
                      ImageIcon(
                        AssetImage("assets/images/rfid_transparent.png"),
                        color: Colors.orange,
                        size: 100,
                      ),

                      //INFO TEXT.
                      Text(
                        'TAP HERE TO SCAN RFID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: thirdFontSize,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: thirdBoxHeight),
                  const Text('The system knows what you want to do!'),
                  const SizedBox(height: firstBoxHeight),
                  Text(
                    infoText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: thirdFontSize,
                      color: Colors.black,
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
