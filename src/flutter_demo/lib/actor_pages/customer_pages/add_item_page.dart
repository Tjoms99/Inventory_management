import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/actor_pages/admin_pages/admin_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/page_route.dart';
import 'package:flutter_demo/services/item_service.dart';
import 'package:flutter_demo/services/totem_service.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where an [Item] can be inserted or updated into the database.
class AddItemPage extends StatefulWidget {
  final bool doAddItem;
  final Account currentAccount;
  Item item;

  AddItemPage(
      {required this.doAddItem,
      required this.currentAccount,
      required this.item});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  //Controllers.
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _registeredCustomerIdController =
      TextEditingController();

  //Focus nodes.
  final FocusNode _focusType = FocusNode();
  final FocusNode _focusStatus = FocusNode();
  final FocusNode _focusDescription = FocusNode();
  final FocusNode _focusLocation = FocusNode();
  final FocusNode _focusRegisteredCustomerID = FocusNode();

  //Keyboard checkers.
  bool _openKeyboardType = false;
  bool _openKeyboardStatus = false;
  bool _openKeyboardDescription = false;
  bool _openKeyboardLocation = false;
  bool _openKeyboardRegisteredCustomerID = false;

  bool _isKeyboardEnabled = false;

  //Others.
  String _rfidTag = "";
  String _errorText = "";
  bool _isError = false;
  String _rfidText = "TAP HERE TO SCAN YOUR RFID CARD";

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
    rfidColor = Colors.white;
    setRegisteredCustomerID();

    //KEYBOARD.
    _focusType.addListener(_onFocusChangeType);
    _focusStatus.addListener(_onFocusChangeStatus);
    _focusDescription.addListener(_onFocusChangeDescription);
    _focusLocation.addListener(_onFocusLocation);
    _focusRegisteredCustomerID.addListener(_onFocusChangeRegisteredCustomerID);

    //Return if it is a default item.
    if (widget.item.name == "name") {
      return;
    }
    //TextEditingController.
    _typeController.text = widget.item.name;
    _statusController.text = widget.item.status;
    _rfidTag = widget.item.rfid;
    _descriptionController.text = widget.item.description;
    _locationController.text = widget.item.location;
    _registeredCustomerIdController.text = widget.item.registeredCustomerId;
  }

  ///Sets the [_registeredCustomerIdController] to a wanted value.
  ///
  ///Checks if the [_registeredCustomerIdController] can be edited.
  void setRegisteredCustomerID() {
    int customerIndex = -1;
    String id = "";

    if (!widget.doAddItem) {
      _registeredCustomerIdController.text = widget.item.registeredCustomerId;
      return;
    }

    //Should be length of 200.
    while (id.length < 200) {
      id = id + "0";
    }

    //Find customerID.
    for (int index = 0;
        index < widget.currentAccount.customerId.length;
        index++) {
      if (widget.currentAccount.customerId.startsWith("1", index)) {
        customerIndex = index;
        break;
      }
    }
    debugPrint("Registered CustomerID index: $customerIndex");

    //Set new registered customer ID.
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

  ///Returns the [String] located in the type textfield.
  String getType() {
    return _typeController.text.trim();
  }

  ///Returns the [String] located in the status textfield.
  String getStatus() {
    return _statusController.text.trim();
  }

  ///Changes the [Color] of the rfid icon and the info [Text].
  void _changeStateRFID() {
    rfidColor = rfidColor == Colors.green ? Colors.white : Colors.green;
    _rfidText = _rfidText == "TAP HERE TO SCAN YOUR RFID CARD"
        ? "SCAN YOUR CARD"
        : "TAP HERE TO SCAN YOUR RFID CARD";
    setState(() {});
  }

  ///Sets the [_rfidTag] using the Totem RFID or the NFC reader.
  Future setRFID() async {
    _changeStateRFID();
    await Future.delayed(const Duration(milliseconds: 50));
    _rfidTag = await getRFIDorNFC();
    _changeStateRFID();
  }

  ///Returns the [String] of the RFID.
  String getRFID() {
    return _rfidTag;
  }

  ///Returns the [String] located in the description textfield.
  String getDescription() {
    return _descriptionController.text.trim();
  }

  ///Returns the [String] located in the location textfield.
  String getLocation() {
    return _locationController.text.trim();
  }

  ///Returns the [String] located in the customerID textfield.
  String getCustomerId() {
    return _registeredCustomerIdController.text.trim();
  }

  ///Checks if the [Item] contains empty parameters.
  void errorCheck(Item item, String _errorPHP) {
    _isError = false;
    _errorText = "";

    if (item.name.isEmpty) {
      _errorText = "Missing item name\n";
      _isError = true;
    }
    if (item.status.isEmpty) {
      _errorText = _errorText + "Missing item status\n";
      _isError = true;
    }
    if (item.rfid.isEmpty) {
      _errorText = _errorText + "Missing item RFID\n";
      _isError = true;
    }
    if (item.description.isEmpty) {
      _errorText = _errorText + "Missing item description\n";
      _isError = true;
    }
    if (item.location.isEmpty) {
      _errorText = _errorText + "Missing item location\n";
      _isError = true;
    }
    if (item.registeredCustomerId.isEmpty) {
      _errorText = _errorText + "Missing item customer id\n";
      _isError = true;
    }

    if (_errorPHP != "0") _isError = true;
    if (_errorPHP == "-1") _errorText = _errorText + "Failed http request\n";
    if (_errorPHP == "1") _errorText = _errorText + "RFID already exists\n";
    debugPrint(_errorText);
    setState(() {});
  }

  ///Updates [Item] in the database.
  ///
  ///Checks if [TextEditingController] has information before registering [Item].
  Future _updateItem() async {
    Item item = Item(
        id: widget.item.id,
        name: getType(),
        status: getStatus(),
        rfid: getRFID(),
        description: getDescription(),
        location: getLocation(),
        registeredCustomerId: getCustomerId());

    String _errorPHP = await updateItem(item);
    _errorPHP = jsonDecode(_errorPHP);
    errorCheck(item, _errorPHP);

    if (_isError) return;
    gotoPage();
  }

  ///Adds [Item] in the database.
  ///
  ///Checks if [TextEditingController] has information before registering [Item].
  Future _addItem() async {
    Item item = Item(
        id: 0,
        name: getType(),
        status: getStatus(),
        rfid: getRFID(),
        description: getDescription(),
        location: getLocation(),
        registeredCustomerId: getCustomerId());

    //Can add items without RFID
    if (item.rfid.isEmpty) {
      item.rfid = "NO RFID ASSIGNED";
    }

    String _errorPHP = await addItem(item);
    _errorPHP = jsonDecode(_errorPHP);
    errorCheck(item, _errorPHP);

    if (_isError) return;
    gotoPage();
  }

  ///Goes to another page.
  Future cancelUpdate() async {
    gotoPage();
  }

  ///Changes the page depending on [widget.currentAccount.accountRole].
  Future gotoPage() async {
    Navigator.of(context).push(PageRouter(
      child: AdminPage(
        currentAccount: widget.currentAccount,
        currentIndex: 1,
      ),
      direction: AxisDirection.up,
    ));
  }

  ///Resets keyboard checkers.
  void _resetSelectedTextfield() {
    _openKeyboardType = false;
    _openKeyboardStatus = false;
    _openKeyboardDescription = false;
    _openKeyboardLocation = false;
    _openKeyboardRegisteredCustomerID = false;
  }

  ///Connects the [_typeController] to the keyboard.
  void _onFocusChangeType() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardType = true;
    });
  }

  ///Connects the [_statusController] to the keyboard.
  void _onFocusChangeStatus() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardStatus = true;
    });
  }

  ///Connects the [_descriptionController] to the keyboard.
  void _onFocusChangeDescription() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardDescription = true;
    });
  }

  ///Connects the [_locationController] to the keyboard.
  void _onFocusLocation() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardLocation = true;
    });
  }

  ///Connects the [_registeredCustomerIdController] to the keyboard.
  void _onFocusChangeRegisteredCustomerID() {
    setState(() {
      _resetSelectedTextfield();
      _openKeyboardRegisteredCustomerID = true;
    });
  }

  ///Builds the add item page.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(gradient: mainGradient),
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //RFID.
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: setRFID,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: thirdBoxHeight),
                          //ICON.
                          ImageIcon(
                            const AssetImage(
                                "assets/images/rfid_transparent.png"),
                            color: rfidColor,
                            size: 100,
                          ),

                          //INFO TEXT.
                          Text(
                            _rfidText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: thirdFontSize,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: thirdBoxHeight),

                          //RFID ID.
                          Text(
                            'ID: ' + _rfidTag,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: thirdFontSize,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: thirdBoxHeight),
                        ],
                      ),
                    ),
                  ),

                  //TEXTFIELDS & BUTTONS.
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: secondBoxHeight),
                              //INFO TEXT.
                              Text(
                                widget.doAddItem ? '---AND---' : '---OR---',
                                style: const TextStyle(
                                  fontSize: forthFontSize,
                                ),
                              ),
                              //
                              const SizedBox(height: firstBoxHeight),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: secondBoxHeight),

                                  //ERROR TEXT.
                                  _isError
                                      ? Text(
                                          _errorText,
                                          style: const TextStyle(
                                            fontSize: forthFontSize,
                                            color: Colors.red,
                                          ),
                                        )
                                      : const SizedBox(),

                                  //TYPE
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      controller: _typeController,
                                      focusNode: _focusType,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldEnabledBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldFocusedBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        hintText: 'Item type',
                                        fillColor: textfieldBackgroundColor,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: thirdBoxHeight),

                                  //DESCRIPTION.
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      controller: _descriptionController,
                                      focusNode: _focusDescription,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldEnabledBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldFocusedBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        hintText: 'Description',
                                        fillColor: textfieldBackgroundColor,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: thirdBoxHeight),

                                  //STATUS.
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      controller: _statusController,
                                      focusNode: _focusStatus,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldEnabledBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldFocusedBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        hintText: 'Status',
                                        fillColor: textfieldBackgroundColor,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: thirdBoxHeight),

                                  //LOCATION.
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      controller: _locationController,
                                      focusNode: _focusLocation,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldEnabledBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldFocusedBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        hintText: 'Location',
                                        fillColor: textfieldBackgroundColor,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: thirdBoxHeight),

                                  //REGISTERED CUSTOMER ID.
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: texfieldPadding),
                                    child: TextField(
                                      controller:
                                          _registeredCustomerIdController,
                                      focusNode: _focusRegisteredCustomerID,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldEnabledBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  textfieldFocusedBorderColor),
                                          borderRadius: BorderRadius.circular(
                                              texfieldBorderRadius),
                                        ),
                                        hintText: 'Registered customer ID',
                                        fillColor: textfieldBackgroundColor,
                                        filled: true,
                                      ),
                                      enabled:
                                          !isCustomer(widget.currentAccount),
                                    ),
                                  ),
                                  const SizedBox(height: thirdBoxHeight),

                                  //ADD / UPDATE
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: standardPadding),
                                    child: GestureDetector(
                                      onTap: widget.doAddItem
                                          ? _addItem
                                          : _updateItem,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(buttonPadding),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: mainGradient),
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

                                  //CANCEL
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: cancelUpdate,
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: thirdFontSize,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  //KEYBOARD
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
                                                      horizontal:
                                                          standardPadding,
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
                                                  VirtualKeyboardDefaultLayouts
                                                      .English
                                                ],

                                                //reverseLayout :true,
                                                type: VirtualKeyboardType
                                                    .Alphanumeric,
                                              ),
                                            ],
                                          )

                                        //TAP TO OPEN KEYBOARD
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
                            ],
                          ),
                        ),
                      ),
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
