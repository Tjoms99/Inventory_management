import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:http/http.dart' as http;

Future<List<Item>> getItems() async {
  List<Item> items = [];
  try {
//Fetch data from server
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/getItems.php");

    final response = await http.get(uri);

//Convert from json object to a list of Account(s)
    for (int index = 0; index < jsonDecode(response.body).length; index++) {
      Item item = createItemFromJson(jsonDecode(response.body) as List, index);
      items.add(item);
    }
  } catch (e) {
    debugPrint("Failed to get items: $e");
  }
  return items;
}

void deleteItem(int id) {
  try {
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/deleteItem.php");
    http.post(uri, body: {
      'id': jsonEncode(id),
    });
  } catch (e) {
    debugPrint("Failed to delete item: $e");
  }
}

void addItem(Item item) {
  try {
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/addItem.php");

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

void updateItem(Item item) {
  try {
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/updateItem.php");

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
