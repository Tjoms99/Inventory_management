import 'dart:convert';

import 'package:flutter/material.dart';

class Account {
  int id;
  String accountName;
  String accountRole;
  String password;
  String rfid;
  String customerId;
  String registeredCustomerId;

  Account(
      {required this.id,
      required this.accountName,
      required this.accountRole,
      required this.password,
      required this.rfid,
      required this.customerId,
      required this.registeredCustomerId});
}

Account createAccountFromJson(List<dynamic> accounts, int index) {
  if (accounts[index] == null) {
    return createDefaultAccount();
  }

  return Account(
      id: jsonDecode(accounts[index]['id']),
      accountName: accounts[index]['account_name'] as String,
      accountRole: accounts[index]['account_role'] as String,
      password: accounts[index]['password'] as String,
      rfid: accounts[index]['rfid'] as String,
      customerId: accounts[index]['customer_id'] as String,
      registeredCustomerId:
          accounts[index]['registered_customer_id'] as String);
}

Account createDefaultAccount() {
  return Account(
      id: 0,
      accountName: "accountName",
      accountRole: "accountRole",
      password: "password",
      rfid: "rfid",
      customerId: "customerId",
      registeredCustomerId: "registeredCustomerId");
}

bool isDefualt(Account account) {
  bool _isDefault = false;
  if (account.accountRole == "accountRole") _isDefault = true;

  return _isDefault;
}

bool isUser(Account account) {
  bool _isDefault = false;
  if (account.accountRole == "user") _isDefault = true;

  return _isDefault;
}

bool isAdmin(Account account) {
  bool _isAdmin = false;

  if (account.accountRole == "admin") _isAdmin = true;

  return _isAdmin;
}

bool isCustomer(Account account) {
  bool _isCustomer = false;
  if (account.accountRole == "customer") _isCustomer = true;

  return _isCustomer;
}

bool isUserRegisteredAtCustomer(Account user, Account customer) {
  bool isRegistered = false;
  int indexCustomerId = customer.customerId.indexOf("1");

  if (user.registeredCustomerId.startsWith("1", indexCustomerId)) {
    debugPrint(
        "User ${user.accountName} is registered at this customer ${customer.accountName} ");
    isRegistered = true;
  }
  return isRegistered;
}

bool isAccountRegistered(List<Account> accounts, String email) {
  bool isRegistered = false;
  for (int index = 0; index < accounts.length; index++) {
    if (accounts[index].accountName == email) {
      isRegistered = true;
      break;
    }
  }
  return isRegistered;
}

Account getAccountUsingRFID(List<Account> accounts, String rfid) {
  Account account = createDefaultAccount();
  for (int index = 0; index < accounts.length; index++) {
    if (accounts[index].rfid.toUpperCase() == rfid.toUpperCase()) {
      account = accounts[index];
      debugPrint("Account ${account.accountName} found using rfid");
      break;
    }
  }

  return account;
}

String getNewRegisteredCustomerID(String currentID, String itemCustomerID) {
  String newID = currentID;
  int indexCustomerId = itemCustomerID.indexOf("1");

  newID = newID.substring(0, indexCustomerId) +
      "1" +
      newID.substring(indexCustomerId + 1, newID.length - 1);

  return newID;
}
