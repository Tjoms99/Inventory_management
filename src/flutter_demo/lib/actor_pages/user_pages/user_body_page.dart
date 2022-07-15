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
  final bool isCustomerHelping;
  const UserBodyPage(
      {required this.currentAccount, required this.isCustomerHelping});

  @override
  State<UserBodyPage> createState() => _UserBodyPageState();
}

class _UserBodyPageState extends State<UserBodyPage> {
  String _infoText = '';
  //RFID.
  String _rfidText = "TAP HERE TO SCAN ITEM RFID";
  Color _rfidColor = Colors.orange;

  @override
  void initState() {
    super.initState();
  }

  ///Changes the [Color] of the rfid icon and the info [Text].
  void _changeStateRFID() {
    _rfidColor = _rfidColor == Colors.green ? Colors.orange : Colors.green;
    _rfidText = _rfidText == "TAP HERE TO SCAN ITEM RFID"
        ? "SCAN ITEM"
        : "TAP HERE TO SCAN ITEM RFID";
    setState(() {});
  }

  ///Updates the current [Item.status] of an item depending on its previous [Item.status].
  ///
  ///Updates [Item.location] when [Item.status] changes.
  Future _updateAction() async {
    if (_rfidColor == Colors.green) return;

    Item item = createDefaultItem();
    String rfidTag = "";

    _changeStateRFID();
    await Future.delayed(const Duration(milliseconds: 50));
    rfidTag = await getRFIDorNFC();
    _changeStateRFID();

    if (rfidTag.isEmpty) {
      _infoText = 'You have not scanned anything';

      setState(() {});
      return;
    }

    item = await getItemFromRFID(widget.currentAccount,
        widget.isCustomerHelping ? "customer" : "other", rfidTag);

    debugPrint(item.rfid);
    //Return if no item is found.
    if (item.rfid == "rfid") {
      _infoText = 'This item does not exist';

      setState(() {});
      return;
    }

    //Update item status and location.
    switch (item.status) {
      case 'borrowed':
        if (item.location != widget.currentAccount.accountName) {
          _infoText = 'This item is not yours to return';

          setState(() {});
          return;
        }

        item.status = 'returned';
        item.location = widget.currentAccount.accountName + ' (returned)';

        break;

      case 'returned':
        if (!canUnassignItem(item, widget.currentAccount.customerId) &&
            isCustomer(widget.currentAccount)) {
          _infoText = 'You can not unnasign this item';

          setState(() {});
          return;
        }
        if (isUser(widget.currentAccount)) {
          _infoText =
              'You can not borrow this item \n Customer action is needed';

          setState(() {});
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
    _infoText =
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
                    children: [
                      //ICON.
                      ImageIcon(
                        const AssetImage("assets/images/rfid_transparent.png"),
                        color: _rfidColor,
                        size: 100,
                      ),

                      //INFO TEXT.
                      Text(
                        _rfidText,
                        style: const TextStyle(
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
                    _infoText,
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
