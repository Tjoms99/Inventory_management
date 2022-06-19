import 'dart:convert';

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
      name: "accountName",
      status: "accountRole",
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
