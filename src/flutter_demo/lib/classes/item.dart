import 'dart:convert';

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

///Returns [True] if item can be unassigned.
bool canUnassignItem(Item item, String customerId) {
  bool canUnnasign = false;
  int indexCustomerId = customerId.indexOf("1");

  if (indexCustomerId == -1) return false;

  if (item.registeredCustomerId.startsWith("1", indexCustomerId)) {
    canUnnasign = true;
  }
  return canUnnasign;
}
