import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:http/http.dart' as http;

///Returns [items] from the database.
Future<List<Item>> getItems() async {
  List<Item> items = [];
  //Try to fetch data from server.
  try {
    var uri = Uri.parse("http://$ipAddress/dashboard/flutter_db/getItems.php");
    final response = await http.get(uri);

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

///Deletes item with [id] from the database.
void deleteItem(int id) {
  try {
    var uri =
        Uri.parse("http://$ipAddress/dashboard/flutter_db/deleteItem.php");
    http.post(uri, body: {
      'id': jsonEncode(id),
    });
  } catch (e) {
    debugPrint("Failed to delete item: $e");
  }
}

///Inserts [item] in the database.
void addItem(Item item) {
  try {
    var uri = Uri.parse("http://$ipAddress/dashboard/flutter_db/addItem.php");

    http.post(uri, body: {
      'name': item.name,
      'status': item.status,
      'rfid': item.rfid,
      'description': item.description,
      'location': item.location,
      'registered_customer_id': item.registeredCustomerId,
    });
  } catch (e) {
    debugPrint("Failed to add item: $e");
  }
}

///Updates [item] in the dataves
void updateItem(Item item) {
  try {
    var uri =
        Uri.parse("http://$ipAddress/dashboard/flutter_db/updateItem.php");

    http.post(uri, body: {
      'id': jsonEncode(item.id),
      'name': item.name,
      'status': item.status,
      'rfid': item.rfid,
      'description': item.description,
      'location': item.location,
      'registered_customer_id': item.registeredCustomerId,
    });
  } catch (e) {
    debugPrint("Failed to update item: $e");
  }
}
