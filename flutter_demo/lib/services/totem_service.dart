import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:http/http.dart' as http;

Future<String> getTotemRFID() async {
  String rfid = "";
  try {
//Fetch data from server
    var uri =
        Uri.parse("http://$ipAddress/dashboard/flutter_db/getTotemRFID.php");

    final response = await http.get(uri);

    rfid = jsonDecode(response.body);
  } catch (e) {
    debugPrint("Failed to get totem RFID: $e");
  }
  return rfid.toUpperCase();
}

Future<String> getServerIP() async {
  String ip = "";
  try {
//Fetch data from server
    var uri =
        Uri.parse("http://$ipAddress/dashboard/flutter_db/setServerIP.php");

    final response = await http.get(uri);

    ip = jsonDecode(response.body);
  } catch (e) {
    debugPrint("Failed to get totem RFID: $e");
  }
  return ip.toUpperCase();
}

Future<String> getRFIDorNFC() async {
  var rfid = await getTotemRFID();
  // ignore: prefer_typing_uninitialized_variables
  var tagInfo;

  if (rfid.isNotEmpty) {
    debugPrint("Got rfid from totem: $rfid");
  } else {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      debugPrint("NFC is not available");
      return rfid;
    } else {
      debugPrint("NFC is available");
      try {
        NFCTag tag = await FlutterNfcKit.poll();
        tagInfo = jsonEncode(tag);
        tagInfo = jsonDecode(tagInfo);
        rfid = tagInfo['id'];
      } catch (e) {
        debugPrint("Failed to get NFC tag: $e");
      }
    }
  }
  return rfid;
}
