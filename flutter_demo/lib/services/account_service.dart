import 'dart:convert';
import 'package:http/http.dart' as http;

import '../classes/account.dart';

Future<List<Account>> getAccounts() async {
  List<Account> accounts = [];
  try {
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
  } catch (e) {}

  return accounts;
}

Future<Account> getAccount(Account thisAccount) async {
  Account account = createDefaultAccount();

  try {
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/getAccount.php");
    final response = await http.post(uri, body: {
      "account_name": thisAccount.accountName,
      "password": thisAccount.password,
    });

    final json = "[" + response.body + "]";
    print(jsonDecode(json));
    if (response.body.isNotEmpty) {
      account = createAccountFromJson(jsonDecode(json) as List, 0);
    }
  } catch (e) {}

  return account;
}

void deleteAccount(int id) {
  try {
    var uri = Uri.parse(
        "http://192.168.1.201/dashboard/flutter_db/deleteAccount.php");
    http.post(uri, body: {
      'id': jsonEncode(id),
    });
  } catch (e) {}
}

void addAccount(Account account) {
  try {
    var uri =
        Uri.parse("http://192.168.1.201/dashboard/flutter_db/addAccount.php");

    http.post(uri, body: {
      "account_name": account.accountName,
      "account_role": account.accountRole,
      "password": account.password,
      "rfid": account.rfid,
      "customer_id": account.customerId,
      "registered_customer_id": account.registeredCustomerId,
    });
  } catch (e) {}
}

void updateAccount(Account account) {
  try {
    var uri = Uri.parse(
        "http://192.168.1.201/dashboard/flutter_db/updateAccount.php");

    http.post(uri, body: {
      'id': jsonEncode(account.id),
      "account_name": account.accountName,
      "account_role": account.accountRole,
      "password": account.password,
      "rfid": account.rfid,
      "customer_id": account.customerId,
      "registered_customer_id": account.registeredCustomerId,
    });
  } catch (e) {}
}
