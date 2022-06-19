import 'package:flutter/material.dart';

import 'package:flutter_demo/actor_pages/customer_pages/add_item_page.dart';

import '../../classes/account.dart';
import '../../classes/item.dart';
import '../../server/item_service.dart';

class ItemsListPage extends StatefulWidget {
  Account currentAccount;
  ItemsListPage({required this.currentAccount});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListBuilder(
      currentAccount: widget.currentAccount,
    ));
  }
}

class ListBuilder extends StatefulWidget {
  Account currentAccount;
  ListBuilder({required this.currentAccount});

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

//TODO: Get items from database

//TODO: for each type (widget.listToBuild[index]) create expandable view; Show all instances of type in expandable view list (_items)
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
        future: getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //error
          }
          if (snapshot.hasData) {
            _items = snapshot.data as List<Item>;
            _types = getItemTypes(_items);
            print(_items);

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
            return const CircularProgressIndicator();
          }
        });
  }
}

//TODO: change list type from string to items
class ExpandableListView extends StatefulWidget {
  String title;
  List<Item> listToBuild;
  Account currentAccount;

  ExpandableListView(
      {required this.title,
      required this.listToBuild,
      required this.currentAccount});

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
  int _selectedIndex = -1;

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void modify() {
    print("Modify");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddItemPage(
              doAddItem: false, currentAccount: widget.currentAccount)),
    );
  }

  void delete() {
    print("Delete");
    setState(() {
      widget.listToBuild.removeAt(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: <Widget>[
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
                      rows: widget.listToBuild
                          .map(((item) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(item.status)),
                                  DataCell(Text(item.description)),
                                  DataCell(Text(item.location)),
                                  DataCell(Text(item.rfid)),
                                  DataCell(Row(
                                    children: const [
                                      Icon(Icons.create, color: Colors.black),
                                      Icon(Icons.delete, color: Colors.black),
                                    ],
                                  ))
                                ],
                                selected: true,
                              )))
                          .toList(),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

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
