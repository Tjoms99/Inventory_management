import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/services/account_service.dart';

///A class of [Account].
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

///Returns an [Account] from a list of json [accounts].
///
///Returns a defualt [Account] if it does not exist.
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

///Returns an [Account] with default values.
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

///Returns true if [Account] has a default role.
bool isDefualt(Account account) {
  bool _isDefault = false;
  if (account.accountRole == "accountRole") _isDefault = true;

  return _isDefault;
}

///Returns true if [Account] has a user role.
bool isUser(Account account) {
  bool _isDefault = false;
  if (account.accountRole == "user") _isDefault = true;

  return _isDefault;
}

///Returns true if [Account] has a admin role.
bool isAdmin(Account account) {
  bool _isAdmin = false;

  if (account.accountRole == "admin") _isAdmin = true;

  return _isAdmin;
}

///Returns true if [Account] has a admin role.
bool isCustomer(Account account) {
  bool _isCustomer = false;
  if (account.accountRole == "customer") _isCustomer = true;

  return _isCustomer;
}

///Returns true if [Account.registeredCustomerId] is containing [Account.customerId].
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

///Returns true if [email] exists in [accounts].
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

///Returns [Account] if [rfid] exists in [accounts].
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

///Returns the modified [Account.registeredCustomerID].
///
///Modifies the [newID] using the "1" located in [itemCustomerID].
String getNewRegisteredCustomerID(String currentID, String itemCustomerID) {
  String newID = currentID;
  int indexCustomerId = itemCustomerID.indexOf("1");

  if (indexCustomerId == 0) {
    newID = "1" + newID.substring(1, newID.length);
  } else {
    newID = newID.substring(0, indexCustomerId) +
        "1" +
        newID.substring(indexCustomerId + 1, newID.length);
  }
  debugPrint("ID length: ${newID.length}");

  return newID;
}

///Removes the [account] from the [customer] list.
void updateAndRemoveFromCustomerList(Account account, Account customer) {
  int indexCustomerId = customer.customerId.indexOf("1");
  String newID = account.registeredCustomerId;

  if (indexCustomerId == 0) {
    newID = "0" + newID.substring(1, newID.length);
  } else {
    newID = newID.substring(0, indexCustomerId) +
        "0" +
        newID.substring(indexCustomerId + 1, newID.length);
    debugPrint("ID length: ${newID.length}");
  }
  account.registeredCustomerId = newID;
  updateAccountRegisteredCustomerID(account);

  debugPrint("Removed 1 at $indexCustomerId");
  debugPrint("Actual new ID:  $newID");
}

///Returns a customerID number as [String].
String getCustomerIDIndexAsString(String customerID) {
  return (customerID.indexOf('1') + 1).toString();
}

///Returns a customerID number as [String].
String getRegisteredCustomerIDIndexesAsString(String registeredCustomerID) {
  String indexes = "";
  for (int index = 0; index < 200; index++) {
    registeredCustomerID[index] == "1"
        ? indexes = indexes + (index + 1).toString() + ";"
        : indexes = indexes;
  }

  return indexes;
}

///Returns a customerID number as [String].
String getRegisteredCustomerIDFromIndexes(String registeredCustomerID) {
  List<int> numbers = [];
  String numberString = "";
  try {
    for (int index = 0; index < registeredCustomerID.length; index++) {
      if (registeredCustomerID[index] != ";") {
        numberString = numberString + registeredCustomerID[index];
      } else {
        numbers.add(int.parse(numberString));
        numberString = "";
      }
    }

    registeredCustomerID = "";
    for (int index = 0; index < 200; index++) {
      bool containsIndex = false;
      for (int number = 0; number < numbers.length; number++) {
        if (numbers[number] - 1 == index) containsIndex = true;
      }

      containsIndex
          ? registeredCustomerID = registeredCustomerID + "1"
          : registeredCustomerID = registeredCustomerID + "0";
    }
  } catch (e) {
    debugPrint("Could not get registered customer id from indexes");
  }
  return registeredCustomerID;
}
