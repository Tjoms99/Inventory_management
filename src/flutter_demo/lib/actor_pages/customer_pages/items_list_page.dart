import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/item_service.dart';

import 'package:flutter_demo/actor_pages/customer_pages/add_item_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/classes/item.dart';

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

///This is a page that builds a list of [Item]s for customers and admins
class ListBuilder extends StatefulWidget {
  final Account currentAccount;
  const ListBuilder({required this.currentAccount});

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  List<Item> _items = [];
  List<String> _types = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }

  ///Builds the [Item]s list page.
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return FutureBuilder<List<Item>>(
        future: isAdmin(widget.currentAccount)
            ? getItems()
            : getItemsForCustomer(widget.currentAccount),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //error
          }
          if (snapshot.hasData) {
            _items = snapshot.data as List<Item>;
            _types = getItemTypes(_items);
            debugPrint("Types of items:  $_types ");

            return ListView.builder(
              itemCount: _types.length,
              itemBuilder: (_, int index) {
                return ExpandableListView(
                  title: _types[index],
                  listToBuild: getItemsInType(_items, _types[index]),
                  currentAccount: widget.currentAccount,
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

///This is a page that expands a list of [Item]s on request.
class ExpandableListView extends StatefulWidget {
  String title;
  final List<Item> listToBuild;
  final Account currentAccount;

  ExpandableListView(
      {required this.title,
      required this.listToBuild,
      required this.currentAccount});

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddItemPage(
            currentAccount: widget.currentAccount,
            doAddItem: false,
            item: item,
          ),
        ),
      );
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
      _hasPressedModify[getIndex(item)] = false;
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
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: widget.title != ""
          ? Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: <Widget>[
                      //EXPANDABLE ICON.
                      IconButton(
                        icon: Icon(
                          expandFlag ? Icons.list_outlined : Icons.list,
                          size: 30.0,
                        ),
                        onPressed: () {
                          setState(() {
                            expandFlag = !expandFlag;
                          });
                        },
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),

                //EXPANDABLE LIST.
                ExpandableContainer(
                  expanded: expandFlag,
                  child: expandFlag
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Status',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Description',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Location',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'RFID',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Action',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],

                            //ITEMS IN EXPANDABLE LIST.
                            rows: widget.listToBuild
                                .map(((item) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(item.status)),
                                        DataCell(Text(item.description)),
                                        DataCell(Text(item.location)),
                                        DataCell(Text(item.rfid)),
                                        DataCell(Row(
                                          children: [
                                            //UPDATE ICON.
                                            GestureDetector(
                                              onTap: () => _updateItem(item),
                                              child: _hasPressedModify[
                                                      getIndex(item)]
                                                  ? const Icon(Icons.done,
                                                      color: Colors.black)
                                                  : const Icon(Icons.create,
                                                      color: Colors.black),
                                            ),

                                            //DELETE ICON.
                                            GestureDetector(
                                              onTap: () => _deleteItem(item),
                                              child: _hasPressedDelete[
                                                      getIndex(item)]
                                                  ? const Icon(Icons.done,
                                                      color: Colors.black)
                                                  : const Icon(Icons.delete,
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ))
                                      ],
                                      selected:
                                          getIndex(item) == _selectedIndex,
                                    )))
                                .toList(),
                          ),
                        )
                      : const SizedBox(),
                ),
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
      duration: const Duration(milliseconds: 125),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
      ),
    );
  }
}
