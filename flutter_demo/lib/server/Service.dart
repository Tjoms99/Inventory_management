import 'dart:convert';
import 'package:http/http.dart' as http;

import '../classes/account.dart';

Future<List<Account>> getAccounts() async {
  List<Account> accounts = [];

//Fetch data from server
  var uri =
      Uri.parse("http://192.168.1.201/dashboard/flutter_db/getAccounts.php");
  final response = await http.get(uri);

//Convert from json object to a list of Account(s)
  for (int index = 0; index < jsonDecode(response.body).length; index++) {
    Account account =
        createAccountFromJson(jsonDecode(response.body) as List, index);
    accounts.add(account);
  }

  return accounts;
}

void deleteAccount(int id) {
  var uri =
      Uri.parse("http://192.168.1.201/dashboard/flutter_db/deleteAccount.php");
  http.post(uri, body: {
    'id': jsonEncode(id),
  });
}

void addAccount(Account account) {
  var uri =
      Uri.parse("http://192.168.1.201/dashboard/flutter_db/addAccounts.php");

  http.post(uri, body: {
    "account_name": account.accountName,
    "account_role": account.accountRole,
    "password": account.password,
    "rfid": account.rfid,
    "customer_id": account.customerId,
  });
}

void updateAccount(Account account) {
  var uri =
      Uri.parse("http://192.168.1.201/dashboard/flutter_db/updateAccount.php");

  http.post(uri, body: {
    'id': jsonEncode(account.id),
    "account_name": account.accountName,
    "account_role": account.accountRole,
    "password": account.password,
    "rfid": account.rfid,
    "customer_id": account.customerId,
  });
}
