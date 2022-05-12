import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';


class UsersListPage extends StatefulWidget {
  UsersListPage({Key? key}) : super(key: key);

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {

   bool isSelectionMode = false;
  final int listLength = 12;
  late List<bool> _selected;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _selected = List<bool>.generate(listLength, (_) => false);
  }

  @override
  void dispose() {
    _selected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:ListBuilder(
                isSelectionMode: isSelectionMode,
                selectedList: _selected,
                onSelectionChange: (bool x) {
                  setState(() {
                    isSelectionMode = x;
                  });
                },
              ));
  }
}

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    Key? key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  }) : super(key: key);

  final bool isSelectionMode;
  final List<bool> selectedList;
  final Function(bool)? onSelectionChange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
      //Should get from database
      List<String> users = [
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

  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selectedList.length,
        itemBuilder: (_, int index) {
          return ListTile(
              onTap: () => _toggle(index),
              onLongPress: () {
                if (!widget.isSelectionMode) {
                  setState(() {
                    widget.selectedList[index] = true;
                  });
                  widget.onSelectionChange!(true);
                }
              },
              trailing: widget.isSelectionMode
                  ? Checkbox(
                      value: widget.selectedList[index],
                      onChanged: (bool? x) => _toggle(index),
                    )
                  : const SizedBox.shrink(),
              title: Text('$index : ' + users[index] + '@gmail.com'),

              
              );
        });
  }
}
