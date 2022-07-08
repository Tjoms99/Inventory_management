import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:http/http.dart' as http;

import '../classes/account.dart';

///Returns [accounts] from the database.
Future<List<Account>> getAccounts() async {
  List<Account> accounts = [];
  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/getAccounts.php");
    final response = await http.get(uri);

//Convert from json object to a list of Account(s).
    for (int index = 0; index < jsonDecode(response.body).length; index++) {
      Account account =
          createAccountFromJson(jsonDecode(response.body) as List, index);
      accounts.add(account);
    }
  } catch (e) {
    debugPrint("Failed to get accounts: $e");
  }

  return accounts;
}

///Returns [account] from database using [account.accountName].
///
///Returns a defualt account if there was no match.
Future<Account> getAccountFromName(String name) async {
  Account account = createDefaultAccount();

  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/getAccountFromName.php");
    final response = await http.post(uri, body: {
      "account_name": name,
    });

    final json = "[" + response.body + "]";
    if (response.body.isNotEmpty) {
      account = createAccountFromJson(jsonDecode(json) as List, 0);
    }
  } catch (e) {
    debugPrint("Failed to get account: $e");
  }

  return account;
}

///Returns [account] from database using [account.accountName] and [account.password].
///
///Returns a defualt account if there was no match.
Future<Account> getAccount(Account thisAccount) async {
  Account account = createDefaultAccount();

  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/getAccount.php");
    final response = await http.post(uri, body: {
      "account_name": thisAccount.accountName,
      "password": thisAccount.password,
      "rfid": thisAccount.rfid,
    });

    if (response.body.isNotEmpty) {
      debugPrint(response.body);
      final json = "[" + response.body + "]";
      debugPrint(json);
      account = createAccountFromJson(jsonDecode(json) as List<dynamic>, 0);
    }
  } catch (e) {
    debugPrint("Failed to get account: $e");
  }

  return account;
}

///Deletes account with [id] from the database.
void deleteAccount(int id) {
  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/deleteAccount.php");
    http.post(uri, body: {
      'id': jsonEncode(id),
    });
  } catch (e) {
    debugPrint("Failed to delete account: $e");
  }
}

///Inserts [account] in the database.
///
///Returns error status
Future<String> addAccount(Account account) async {
  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/addAccount.php");

    var response = await http.post(uri, body: {
      "account_name": account.accountName,
      "account_role": account.accountRole,
      "password": account.password,
      "rfid": account.rfid,
      "customer_id": account.customerId,
      "registered_customer_id": account.registeredCustomerId,
    });

    return response.body;
  } catch (e) {
    debugPrint("Failed to add account: $e");
  }

  return "-1";
}

///Updates [account] in the database.
///
///Returns error status
Future<String> updateAccount(Account account) async {
  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/updateAccount.php");

    var response = await http.post(uri, body: {
      'id': jsonEncode(account.id),
      "account_name": account.accountName,
      "account_role": account.accountRole,
      "password": account.password,
      "rfid": account.rfid,
      "customer_id": account.customerId,
      "registered_customer_id": account.registeredCustomerId,
    });

    return response.body;
  } catch (e) {
    debugPrint("Failed to update account: $e");
  }

  return "-1";
}

///Updates [account] with the new [account.registeredCustomerId] in the database.
void updateAccountRegisteredCustomerID(Account account) {
  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/updateAccountRegisteredCustomerID.php");

    http.post(uri, body: {
      'id': jsonEncode(account.id),
      "registered_customer_id": account.registeredCustomerId,
    });
  } catch (e) {
    debugPrint("Failed to update account: $e");
  }
}
