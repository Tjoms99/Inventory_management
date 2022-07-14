import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:http/http.dart' as http;

import '../classes/account.dart';

///Returns a [List] of [Account]s from the database.
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

///Returns an [Account] from database using [Account.accountName].
///
///Returns a defualt [Account] if there was no match.
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

///Returns [Account] from database using [Account.accountName] and [Account.password].
///
///Returns a defualt [Account] if there was no match.
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

///Deletes [Account] with [Account.id] from the database.
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

///Inserts [Account] in the database.
///
///Returns error status.
Future<String> addAccount(Account account, String verificationCode) async {
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
      "verified": verificationCode,
    });

    return response.body;
  } catch (e) {
    debugPrint("Failed to add account: $e");
    return "-1";
  }
}

///Updates [Account] in the database.
///
///Returns error status.
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
    return "-1";
  }
}

///Updates [Account] with the new [Account.registeredCustomerId] in the database.
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

///Updates [Account] with the new [Account.registeredCustomerId] in the database.
Future<bool> verifyAccount(String verificationCode) async {
  bool _verificationCompleted = false;
  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/verifyAccount.php");

    var response = await http.post(uri, body: {
      'verificationCode': verificationCode,
    });

    if (response.body == "0") _verificationCompleted = true;
  } catch (e) {
    debugPrint("Failed to verify account: $e");
  }

  return _verificationCompleted;
}

///Returns [True] if [Account] is verified.
Future<bool> isAccountVerified(Account account) async {
  bool _isVerified = false;
  try {
    var uri = Uri.parse(
        "http://$ipAddress/dashboard/flutter_db/account/isAccountVerified.php");

    var response = await http.post(uri, body: {
      'account_name': account.accountName,
    });

    debugPrint(response.body);
    if (response.body == '"yes"') _isVerified = true;
  } catch (e) {
    debugPrint("Failed to verify account: $e");
  }

  return _isVerified;
}

///Sends an email to an [Account] with a verification code.
///
///The email is from [fromEmail].
Future sendEmail({
  required String fromEmail,
  required String verificationCode,
  required String toEmail,
}) async {
  const serviceId = 'service_b69xa24';
  const templateId = 'template_j6s3lnn';
  const userId = 'oTgX46OB8OyN3sYDr';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'from_email': fromEmail,
        'verification_code': verificationCode,
        'to_email': toEmail,
      }
    }),
  );
  debugPrint(response.body);
}
