import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';

import 'package:flutter_demo/actor_pages/customer_pages/add_item_page.dart';

class ItemsListPage extends StatefulWidget {
  const ItemsListPage({Key? key}) : super(key: key);

  @override
  State<ItemsListPage> createState() => _ItemsListPageState();
}

class _ItemsListPageState extends State<ItemsListPage> {
  late List<String> _itemTypes;

  @override
  void initState() {
    super.initState();
    initializeItemTypes();
  }

  //TODO: Init items from database
  void initializeItemTypes() {
    _itemTypes = ['Book', 'Pen', 'Paper', 'Calculator', 'Chair', 'Table'];
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
      listToBuild: _itemTypes,
    ));
  }
}

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    Key? key,
    required this.listToBuild,
  }) : super(key: key);

  final List<String> listToBuild;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    initializeItems();
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }

  //TODO: Get items from database
  void initializeItems() {
    _items = [
      'RFID:     1234567890001\nSTATUS:      borrowed\nLOCATION:     marcus@gmail.com',
      'RFID:      1234567890002\nSTATUS:      borrowed\nLOCATION:     andreas@gmail.com',
      'RFID:      1234567890003\nSTATUS:      unassigned\nLOCATION:     inventory',
      'RFID:      1234567890004\nSTATUS:      unassigned\nLOCATION:     inventory',
      'RFID:      1234567890005\nSTATUS:      unassigned\nLOCATION:     inventory',
      'RFID:      1234567890006\nSTATUS:      unassigned\nLOCATION:     inventory',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listToBuild.length,
      itemBuilder: (_, int index) {
        return ExpandableListView(
            title: widget.listToBuild[index], listToBuild: _items);
      },
    );
  }
}

class ExpandableListView extends StatefulWidget {
  final String title;
  final List<String> listToBuild;

  const ExpandableListView(
      {Key? key, required this.title, required this.listToBuild})
      : super(key: key);

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
  int _selectedIndex = 0;

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void modify() {
    print("Modify");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemPage(false)),
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
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.white),
                        color: Colors.white),
                    child: ListTile(
                      //TODO: Import info from database
                      title: Text(
                        widget.listToBuild[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () => _setSelectedIndex(index),
                      selected: index == _selectedIndex,

                      trailing: Visibility(
                        visible: _selectedIndex == index,
                        child: Wrap(
                          spacing: 12,
                          children: <Widget>[
                            GestureDetector(
                              onTap: modify,
                              child: const Icon(Icons.create),
                            ),
                            GestureDetector(
                              onTap: delete,
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                //TODO: Fit to the items from the database
                itemCount: widget.listToBuild.length,
              ))
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
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
      ),
    );
  }
}