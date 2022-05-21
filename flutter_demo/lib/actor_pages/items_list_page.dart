import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';

//TODO: Replace with edit items page
import 'package:flutter_demo/authentication_pages/register_page.dart';



class ItemsListPage extends StatefulWidget {
  ItemsListPage({Key? key}) : super(key: key);

  @override
  State<ItemsListPage> createState() => _ItemsListPageState();
}

class _ItemsListPageState extends State<ItemsListPage> {

  late List<String> _items;


  @override
  void initState() {
    super.initState();
    initializeItems();

  }

  //TODO: Init items from database
  void initializeItems() {
    _items = [
      'Book',
      'Pen',
      'Paper',
      'Calculator',
      'Chair',
      'Table'
    ];
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
              ListBuilder(
                listToBuild: _items,
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
      bool _hasPressedDelete = false;
      bool _hasPressedModify = false;
      int _selectedIndex = -1;


  void  _setSelectedIndex(int index) {
      setState(() {
        _selectedIndex = index;
        _hasPressedDelete = false;
        _hasPressedModify = false;
      });
  }

/** 
 * _updateActionModify
 * 
 * TODO: Update user in database
 */
  void _updateActionModify() {
    print("modify");
    //Go to update user page
    if(_hasPressedModify) {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage(false, 'Should go to edit items page')),
      );
    }

    //Update state
    setState(() {
      if(_hasPressedModify) {
        _hasPressedModify = false;

      } else {
        _hasPressedModify = true;
        _hasPressedDelete = false;
      }

    });
  }

/** 
 * _updateActionDelete
 * 
 * TODO: Delete user from database
 */
   void _updateActionDelete() {
    print("Delete");
    setState(() {
      _hasPressedModify = false; 
      if(_hasPressedDelete) {
        widget.listToBuild.removeAt(_selectedIndex);
        _hasPressedDelete = false;
      } else {
        _hasPressedDelete = true;
        _hasPressedModify = false;
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.listToBuild.length,
        itemBuilder: (_, int index) {
          return new ExpandableListView(title: "${widget.listToBuild[index]}");
        },
      );
  }
}



class ExpandableListView extends StatefulWidget {
  final String title;

  const ExpandableListView({Key? key, required this.title}) : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 5.0),
            child: new Row(
              children: <Widget>[
                new IconButton(
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
                new Text(
                  widget.title,
                  style: TextStyle(fontSize: 20),
                  )
              ],
            ),
          ),
          new ExpandableContainer(
              expanded: expandFlag,
              child: new ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    decoration:
                        new BoxDecoration(border: new Border.all(width: 1.0, color: Colors.white), color: Colors.white),
                    child: new ListTile(
                      //TODO: Import info from database 
                      title: new Text(
                        "$index\nRFID\nSTATUS\nPOSITION",
                        style: new TextStyle(color: Colors.black),
                      ),
                      trailing: Visibility(
                        //visible: 
                        child: Wrap(
                          spacing: 12, 
                          children: <Widget> [
                            Icon(Icons.create),
                            Icon(Icons.delete), 
                          ],
                        ),
                      ),

        
                    ),
                  );
                },
                //TODO: Fit to the items from the database
                itemCount: 15,
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

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
      ),
    );
  }
}