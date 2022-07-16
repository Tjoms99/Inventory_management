import 'package:flutter/material.dart';
import 'package:flutter_demo/services/item_service.dart';

import 'package:flutter_demo/actor_pages/customer_pages/add_item_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/page_route.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page that builds a [List] of [Item]s for customers and admins.
class ItemsListPage extends StatefulWidget {
  final Account currentAccount;
  const ItemsListPage({required this.currentAccount});

  @override
  State<ItemsListPage> createState() => _ItemsListPageState();
}

class _ItemsListPageState extends State<ItemsListPage> {
  //Item lists.
  List<Item> _items = [];
  List<Item> _allItems = [];
  //Controller.
  final TextEditingController _searchController = TextEditingController();
  //Focus node.
  final FocusNode _focusSearch = FocusNode();
  //Keyboard checker.
  bool _isKeyboardEnabled = false;
  bool _isFirstLoad = true;

  ///Updates [accounts] with content that is contained in [_searchController].
  Future _searchItems() async {
    var suggestons = _allItems.where((item) {
      final itemName = item.name.toLowerCase();
      final itemDescription = item.description.toLowerCase();
      final itemLocation = item.location.toLowerCase();
      final itemStatus = item.status.toLowerCase();
      final itemRFID = item.rfid.toLowerCase();

      final input = _searchController.text.toLowerCase().trim();

      if (itemName.contains(input) ||
          itemDescription.contains(input) ||
          itemLocation.contains(input) ||
          itemStatus.contains(input) ||
          itemRFID.contains(input)) {
        return true;
      }
      return false;
    }).toList();

    suggestons.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    _items = suggestons;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchItems);
  }

  @override
  void dispose() {
    _items.clear();
    _searchController.dispose();
    super.dispose();
  }

  ///Builds the [Item]s list page.
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            TextField(
              cursorColor: textfieldFocusedBorderColor,
              controller: _searchController,
              focusNode: _focusSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.orange,
                ),
                hintStyle: TextStyle(color: Colors.orange),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textfieldEnabledBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textfieldEnabledBorderColor),
                ),
                hintText: 'Search',
                fillColor: Colors.white,
                filled: true,
              ),
            ),

            //KEYBOARD
            isKeyboardActivated
                ? SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: _isKeyboardEnabled
                          ? Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      _isKeyboardEnabled = false;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: standardPadding,
                                        vertical: 15),
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
                                  textController: _searchController,
                                  //customLayoutKeys: _customLayoutKeys,
                                  defaultLayouts: const [
                                    VirtualKeyboardDefaultLayouts.English
                                  ],

                                  //reverseLayout :true,
                                  type: VirtualKeyboardType.Alphanumeric,
                                ),
                              ],
                            )

                          //TAP TO OPEN KEYBOARD
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  _isKeyboardEnabled = true;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: standardPadding, vertical: 15),
                                child: Text(
                                  'TAP HERE TO OPEN KEYBOARD',
                                  style: TextStyle(
                                    fontSize: thirdFontSize,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  )
                : const SizedBox(),

            FutureBuilder<List<Item>>(
              future: getItems(widget.currentAccount),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  //error
                  debugPrint("future builder error");
                }

                if (snapshot.hasData) {
                  _allItems = snapshot.data as List<Item>;
                  _isFirstLoad ? _searchItems() : debugPrint("Not first load");
                  _isFirstLoad = false;

                  return Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: ItemListView(
                      title: "Items",
                      listToBuild: _items,
                      currentAccount: widget.currentAccount,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

///This is a page that expands a [List] of [Item]s on request.
class ItemListView extends StatefulWidget {
  String title;
  List<Item> listToBuild;
  final Account currentAccount;

  ItemListView({
    required this.title,
    required this.listToBuild,
    required this.currentAccount,
  });

  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final bool _expandFlag = false;
  final List<bool> _hasPressedDelete = [];
  final List<bool> _hasPressedModify = [];
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    initPressedDelete();
    initPressedModify();
  }

  ///Initializes modify [Icon] state.
  void initPressedModify() {
    for (int index = 0; index < widget.listToBuild.length; index++) {
      _hasPressedModify.add(false);
    }
  }

  ///Initializes delete [Icon] state.
  void initPressedDelete() {
    for (int index = 0; index < widget.listToBuild.length; index++) {
      _hasPressedDelete.add(false);
    }
  }

  ///Clears modify [Icon] state.
  void clearPressedModify() {
    for (int index = 0; index < widget.listToBuild.length; index++) {
      _hasPressedModify[index] = false;
    }
  }

  ///Clears delete [Icon] state.
  void clearPressedDelete() {
    for (int index = 0; index < widget.listToBuild.length; index++) {
      _hasPressedDelete[index] = false;
    }
  }

  ///Returns index of [thisItem] in current [Item] list.
  int getIndex(Item thisItem) {
    final index =
        widget.listToBuild.indexWhere((element) => element.id == thisItem.id);

    return index;
  }

  ///Updates which [Icon] is pressed.
  void setSelected(Item item) {
    setState(() {
      _selectedIndex = getIndex(item);
      clearPressedModify();
      clearPressedDelete();
    });
  }

  ///Goes to update [Item] page.
  void _updateItem(Item item) {
    if (_hasPressedModify[getIndex(item)]) {
      Navigator.of(context).push(PageRouter(
        child: AddItemPage(
          currentAccount: widget.currentAccount,
          doAddItem: false,
          item: item,
        ),
        direction: AxisDirection.down,
      ));
    }

    //Update state.
    setState(() {
      if (_hasPressedModify[getIndex(item)]) {
        clearPressedModify();
        _selectedIndex = -1;
      } else {
        setSelected(item);
        _hasPressedModify[getIndex(item)] = true;
        clearPressedDelete();
      }
    });
  }

  ///Goes to update [Item] page.
  void _deleteItem(Item item) {
    setState(() {
      if (_hasPressedDelete[getIndex(item)]) {
        deleteItem(item.id);

        widget.listToBuild.removeAt(getIndex(item));
        if (widget.listToBuild.isEmpty) {
          widget.title = "";
        }

        clearPressedDelete();
        _selectedIndex = -1;
      } else {
        setSelected(item);

        _hasPressedDelete[getIndex(item)] = true;
        clearPressedModify();
      }
    });
  }

  ///Builds the [Item] page.
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.orange[300];
            }
            return null; // Use the default value.
          }),
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Type',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Description',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Location',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'RFID',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Action',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],

          //ITEMS IN EXPANDABLE LIST.
          rows: widget.listToBuild
              .map(
                ((item) => DataRow(
                      cells: <DataCell>[
                        DataCell(GestureDetector(
                            onTap: () => setSelected(item),
                            child: Text(item.name))),
                        DataCell(GestureDetector(
                            onTap: () => setSelected(item),
                            child: Text(item.status))),
                        DataCell(GestureDetector(
                            onTap: () => setSelected(item),
                            child: Text(item.description))),
                        DataCell(GestureDetector(
                            onTap: () => setSelected(item),
                            child: Text(item.location))),
                        DataCell(GestureDetector(
                            onTap: () => setSelected(item),
                            child: Text(item.rfid))),
                        DataCell(Row(
                          children: [
                            //UPDATE ICON.
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _updateItem(item),
                              child: _hasPressedModify[getIndex(item)]
                                  ? const Icon(Icons.done, color: Colors.black)
                                  : const Icon(Icons.create,
                                      color: Colors.black),
                            ),

                            //DELETE ICON.
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _deleteItem(item),
                              child: _hasPressedDelete[getIndex(item)]
                                  ? const Icon(Icons.done, color: Colors.black)
                                  : const Icon(Icons.delete,
                                      color: Colors.black),
                            ),
                          ],
                        ))
                      ],
                      selected: getIndex(item) == _selectedIndex,
                    )),
              )
              .toList(),
        ),
      ),
    );
  }
}
