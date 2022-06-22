import 'dart:convert';
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
  return rfid;
}
