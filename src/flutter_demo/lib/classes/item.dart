import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/item_service.dart';
import 'package:flutter_demo/classes/account.dart';

///A class of [Item].
class Item {
  int id;
  String name;
  String status;
  String rfid;
  String description;
  String location;
  String registeredCustomerId;

  Item(
      {required this.id,
      required this.name,
      required this.status,
      required this.rfid,
      required this.description,
      required this.location,
      required this.registeredCustomerId});
}

///Returns an [Item] from a dynamic [List] (json) of [items].
Item createItemFromJson(List<dynamic> items, int index) {
  return Item(
      id: jsonDecode(items[index]['id']),
      name: items[index]['name'] as String,
      status: items[index]['status'] as String,
      rfid: items[index]['rfid'] as String,
      description: items[index]['description'] as String,
      location: items[index]['location'] as String,
      registeredCustomerId: items[index]['registered_customer_id'] as String);
}

///Returns an [Item] with default values.
Item createDefaultItem() {
  return Item(
      id: 0,
      name: "name",
      status: "status",
      rfid: "rfid",
      description: "description",
      location: "location",
      registeredCustomerId: "registered_customer_id");
}

///Returns [Item] if it exists in [items] checking for matching [rfid].
Item getItemFromList(List<dynamic> items, String rfid) {
  Item thisItem = createDefaultItem();

  for (int index = 0; index < items.length; index++) {
    Item item = createItemFromJson(items, index);

    if (item.rfid == rfid) {
      thisItem = item;
      break;
    }
  }

  debugPrint("Got this item from items list: $thisItem");
  return thisItem;
}

///Returns a [List] of all [types] that is contained in [items].
List<String> getItemTypes(List<Item> items) {
  List<String> types = [];
  for (int index = 0; index < items.length; index++) {
    if (!types.contains(items[index].name)) types.add(items[index].name);
  }

  return types;
}

///Returns a list of items with a certian [type].
List<Item> getItemsInType(List<Item> items, String type) {
  List<Item> itemsInType = [];

  for (int index = 0; index < items.length; index++) {
    if (items[index].name.contains(type)) itemsInType.add(items[index]);
  }

  return itemsInType;
}

///Returns all [items] that belongs to a [customer] (or Admin).
Future<List<Item>> getItemsForCustomer(Account customer) async {
  List<Item> items = await getItems();
  List<Item> itemsForCustomer = [];
  int indexCustomerId = customer.customerId.indexOf("1");

  debugPrint("Getting items for customer: " +
      customer.accountName +
      "with id index: $indexCustomerId");

  //Add items that belong to correct customer or admin.
  for (int index = 0; index < items.length; index++) {
    if (items[index].registeredCustomerId.startsWith("1", indexCustomerId)) {
      itemsForCustomer.add(items[index]);
      debugPrint("Added item with id: ${items[index].rfid}");
    }
  }

  debugPrint("Item list length: ${items.length}");
  return itemsForCustomer;
}

///Returns an [Item] from a list of [items] using its [rfid].
Item getItemFromRFID(List<Item> items, String rfid) {
  Item thisItem = createDefaultItem();

  for (int index = 0; index < items.length; index++) {
    debugPrint("Checking item with rfid: " + items[index].rfid);

    if (items[index].rfid == rfid) {
      thisItem = items[index];
      debugPrint("Found item with rfid: " + thisItem.rfid);
      break;
    }
  }

  return thisItem;
}
