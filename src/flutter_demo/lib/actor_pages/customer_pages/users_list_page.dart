import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/services/account_service.dart';
import 'package:flutter_demo/authentication_pages/register_page.dart';
import 'package:flutter_demo/classes/account.dart';
import 'package:flutter_demo/page_route.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

///This is a page where customers or admins can add/modify/delete [Account]s.
class UsersListPage extends StatefulWidget {
  final Account currentAccount;

  const UsersListPage({required this.currentAccount});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List<Account> accounts = [];
  List<Account> allAccounts = [];
  //Controller
  final TextEditingController _searchController = TextEditingController();
  //Focus node.
  final FocusNode _focusSearch = FocusNode();
  //Keyboard checker.
  bool _isKeyboardEnabled = false;
  bool _isFirstLoad = true;

  ///Updates [accounts] with content that is contained in [_searchController].
  Future _searchAccounts() async {
    var suggestons = allAccounts.where((account) {
      final accountName = account.accountName.toLowerCase();
      final input = _searchController.text.toLowerCase().trim();

      return accountName.contains(input);
    }).toList();

    suggestons.sort((a, b) {
      return a.accountName.toLowerCase().compareTo(b.accountName.toLowerCase());
    });

    setState(() {
      accounts = suggestons;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchAccounts);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  ///Builds the user list page.
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                                  onTap: () {
                                    setState(() {
                                      _isKeyboardEnabled = false;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: standardPadding,
                                        vertical: 10),
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
                              onTap: () {
                                setState(() {
                                  _isKeyboardEnabled = true;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: standardPadding, vertical: 10),
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

            FutureBuilder<List<Account>>(
                future: getAccounts(widget.currentAccount),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    //error
                  }
                  if (snapshot.hasData) {
                    allAccounts = snapshot.data as List<Account>;
                    _isFirstLoad
                        ? _searchAccounts()
                        : debugPrint("Not first load");
                    _isFirstLoad = false;

                    return ListBuilder(
                      listOfAccounts: accounts,
                      currentAccount: widget.currentAccount,
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
}

///This is a page that shows a [List] of [Account]s.
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

  ///Updates which [Icon] is pressed.
  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _hasPressedDelete = false;
      _hasPressedModify = false;
    });
  }

  ///Updates the current page to an [Account] modify page when [Icon] is pressed twice.
  void _updateActionModify() {
    String _email = widget.listOfAccounts[_selectedIndex].accountName;

    //Go to update user page.
    if (_hasPressedModify) {
      Navigator.of(context).push(PageRouter(
        child: RegisterPage(
            false,
            _email,
            widget.listOfAccounts[_selectedIndex].id,
            true,
            widget.currentAccount),
        direction: AxisDirection.down,
      ));
    }

    //Update state.
    setState(() {
      if (_hasPressedModify) {
        _hasPressedModify = false;
      } else {
        _hasPressedModify = true;
        _hasPressedDelete = false;
      }
    });
  }

  ///Deletes the selected [Account] when [Icon] is pressed twice.
  void _updateActionDelete() {
    int id = widget.listOfAccounts[_selectedIndex].id;

    setState(() {
      _hasPressedModify = false;
      if (_hasPressedDelete) {
        //Admin removes from system, customer removes from customer list.
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

  ///Builds the list page.
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
          selectedTileColor: Colors.orange[300],
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
