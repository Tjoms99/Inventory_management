import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';



class AssistUserPage extends StatefulWidget {
  const AssistUserPage({Key? key}) : super(key: key);

  @override
  State<AssistUserPage> createState() => _AssistUserPageState();
}


class _AssistUserPageState extends State<AssistUserPage> {
  bool _isUserScanned = false; 

  @override
  void dispose() {
    super.dispose();
  }

  //TODO: get RFID from user card
  Future _updateState() async {
      if(_isUserScanned){
        _assignItem("testUser");
      }

     setState(() {
        _isUserScanned = !_isUserScanned;
      });
  }

  //TODO: get RFID from item and update database
  Future _assignItem(String username) async {
    print("assigned item to $username");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon
                GestureDetector(
                onTap: _updateState,
                child: const ImageIcon(
                  AssetImage("assets/images/rfid_transparent.png"),
                  color: Color.fromARGB(255, 37, 174, 53),
                  size: 100,
                ),
              ),
                //Hello
                Text(
                  _isUserScanned? 'Scan Item' : 'Scan User',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: secondFontSize),
                ),
                const SizedBox(height: firstBoxHeight),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
