import 'package:flutter/material.dart';
import 'package:flutter_demo/Services/account_service.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:flutter_demo/classes/account.dart';

class UsersListPage extends StatefulWidget {
  final Account currentAccount;

  const UsersListPage({required this.currentAccount});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List<Account> accounts = [];
  @override
  void initState() {
    super.initState();
  }

  //Remove admin and customer accounts for everyone except admin
  void setAccounts() {
    if (isAdmin(widget.currentAccount)) {
      return;
    }
    debugPrint("Setting  correct accounts for correct user");
    for (int index = 0; index < accounts.length; index++) {
      //Remove all admins and customers
      if (isAdmin(accounts[index]) ||
          isCustomer(accounts[index]) ||
          !isUserRegisteredAtCustomer(accounts[index], widget.currentAccount)) {
        accounts.removeAt(index);

        //Update index due to list length change
        index = index - 1;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Account>>(
          future: getAccounts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //error
            }
            if (snapshot.hasData) {
              accounts = snapshot.data as List<Account>;
              setAccounts();
              return ListBuilder(
                listOfAccounts: accounts,
                currentAccount: widget.currentAccount,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class ListBuilder extends StatefulWidget {
  List<Account> listOfAccounts = [];
  Account currentAccount = createDefaultAccount();
  ListBuilder({required this.listOfAccounts, required this.currentAccount});

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

  void _updateActionModify() {
    String _email = widget.listOfAccounts[_selectedIndex].accountName;

    //Go to update user page
    if (_hasPressedModify) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(
              false,
              _email,
              widget.listOfAccounts[_selectedIndex].id,
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

  void _updateActionDelete() {
    int id = widget.listOfAccounts[_selectedIndex].id;

    setState(() {
      _hasPressedModify = false;
      if (_hasPressedDelete) {
        //Admin removes from system, customer removes from customer list
        if (isAdmin(widget.currentAccount)) {
          deleteAccount(id);
        } else {
          updateAndRemoveFromCustomerList(
              widget.listOfAccounts[_selectedIndex], widget.currentAccount);
        }
        widget.listOfAccounts.removeAt(_selectedIndex);

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
      itemCount: widget.listOfAccounts.length,
      itemBuilder: (_, int index) {
        return ListTile(
          onTap: () => _setSelectedIndex(index),
          title: Text(
            widget.listOfAccounts[index].accountName,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          subtitle: Text(
            widget.listOfAccounts[index].accountRole,
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
