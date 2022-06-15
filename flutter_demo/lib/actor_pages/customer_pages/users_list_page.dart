import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:http/http.dart' as http;

class UsersListPage extends StatefulWidget {
  final bool _isAdmin;

  const UsersListPage(this._isAdmin);

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List> getAccounts() async {
    print("getaccounts 1");
    var uri = Uri.parse("http://192.168.1.201/dashboard/flutter_db/server.php");
    print(uri);
    final response = await http.get(uri);

    return jsonDecode(response.body);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
          future: getAccounts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.data);
              print(snapshot.connectionState);

              print("Error");
            }
            if (snapshot.hasData) {
              return ListBuilder(
                listToBuild: snapshot.data,
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}

class ListBuilder extends StatefulWidget {
  final List? listToBuild;
  const ListBuilder({this.listToBuild});

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  bool _hasPressedDelete = false;
  bool _hasPressedModify = false;
  int _selectedIndex = -1;

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _hasPressedDelete = false;
      _hasPressedModify = false;
    });
  }

  /// _updateActionModify
  ///
  /// TODO: Update user in database
  void _updateActionModify() {
    String _email = widget.listToBuild![_selectedIndex]['account_name'];

    print("modify");
    //Go to update user page
    if (_hasPressedModify) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage(false, _email)),
      );
    }

    //Update state
    setState(() {
      if (_hasPressedModify) {
        _hasPressedModify = false;
      } else {
        _hasPressedModify = true;
        _hasPressedDelete = false;
      }
    });
  }

  /// _updateActionDelete
  ///
  /// TODO: Delete user from database
  void _updateActionDelete() {
    print("Delete");
    setState(() {
      _hasPressedModify = false;
      if (_hasPressedDelete) {
        widget.listToBuild?.removeAt(_selectedIndex);
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
      itemCount: widget.listToBuild?.length,
      itemBuilder: (_, int index) {
        return ListTile(
          onTap: () => _setSelectedIndex(index),
          title: Text(
            widget.listToBuild![index]['account_name'],
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          subtitle: Text(
            widget.listToBuild![index]['account_role'],
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          selected: index == _selectedIndex,
          selectedTileColor: Colors.orange[200],
          trailing: Visibility(
            visible: _selectedIndex == index,
            child: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                GestureDetector(
                  onTap: _updateActionModify,
                  child: _hasPressedModify
                      ? const Icon(Icons.done, color: Colors.black)
                      : const Icon(Icons.create, color: Colors.black),
                ),
                GestureDetector(
                  onTap: _updateActionDelete,
                  child: _hasPressedDelete
                      ? const Icon(Icons.done, color: Colors.black)
                      : const Icon(Icons.delete, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
