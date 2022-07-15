import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:http/http.dart' as http;

///Returns a [String] with the rfid that is stored in the database.
Future<String> getTotemRFID() async {
  String rfid = "";

  //Try to fetch data from server
  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/totem/getTotemRFID.php");
    final response = await http.post(uri, body: {
      'totem_id': totemID,
    });

    rfid = jsonDecode(response.body);
  } catch (e) {
    debugPrint("Failed to get totem RFID: $e");
  }
  return rfid.toUpperCase();
}

///Returns a [String] with the rfid tag that is scanned using [FlutterNfcKit].
Future<String> getNFC() async {
  String rfid = "";

  dynamic tagInfo;
  debugPrint("NFC is available");
  try {
    NFCTag tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 5));
    tagInfo = jsonEncode(tag);
    tagInfo = jsonDecode(tagInfo);
    rfid = tagInfo['id'];
  } catch (e) {
    debugPrint("Failed to get NFC tag: $e");
  }
  return rfid;
}

///Returns a [String] with the rfid recieved from a Totem or a NFC reader.
///
///The Totem rfid is retrieved from the database ever second for five seconds if [FlutterNfcKit.nfcAvailability] is false.
///The NFC reader is getting the rfid locally from the device if [FlutterNfcKit.nfcAvailability] is true.
Future<String> getRFIDorNFC() async {
  String rfid = "";

  var availability = await FlutterNfcKit.nfcAvailability;
  //If nfc is not available
  if (availability != NFCAvailability.available) {
    debugPrint("NFC is not available");
    await Future.delayed(const Duration(seconds: 1), () async {
      rfid = await getTotemRFID();
    });
    if (rfid.isNotEmpty) return rfid;

    await Future.delayed(const Duration(seconds: 1), () async {
      rfid = await getTotemRFID();
    });
    if (rfid.isNotEmpty) return rfid;

    await Future.delayed(const Duration(seconds: 1), () async {
      rfid = await getTotemRFID();
    });
    if (rfid.isNotEmpty) return rfid;

    await Future.delayed(const Duration(seconds: 1), () async {
      rfid = await getTotemRFID();
    });
    if (rfid.isNotEmpty) return rfid;

    await Future.delayed(const Duration(seconds: 1), () async {
      rfid = await getTotemRFID();
    });
    if (rfid.isNotEmpty) return rfid;
  } else {
    rfid = await getNFC();
    if (rfid.isNotEmpty) return rfid;
  }

  debugPrint("Returned rfid = " + rfid);
  return rfid;
}
