import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:http/http.dart' as http;

///Returns a [List] of [Item]s from the database.
Future<List<Item>> getItems(Account account) async {
  List<Item> items = [];
  //Try to fetch data from server.
  try {
    var uri =
        Uri.parse("http://$ipAddress/dashboard/flutter_db/item/getItems.php");
    final response = await http.post(uri, body: {
      'account_role': account.accountRole,
      'customer_id': account.customerId,
    });

//Convert from json object to a list of items.
    for (int index = 0; index < jsonDecode(response.body).length; index++) {
      Item item = createItemFromJson(jsonDecode(response.body) as List, index);
      items.add(item);
    }
  } catch (e) {
    debugPrint("Failed to get items: $e");
  }
  return items;
}

///Deletes [Item] with [Item.id] from the database.
void deleteItem(int id) {
  try {
    var uri =
        Uri.parse("http://$ipAddress/dashboard/flutter_db/item/deleteItem.php");
    http.post(uri, body: {
      'id': jsonEncode(id),
    });
  } catch (e) {
    debugPrint("Failed to delete item: $e");
  }
}

///Inserts [Item] in the database.
///
///Returns error status.
Future<String> addItem(Item item) async {
  try {
    var uri =
        Uri.parse("http://$ipAddress/dashboard/flutter_db/item/addItem.php");

    var response = await http.post(uri, body: {
      'name': item.name,
      'status': item.status,
      'rfid': item.rfid,
      'description': item.description,
      'location': item.location,
      'registered_customer_id': item.registeredCustomerId,
    });

    return response.body;
  } catch (e) {
    debugPrint("Failed to add item: $e");
    return "-1";
  }
}

///Updates [Item] in the database.
///
///Returns error status.
Future<String> updateItem(Item item) async {
  try {
    var uri =
        Uri.parse("http://$ipAddress/dashboard/flutter_db/item/updateItem.php");

    var response = await http.post(uri, body: {
      'id': jsonEncode(item.id),
      'name': item.name,
      'status': item.status,
      'rfid': item.rfid,
      'description': item.description,
      'location': item.location,
      'registered_customer_id': item.registeredCustomerId,
    });
    return response.body;
  } catch (e) {
    debugPrint("Failed to update item: $e");
    return "-1";
  }
}
