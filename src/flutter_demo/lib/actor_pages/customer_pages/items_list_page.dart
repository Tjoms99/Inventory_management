import 'package:flutter/material.dart';
import 'package:flutter_demo/services/item_service.dart';

import 'package:flutter_demo/actor_pages/customer_pages/add_item_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/page_route.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where customers or admins can add/modify/delete [Item]s.
class ItemsListPage extends StatefulWidget {
  final Account currentAccount;
  const ItemsListPage({required this.currentAccount});

  @override
  State<ItemsListPage> createState() => _ItemsListPageState();
}

class _ItemsListPageState extends State<ItemsListPage> {
  late List<String> _itemTypes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _itemTypes.clear();
    super.dispose();
  }

  ///Builds the item list view.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListBuilder(
      currentAccount: widget.currentAccount,
    ));
  }
}

///This is a page that builds a [List] of [Item]s for customers and admins.
class ListBuilder extends StatefulWidget {
  final Account currentAccount;
  const ListBuilder({required this.currentAccount});

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  List<Item> _items = [];
  List<Item> _allItems = [];

  List<String> _types = [];

  //Controller
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

      final input = _searchController.text.toLowerCase().trim();

      if (itemName.contains(input) ||
          itemDescription.contains(input) ||
          itemLocation.contains(input)) {
        return true;
      }
      return false;
    }).toList();

    suggestons.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    setState(() {
      _items = suggestons;
      _types = getItemTypes(_items);
    });
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
                }
                if (snapshot.hasData) {
                  _allItems = snapshot.data as List<Item>;
                  _isFirstLoad ? _searchItems() : debugPrint("Not first load");
                  _isFirstLoad = false;

                  debugPrint("Types of items:  $_types ");

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _types.length,
                    itemBuilder: (_, int index) {
                      return Column(
                        children: [
                          index == 0
                              ? const SizedBox(height: thirdBoxHeight)
                              : const SizedBox(),
                          ExpandableListView(
                            title: _types[index],
                            listToBuild: getItemsInType(_items, _types[index]),
                            currentAccount: widget.currentAccount,
                          ),
                          index == _types.length - 1
                              ? Container(
                                  color: Colors.white,
                                  height: 600,
                                  width: double.infinity,
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
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
class ExpandableListView extends StatefulWidget {
  String title;
  final List<Item> listToBuild;
  final Account currentAccount;

  ExpandableListView({
    required this.title,
    required this.listToBuild,
    required this.currentAccount,
  });

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool _expandFlag = false;
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
      setSelected(item);
      if (_hasPressedModify[getIndex(item)]) {
        clearPressedModify();
      } else {
        _hasPressedModify[getIndex(item)] = true;
        clearPressedDelete();
      }
    });
  }

  ///Goes to update [Item] page.
  void _deleteItem(Item item) {
    setState(() {
      setSelected(item);
      if (_hasPressedDelete[getIndex(item)]) {
        deleteItem(item.id);
        widget.listToBuild.removeAt(getIndex(item));
        if (widget.listToBuild.isEmpty) {
          widget.title = "";
        }

        clearPressedDelete();
      } else {
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
      child: widget.title != ""
          ? Column(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => {
                      setState(() {
                        _expandFlag = !_expandFlag;
                      })
                    },
                    child: Row(
                      children: <Widget>[
                        //EXPANDABLE ICON.
                        Icon(
                          _expandFlag ? Icons.list_outlined : Icons.list,
                          color: _expandFlag
                              ? Colors.orange[300]
                              : Colors.orange[700],
                          size: 40.0,
                        ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //EXPANDABLE LIST.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ExpandableContainer(
                    expanded: _expandFlag,
                    child: _expandFlag
                        ? ConstrainedBox(
                            constraints: BoxConstraints.expand(
                                width: MediaQuery.of(context).size.width),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                dataRowColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.orange[300];
                                  }
                                  return null; // Use the default value.
                                }),
                                columns: const <DataColumn>[
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
                                                  onTap: () =>
                                                      setSelected(item),
                                                  child: Text(item.status))),
                                              DataCell(GestureDetector(
                                                  onTap: () =>
                                                      setSelected(item),
                                                  child:
                                                      Text(item.description))),
                                              DataCell(GestureDetector(
                                                  onTap: () =>
                                                      setSelected(item),
                                                  child: Text(item.location))),
                                              DataCell(GestureDetector(
                                                  onTap: () =>
                                                      setSelected(item),
                                                  child: Text(item.rfid))),
                                              DataCell(Row(
                                                children: [
                                                  //UPDATE ICON.
                                                  GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () =>
                                                        _updateItem(item),
                                                    child: _hasPressedModify[
                                                            getIndex(item)]
                                                        ? const Icon(Icons.done,
                                                            color: Colors.black)
                                                        : const Icon(
                                                            Icons.create,
                                                            color:
                                                                Colors.black),
                                                  ),

                                                  //DELETE ICON.
                                                  GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () =>
                                                        _deleteItem(item),
                                                    child: _hasPressedDelete[
                                                            getIndex(item)]
                                                        ? const Icon(Icons.done,
                                                            color: Colors.black)
                                                        : const Icon(
                                                            Icons.delete,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ],
                                              ))
                                            ],
                                            selected: getIndex(item) ==
                                                _selectedIndex,
                                          )),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                )
              ],
            )
          : const SizedBox(),
    );
  }
}

///This class creates an expandable container.
class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  const ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  ///Builds an expandable container.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
      ),
    );
  }
}
