import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';


class UsersListPage extends StatefulWidget {
  UsersListPage({Key? key}) : super(key: key);

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {

  final int listLength = 12;
  late List<String> _users;


  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _users = List<String>.generate(listLength, (_) => 'empty');
  }

  @override
  void dispose() {
    _users.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
              ListBuilder(
                listToBuild: _users,
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
      int _selectedIndex = 0;
      
    //Should get from database
      List<String> _users = [
      'Mark',
      'Ron',
      'Sara',
      'Marcus',
      'Andreas',
      'Pietari',
      'Colari',
      'Dimitri',
      'Nico',
      'Beate',
      'Fillip',
      'Tobias'
    ];


  void  _setSelectedIndex(int index) {
      setState(() {
        _selectedIndex = index;
        _hasPressedDelete = false;
        _hasPressedModify = false;
      });
  }

  void _updateActionModify() {
    print("modify");
    setState(() {
      if(_hasPressedModify) {
        //Delete User 
        _hasPressedModify = false;
      } else {
        _hasPressedModify = true;
        _hasPressedDelete = false;
      }

    });
  }

   void _updateActionDelete() {
    print("Delete");
    setState(() {
      _hasPressedModify = false; 
      if(_hasPressedDelete) {
        //Modify user
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
          return ListTile(
              onTap: () => _setSelectedIndex(index),
              title: Text('$index : ${_users[index]} @gmail.com'),
              selected: index == _selectedIndex,

              trailing: Visibility(
                visible: _selectedIndex == index,
                child: Wrap(
                  spacing: 12, // space between two icons
                  children: <Widget>[
                    GestureDetector(
                      onTap: _updateActionModify,
                      child: _hasPressedModify ?  Icon(Icons.done) : Icon(Icons.create), // icon-1
                    ),
                    GestureDetector(
                      onTap: _updateActionDelete,
                      child: _hasPressedDelete ?  Icon(Icons.done) : Icon(Icons.delete) ,
                    ),
                  ],
                ),
              ),
               

              
              );
        });
  }
}
