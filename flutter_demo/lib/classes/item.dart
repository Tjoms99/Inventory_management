import 'dart:convert';

import 'package:flutter_demo/Services/item_service.dart';
import 'package:flutter_demo/classes/account.dart';

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

Item getItemFromList(List<dynamic> items, String rfid) {
  Item thisItem = createDefaultItem();

  for (int index = 0; index < items.length; index++) {
    Item item = createItemFromJson(items, index);

    if (item.rfid == rfid) {
      thisItem = item;
      break;
    }
  }

  print(thisItem);
  return thisItem;
}

List<String> getItemTypes(List<Item> items) {
  List<String> types = [];
  for (int index = 0; index < items.length; index++) {
    if (!types.contains(items[index].name)) types.add(items[index].name);
  }

  return types;
}

List<Item> getItemsInType(List<Item> items, String type) {
  List<Item> itemsInType = [];

  for (int index = 0; index < items.length; index++) {
    if (items[index].name.contains(type)) itemsInType.add(items[index]);
  }

  return itemsInType;
}

Future<List<Item>> getItemsForCustomer(Account customer) async {
  List<Item> items = await getItems();
  List<Item> itemsForCustomer = [];
  int indexCustomerId = customer.customerId.indexOf("1");

  print("getting items for customer");
  print(customer.customerId);
  print(indexCustomerId);
  for (int index = 0; index < items.length; index++) {
    if (items[index].registeredCustomerId.startsWith("1", indexCustomerId)) {
      itemsForCustomer.add(items[index]);
      print("added item");
    }
    print(items[index]);
  }

  print(items.length);
  return itemsForCustomer;
}

Future<List<Item>> getItemsForUser(Account user) async {
  List<Item> items = await getItems();
  List<Item> itemsForUser = [];
  List<int> customerIndex = [];

  print("getting items for user");
  print(user.registeredCustomerId);

  //Get all 1's registered to get index of customer id
  for (int index = 0; index < user.registeredCustomerId.length; index++) {
    if (user.registeredCustomerId.startsWith("1", index)) {
      customerIndex.add(index);
    }
  }

  //Get all items with correct customer id index (all items belongs to user)
  for (int index = 0; index < items.length; index++) {
    for (int indexCustomer = 0;
        indexCustomer < customerIndex.length;
        indexCustomer++) {
      if (items[index].registeredCustomerId.startsWith("1", indexCustomer)) {
        itemsForUser.add(items[index]);
        print("added item");
        print(items[index].rfid);
      }
    }
  }

  print(items.length);
  return itemsForUser;
}

Item getItemFromRFID(items, rfidTag) {
  Item thisItem = createDefaultItem();

  for (int index = 0; index < items.length; index++) {
    if (items[index].rfid == rfidTag) {
      thisItem = items[index];
      break;
    }
  }

  return thisItem;
}
