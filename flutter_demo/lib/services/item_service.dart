import 'dart:convert';
import 'package:http/http.dart' as http;

import '../classes/item.dart';

Future<List<Item>> getItems() async {
  List<Item> items = [];

//Fetch data from server
  var uri = Uri.parse("http://192.168.1.201/dashboard/flutter_db/getItems.php");
  print(uri);

  final response = await http.get(uri);

//Convert from json object to a list of Account(s)
  for (int index = 0; index < jsonDecode(response.body).length; index++) {
    Item item = createItemFromJson(jsonDecode(response.body) as List, index);
    items.add(item);
  }

  return items;
}

void deleteItem(int id) {
  var uri =
      Uri.parse("http://192.168.1.201/dashboard/flutter_db/deleteItem.php");
  http.post(uri, body: {
    'id': jsonEncode(id),
  });
}

void addItem(Item item) {
  var uri = Uri.parse("http://192.168.1.201/dashboard/flutter_db/addItem.php");

  http.post(uri, body: {
    'name': item.name,
    'status': item.status,
    'rfid': item.rfid,
    'description': item.description,
    'location': item.location,
    'registered_customer_id': item.registeredCustomerId,
  });
}

void updateItem(Item item) {
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
}
