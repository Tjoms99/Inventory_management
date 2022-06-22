import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/actor_pages/customer_pages/customer_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/item_service.dart';
import 'package:flutter_demo/services/totem_service.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class AddItemPage extends StatefulWidget {
  final bool doAddItem;
  final Account currentAccount;
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

  final FocusNode _focusType = FocusNode();
  final FocusNode _focusStatus = FocusNode();
  final FocusNode _focusDescription = FocusNode();
  final FocusNode _focusLocation = FocusNode();
  final FocusNode _focusRegisteredCustomerID = FocusNode();

  bool _openKeyboardType = false;
  bool _openKeyboardStatus = false;
  bool _openKeyboardDescription = false;
  bool _openKeyboardLocation = false;
  bool _openKeyboardRegisteredCustomerID = false;

  bool _isKeyboardEnabled = false;

  String rfidTag = "";

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
      rfidTag = widget.item!.rfid;
      _descriptionController.text = widget.item!.description;
      _locationController.text = widget.item!.location;
      _registeredCustomerIdController.text = widget.item!.registeredCustomerId;
    }

    //keyboard
    _focusType.addListener(_onFocusChangeType);
    _focusStatus.addListener(_onFocusChangeStatus);
    _focusDescription.addListener(_onFocusChangeDescription);
    _focusLocation.addListener(_onFocusLocation);
    _focusRegisteredCustomerID.addListener(_onFocusChangeRegisteredCustomerID);
  }

  void setRegisteredCustomerID() {
    int customerIndex = -1;
    String id = "";

    //Should be length of 200
    while (id.length < 200) {
      id = id + "0";
    }

    for (int index = 0;
        index < widget.currentAccount.customerId.length;
        index++) {
      if (widget.currentAccount.customerId.startsWith("1", index)) {
        customerIndex = index;
        break;
      }
    }

    debugPrint("Registered CustomerID index: $customerIndex");
    if (customerIndex != -1) {
      id = id.substring(
            0,
            customerIndex,
          ) +
          "1" +
          id.substring(customerIndex, id.length - 1);
      _registeredCustomerIdController.text = id;

      debugPrint("New ID: $id");
    }

    setState(() {});
  }

  String getType() {
    return _typeController.text.trim();
  }

  String getStatus() {
    return _statusController.text.trim();
  }

  Future setRFID() async {
    rfidTag = await getRFIDorNFC();
    setState(() {});
  }

  String getRFID() {
    return rfidTag;
  }

  String getDescription() {
    return _descriptionController.text.trim();
  }

  String getLocation() {
    return _locationController.text.trim();
  }

  String getCustomerId() {
    String registeredCustomerId = _registeredCustomerIdController.text.trim();
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

  void _resetSelectedTextfield() {
    _openKeyboardType = false;
    _openKeyboardStatus = false;
    _openKeyboardDescription = false;
    _openKeyboardLocation = false;
    _openKeyboardRegisteredCustomerID = false;
  }

  void _onFocusChangeType() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardType = true;
    });
  }

  void _onFocusChangeStatus() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardStatus = true;
    });
  }

  void _onFocusChangeDescription() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardDescription = true;
    });
  }

  void _onFocusLocation() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardLocation = true;
    });
  }

  void _onFocusChangeRegisteredCustomerID() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardRegisteredCustomerID = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    setRegisteredCustomerID();
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
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
                        widget.doAddItem
                            ? 'TAP ICON TO SCAN RFID'
                            : 'TAP ICON TO SCAN AND UPDATE RFID',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: secondFontSize),
                      ),
                      const SizedBox(height: thirdBoxHeight),
                      Text(
                        'ID: ' + rfidTag,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: secondFontSize),
                      ),

                      const SizedBox(height: firstBoxHeight),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: standardPadding),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: texfieldPadding),
                        child: TextField(
                          controller: _typeController,
                          focusNode: _focusType,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: texfieldPadding),
                        child: TextField(
                          controller: _descriptionController,
                          focusNode: _focusDescription,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: texfieldPadding),
                        child: TextField(
                          controller: _statusController,
                          focusNode: _focusStatus,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: texfieldPadding),
                        child: TextField(
                          controller: _locationController,
                          focusNode: _focusLocation,
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

                      //Registered customer id
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: texfieldPadding),
                        child: TextField(
                          controller: _registeredCustomerIdController,
                          focusNode: _focusRegisteredCustomerID,
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
                          enabled: !isCustomer(widget.currentAccount),
                        ),
                      ),
                      const SizedBox(height: thirdBoxHeight),

                      //Add/Update
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: standardPadding),
                        child: GestureDetector(
                          onTap: widget.doAddItem ? _addItem : _updateItem,
                          child: Container(
                            padding: const EdgeInsets.all(buttonPadding),
                            decoration: const BoxDecoration(
                              color: secondaryBackgroundColor,
                            ),
                            child: Center(
                              child: Text(
                                widget.doAddItem
                                    ? 'Add to inventory'
                                    : 'Update',
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

                      //TAP TO OPEN KEYBOARD
                      SingleChildScrollView(
                        child: _isKeyboardEnabled
                            ? Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isKeyboardEnabled = false;
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: standardPadding,
                                          vertical: 30),
                                      child: Text(
                                        'TAP HERE TO CLOSE KEYBOARD',
                                        style: TextStyle(
                                          fontSize: thirdFontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  VirtualKeyboard(
                                    height: 300,
                                    //width: 500,
                                    textColor: Colors.black,

                                    textController: _openKeyboardType
                                        ? _typeController
                                        : _openKeyboardStatus
                                            ? _statusController
                                            : _openKeyboardDescription
                                                ? _descriptionController
                                                : _openKeyboardLocation
                                                    ? _locationController
                                                    : _openKeyboardRegisteredCustomerID
                                                        ? _registeredCustomerIdController
                                                        : TextEditingController(),
                                    //customLayoutKeys: _customLayoutKeys,
                                    defaultLayouts: const [
                                      VirtualKeyboardDefaultLayouts.English
                                    ],

                                    //reverseLayout :true,
                                    type: VirtualKeyboardType.Alphanumeric,
                                  ),
                                ],
                              ) //TAP TO OPEN KEYBOARD
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isKeyboardEnabled = true;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: standardPadding,
                                      vertical: 30),
                                  child: Text(
                                    'TAP HERE TO OPEN KEYBOARD',
                                    style: TextStyle(
                                      fontSize: thirdFontSize,
                                    ),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
