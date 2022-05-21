import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';



class UsersListPage extends StatefulWidget {
  UsersListPage({Key? key}) : super(key: key);

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {

  late List<String> _users;


  @override
  void initState() {
    super.initState();
    initializeUsers();

  }

  void initializeUsers() {
    //Should get users from database
    _users = [
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
    String _email = '${widget.listToBuild[_selectedIndex]}@gmail.com';

    print("modify");
    //Go to update user page
    if(_hasPressedModify) {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage(false, _email)),
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
          return ListTile(
              onTap: () => _setSelectedIndex(index),
              title: Text('${widget.listToBuild[index]}@gmail.com', style: TextStyle(color: Colors.black, fontSize: 20),),
              selected: index == _selectedIndex,
              selectedTileColor: Colors.orange[200],

              trailing: Visibility(
                visible: _selectedIndex == index,
                child: Wrap(
                  spacing: 12, // space between two icons
                  children: <Widget>[
                    GestureDetector(
                      onTap: _updateActionModify,
                      child: _hasPressedModify ?  Icon(Icons.done, color: Colors.black) : Icon(Icons.create, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: _updateActionDelete,
                      child: _hasPressedDelete ?  Icon(Icons.done, color: Colors.black) : Icon(Icons.delete, color: Colors.black) ,
                    ),
                  ],
                ),
              ),
            );
        },
      );
  }
}
