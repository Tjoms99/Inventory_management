import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:http/http.dart' as http;

import '../../classes/account.dart';

class UsersListPage extends StatefulWidget {
  Account? currentAccount;

  UsersListPage(this.currentAccount);

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List accounts = [];
  @override
  void initState() {
    super.initState();
  }

  //Remove admin and customer accounts for everyone except admin
  void setAccounts() {
    print("account role ${widget.currentAccount?.accountRole}");
    if (widget.currentAccount?.accountRole == "admin") {
      return;
    }

    for (int index = 0; index < accounts.length; index++) {
      if (accounts[index]['account_role'] == "admin" ||
          accounts[index]['account_role'] == "customer") {
        print(accounts[index]['account_name']);
        accounts.removeAt(index);
      }
    }
  }

  Future<List> getAccounts() async {
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/getAccounts.php");
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
              print("Error");
            }
            if (snapshot.hasData) {
              accounts = snapshot.data as List;
              setAccounts();
              return ListBuilder(
                listToBuild: accounts,
                currentAccount: widget.currentAccount,
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
  Account? currentAccount;
  ListBuilder({this.listToBuild, this.currentAccount});

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
    //TODO edit this page
    if (_hasPressedModify) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(
              false,
              _email,
              widget.listToBuild![_selectedIndex]['id'],
              true,
              widget.currentAccount),
        ),
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

  // TODO: Delete user from database
  void _updateActionDelete() {
    String id = widget.listToBuild![_selectedIndex]['id'];
    print("Delete");
    print(id);

    setState(() {
      _hasPressedModify = false;
      if (_hasPressedDelete) {
        var uri = Uri.parse(
            "http://192.168.1.201/dashboard/flutter_db/deleteAccount.php");
        http.post(uri, body: {
          'id': id,
        });

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
