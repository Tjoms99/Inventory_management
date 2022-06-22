import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/customer_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/item_service.dart';
import 'package:flutter_demo/services/totem_service.dart';

class AddItemPage extends StatefulWidget {
  final bool doAddItem;
  Account currentAccount;
  Item? item;

  AddItemPage(
      {required this.doAddItem, required this.currentAccount, this.item});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  //Controllers
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _registeredCustomerIdController =
      TextEditingController();

  String rfid_tag = "";

  @override
  void dispose() {
    super.dispose();
    _typeController.dispose();
    _statusController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _registeredCustomerIdController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _typeController.text = widget.item!.name;
      _statusController.text = widget.item!.status;
      rfid_tag = widget.item!.rfid;
      _descriptionController.text = widget.item!.description;
      _locationController.text = widget.item!.location;
      _registeredCustomerIdController.text = widget.item!.registeredCustomerId;
    }
  }

  String getType() {
    return _typeController.text.trim();
  }

  String getStatus() {
    return _statusController.text.trim();
  }

  Future setRFID() async {
    rfid_tag = await getRFIDorNFC();
    setState(() {});
  }

  String getRFID() {
    return rfid_tag;
  }

  String getDescription() {
    return _descriptionController.text.trim();
  }

  String getLocation() {
    return _locationController.text.trim();
  }

  String getCustomerId() {
    String registeredCustomerId = _registeredCustomerIdController.text.trim();
    //Should be length of 200
    while (registeredCustomerId.length < 200) {
      registeredCustomerId = registeredCustomerId + "0";
    }
    return registeredCustomerId;
  }

  Future _updateItem() async {
    Item item = Item(
        id: widget.item!.id,
        name: getType(),
        status: getStatus(),
        rfid: getRFID(),
        description: getDescription(),
        location: getLocation(),
        registeredCustomerId: getCustomerId());

    if (item.name.isEmpty) {
      return;
    }
    if (item.status.isEmpty) {
      return;
    }
    if (item.rfid.isEmpty) {
      return;
    }
    if (item.description.isEmpty) {
      return;
    }
    if (item.location.isEmpty) {
      return;
    }
    if (item.registeredCustomerId.isEmpty) {
      return;
    }
    updateItem(item);
    gotoPage();
  }

  Future _addItem() async {
    Item item = Item(
        id: 0,
        name: getType(),
        status: getStatus(),
        rfid: getRFID(),
        description: getDescription(),
        location: getLocation(),
        registeredCustomerId: getCustomerId());

    if (item.name.isEmpty) {
      return;
    }
    if (item.status.isEmpty) {
      return;
    }
    //Will only work on mobile
    /*if (item.rfid.isEmpty) {
      return;
    } */

    if (item.description.isEmpty) {
      return;
    }
    if (item.location.isEmpty) {
      return;
    }
    if (item.registeredCustomerId.isEmpty) {
      return;
    }
    addItem(item);
    gotoPage();
  }

  Future cancelUpdate() async {
    gotoPage();
  }

  Future gotoPage() async {
    if (widget.currentAccount.accountRole == "admin") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminPage(
                  currentAccount: widget.currentAccount,
                  currentIndex: 1,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerPage(
                  currentAccount: widget.currentAccount,
                  currentIndex: 1,
                )),
      );
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
                //Icon
                GestureDetector(
                  onTap: setRFID,
                  child: const ImageIcon(
                    AssetImage("assets/images/rfid_transparent.png"),
                    color: Color.fromARGB(255, 37, 174, 53),
                    size: 100,
                  ),
                ),

                //Hello
                Text(
                  widget.doAddItem ? 'TAP TO SCAN RFID' : 'TAP TO UPDATE RFID',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: secondFontSize),
                ),
                const SizedBox(height: thirdBoxHeight),
                Text(
                  'ID: ' + rfid_tag,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: secondFontSize),
                ),

                const SizedBox(height: firstBoxHeight),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: standardPadding),
                  child: Text(
                    widget.doAddItem ? '---AND---' : '---OR---',
                    style: const TextStyle(
                      fontSize: forthFontSize,
                    ),
                  ),
                ),
                const SizedBox(height: firstBoxHeight),

                //Type
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
                  child: TextField(
                    controller: _typeController,
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
                      hintText: 'Item type',
                      fillColor: textfieldBackgroundColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //Description
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
                  child: TextField(
                    controller: _descriptionController,
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
                      hintText: 'Description',
                      fillColor: textfieldBackgroundColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //STATUS
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
                  child: TextField(
                    controller: _statusController,
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
                      hintText: 'Status',
                      fillColor: textfieldBackgroundColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //LOCATION
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
                  child: TextField(
                    controller: _locationController,
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
                      hintText: 'Location',
                      fillColor: textfieldBackgroundColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //LOCATION
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: texfieldPadding),
                  child: TextField(
                    controller: _registeredCustomerIdController,
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
                      hintText: 'Registered customer ID',
                      fillColor: textfieldBackgroundColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: thirdBoxHeight),

                //Add/Update
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: standardPadding),
                  child: GestureDetector(
                    onTap: widget.doAddItem ? _addItem : _updateItem,
                    child: Container(
                      padding: const EdgeInsets.all(buttonPadding),
                      decoration: const BoxDecoration(
                        color: secondaryBackgroundColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.doAddItem ? 'Add to inventory' : 'Update',
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

                //Not a member
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: cancelUpdate,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: thirdFontSize,
                        ),
                      ),
                    )
                  ],
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
