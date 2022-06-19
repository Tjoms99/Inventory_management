import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';

import '../../classes/account.dart';
import '../../classes/item.dart';
import '../../server/item_service.dart';
import '../admin_pages/admin_page.dart';
import 'customer_page.dart';

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
  final TextEditingController _rfidController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _registeredCustomerIdController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _typeController.dispose();
    _statusController.dispose();
    _rfidController.dispose();
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
      _rfidController.text = widget.item!.rfid;
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

  String getRfid() {
    _rfidController.text = "01234567890001";
    return _rfidController.text.trim();
  }

  String getDescription() {
    return _descriptionController.text.trim();
  }

  String getLocation() {
    return _locationController.text.trim();
  }

  String getCustomerId() {
    return _registeredCustomerIdController.text.trim();
  }

  Future _updateItem() async {
    Item item = Item(
        id: widget.item!.id,
        name: getType(),
        status: getStatus(),
        rfid: getRfid(),
        description: getDescription(),
        location: getLocation(),
        registeredCustomerId: getCustomerId());

    updateItem(item);
    gotoPage();
  }

  Future _addItem() async {
    Item item = Item(
        id: 0,
        name: getType(),
        status: getStatus(),
        rfid: getRfid(),
        description: getDescription(),
        location: getLocation(),
        registeredCustomerId: getCustomerId());

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
            builder: (context) =>
                AdminPage(currentAccount: widget.currentAccount)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CustomerPage(currentAccount: widget.currentAccount)),
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
                const ImageIcon(
                  AssetImage("assets/images/rfid_transparent.png"),
                  color: Color.fromARGB(255, 37, 174, 53),
                  size: 100,
                ),

                //Hello
                Text(
                  widget.doAddItem ? 'Add Item' : 'Update Item',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: secondFontSize),
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
