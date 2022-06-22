import 'dart:convert';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:http/http.dart' as http;

Future<String> getTotemRFID() async {
  String rfid = "";
  try {
//Fetch data from server
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/getTotemRFID.php");
    print(uri);

    final response = await http.get(uri);

    rfid = jsonDecode(response.body);
  } catch (e) {}
  return rfid.toUpperCase();
}

Future<String> getRFIDorNFC() async {
  var rfid = await getTotemRFID();
  var tagInfo;

  if (rfid.isNotEmpty) {
    print("got rfid!!!");
    print(rfid);
  } else {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      print("rfid not working");
      return rfid;
    } else {
      print("rfid working");
      try {
        NFCTag tag = await FlutterNfcKit.poll();
        tagInfo = jsonEncode(tag);
        tagInfo = jsonDecode(tagInfo);
        rfid = tagInfo['id'];
      } catch (e) {}
    }
  }
  return rfid;
}
